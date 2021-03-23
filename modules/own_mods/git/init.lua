-- github api pseudocode for repo listing:
-- always use https://api.github.com
-- get repos/:user/:repo -> default_branch
-- get https://api.github.com/repos/:user/:repo/git/trees/:default_branch
-- for results:
--     path  -> name (if blob leaf)
--     sha   -> id for retrieval
--     type  -> tree for next directory level
--           -> blob for file
--     url   -> url for retrieval (makes sha unnecessary)

-- github api pseudocode for repo listing:


-- function decls
local chdir
local create_git_repo
local dec
local formspec_string
local get_file
local nodepath_to_string

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- must move them elswhere
local function get_token() 
    return "102c86efc39b24971e0d36dd811e88901719d6f1"
end
local http = minetest.request_http_api()
local currentdir={}

-- debugging aid
local function dumptable(t,msg)
    for k,v in pairs(t) do
        minetest.log("verbose",msg..">>>>"..k.."<<,>>"..tostring(v).."<<")
    end
end

-- node for one git directory level. 
-- It is designed to support lazy loading - The tree is not created recursively on load of the repo but only if a user
-- opens the next level, it will be loaded.
-- memo to self - does garbage collection work later if we just set the top node to nil?
--
gnode = {
    url = "",
    path = "",
    type = "",
    pos = {},
    children = nil,
    parent = nil,
    -- constructor
    new =   function (self, o)
                o = o or {}
                setmetatable(o, self)
                self.__index = self
               return o
            end,
    -- fills one level method and updates the formspec_string of the form asynchronously.
    fill =  function (self)
                -- if self.children then
                --     meta:set_string("formspec", formspec_string(self))
                --     return
                -- end
                local meta = minetest.get_meta(self.pos)
                if http then
                    http.fetch(
                        {
                        url           = self.url,
                        extra_headers = { "Authorization: token "..get_token() },
                        timeout       = 5
                        }, 
                        function(response)
                            if not response.succeeded then return end
                            local data = minetest.parse_json(response.data)
                            self.children = {}
                            for i, value in ipairs(data.tree) do
                                local g = gnode:new()
                                g.url  = value.url
                                g.path = value.path
                                g.type = value.type
                                if g.path ~= "/" then g.parent = self end
                                g.pos = self.pos
                                table.insert (self.children, g)
                                meta:set_string("formspec", formspec_string(self))
                            end
                        end
                    )
                end
            end
}

-- change to another git directory, and load node file list if dir changed
--
function chdir(current_dir, idx)
    -- return parent for ".."
    if idx == 1 and current_dir.parent then
        current_dir.parent:fill()
        return current_dir.parent
    end

    -- correct index for leading ".." entry
    if current_dir.parent then 
        idx = idx - 1
    end

    -- change only if selected node is tree
    if current_dir.children[idx].type == "tree" then
        current_dir.children[idx]:fill()
        return current_dir.children[idx]
    else
        get_file(current_dir.children[idx])
    end
    return current_dir
end

-- create the complete text path of a node from root to here. Ends with "/"
--
function nodepath_to_string(node)
    if not node.parent then return "/" end
    return nodepath_to_string(node.parent)..node.path.."/"
end

-- set the formspec string according to the internal status
--
function formspec_string(node)
    local items = {}
    if node.path ~= "/" then
        table.insert(items,"#000000..")
    end
    if node.children then
        for i,child in pairs(node.children) do
            if child.type == "tree" then
                table.insert(items,"#FF0000"..child.path)
            else
                table.insert(items,"#000000"..child.path)
            end
        end
    end

    local s =   "formspec_version[4] "..
                "size[10,10] "..
                "no_prepend[] " ..
                "style_type[*;font=mono;font_size=*0.9;textcolor=black]"..
                "bgcolor[#f0f0f0] "..
                "box[0.05,0.05;9.9,9.9;#f05033ff] "..
                "box[0.1,0.1;9.8,9.8;#f0f0f0ff] "..
                "style_type[label;textcolor=#3e3e3eff] "..
                "label[5,0.5;".. nodepath_to_string(node) .."] "..
--                "item_image[8.8,0.2;1,1;git] "..                
                "box[0.2,0.2;4,9.6;#e0e0e0ff] "..
                "scrollbar[4.2,0.2;0.3,9.6;vertical;filescrollbar;0] "..            
                "set_focus[gitlist] "..
                "scroll_container[0.2,0.2;4,9.6;filescrollbar;vertical;0.1] "..
                "textlist[0,0;4,9.6;gitlist;".. table.concat(items,",") ..";2;true] "..
                "scroll_container_end[] "
    return s
end

-- create the root node of the repo and set the initial formspec string asynchronously.
--
function create_git_repo(pos,user,repo)
    local url = "https://api.github.com/repos/"..user.."/"..repo
    local meta = minetest.get_meta(pos)
    if http then
        minetest.get_meta(pos):set_string("Repo",repo)
        minetest.get_meta(pos):set_string("RepoUser",user)
        http.fetch(
            {
            url           = url,
            extra_headers = { "Authorization: token "..get_token() },
            timeout       = 5
            }, 
            function(response)
                if not response.succeeded then return end
                local entry = minetest.parse_json(response.data)
                if not entry then return end
                local g = gnode:new({url = url.."/git/trees/"..entry.default_branch, "/", path = "/", type = "tree", pos = pos})
                g:fill()
                currentdir[dump(pos)]=g
                minetest.get_meta(pos):set_string("formspec", formspec_string(g))
            end
        )
    end
end

-- get the content of a git repo file and send it to a digiline
--
function get_file(node)
    local path = string.sub(nodepath_to_string(node),1,-1)
    local meta = minetest.get_meta(node.pos)
    local repo = meta:get_string("Repo")
    local user = meta:get_string("RepoUser")
    local url  = "https://api.github.com/repos/"..user.."/"..repo.."/contents"..path
    if http then
        http.fetch(
            {
            url           = url,
            extra_headers = { "Authorization: token "..get_token() },
            timeout       = 5
            }, 
            function(response)
                dumptable(response,"GET_FILE")
                if not response.succeeded then return end
                local entry = minetest.parse_json(response.data)
                if not entry then return end
                dumptable(entry,"GET_FILE_ENTRY")
                local str=dec(entry.content)
                -- lines = {}
                -- for s in str:gmatch("[^\r\n]+") do
                --     table.insert(lines, s)
                --     digiline:receptor_send(node.pos, digiline.rules.default, "test", s)
                -- end
                digiline:receptor_send(node.pos, digiline.rules.default, "test", str)
            end
        )
    end
end

-- decoding base64 strings
--
function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

-- register the git chest
--
minetest.register_node("git:repository", 
    {
    description           = "This is a git node",
    tiles                 = { "git-top-64.png","git-bottom-64.png","git-right-64.png","git-left-64.png","git-back-64.png","git-front-64.png" } ,
    groups                = { cracky = 1,dig_immediate=2,choppy=3 },
    inventory_image       = "git-icon.png",
    sounds                = default.node_sound_wood_defaults(),
    can_dig               = function(pos)
                                return minetest.get_meta(pos):get_inventory():is_empty("main")
                            end,
    paramtype2            = "facedir",
    legacy_facedir_simple = true,
    groups                = {choppy=2, oddly_breakable_by_hand=2},
    on_construct          = function(pos)
                                create_git_repo (pos,"selfscrum","private")
                            end,
    on_destruct           = function(pos)
                            currentdir[dump(pos)] = nil
                            end,                         
    on_rightclick         = function(pos, node, clicker, itemstack, pointed_thing)
                                if not default.can_interact_with_node(clicker, pos) then
                                    return itemstack
                                end
--                                minetest.get_meta(pos):set_string("formspec", formspec_string(currentdir[dump(pos)]))
                                minetest.sound_play("default_chest_open", {gain = 0.3, pos = pos, max_hear_distance = 10}, true)
                            end,
    on_receive_fields     = function(pos, _, fields, sender)
                                local name = sender:get_player_name()
                                if minetest.is_protected(pos, name) and not minetest.check_player_privs(name, {protection_bypass=true}) then
                                        minetest.record_protection_violation(pos, name)
                                        return
                                end

                                --# play close sound if quit
                                for key,value in pairs(fields) do
                                    if key == "quit" and value then
                                        minetest.sound_play("default_chest_close", {gain = 0.3, pos = pos, max_hear_distance = 10}, true)
                                    end
                                end

                                if fields.gitlist ~= nil then
                                    local sep = string.find(fields.gitlist,":")
                                    if sep == nil then 
                                        return
                                    end
                                    local action = string.sub(fields.gitlist,1,sep-1)
                                    local param = string.sub(fields.gitlist,sep+1)
                                    if action == "DCL" then
                                        currentdir[dump(pos)] = chdir(currentdir[dump(pos)], tonumber(param))
                                    elseif action == "CHG" then

                                    end
                                end
                            
                                if fields.channel ~= nil then
                                        minetest.get_meta(pos):set_string("Repo",fields.repo)
                                end
                            end,
    digiline              = {
                            receptor = {}
                            },
    }
)

minetest.register_alias("git", "git:repository")
