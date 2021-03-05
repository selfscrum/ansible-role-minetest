print("This file will be run at load time!")

minetest.register_node("git:repository", {
    description = "This is a git node",
    tiles = {"git-top-64.png","git-bottom-64.png","git-right-64.png","git-left-64.png","git-back-64.png","git-front-64.png"},
    groups = {cracky = 1},
    inventory_image = "git-64.png",
    sounds = default.node_sound_wood_defaults(),
    can_dig = function(pos)
        return minetest.get_meta(pos):get_inventory():is_empty("main")
    end,
    paramtype2 = "facedir",
    legacy_facedir_simple = true,
    groups = {choppy=2, oddly_breakable_by_hand=2},
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("infotext", "Git Chest")
        meta:set_string("formspec", "formspec_version[4] size[8,10]"..
                ((default and default.gui_bg) or "")..
                ((default and default.gui_bg_img) or "")..
                ((default and default.gui_slots) or "")..
                "label[0,0;Git Chest]"..
                "list[current_name;main;0,1;8,4;]"..
                "field[2,5.5;5,1;repo;Repo;${repo}]"..
                ((default and default.get_hotbar_bg) and default.get_hotbar_bg(0,6) or "")..
                "list[current_player;main;0,6;8,4;]"..
                "listring[]")
        local inv = meta:get_inventory()
        inv:set_size("main", 8*4)
end,
on_receive_fields = function(pos, _, fields, sender)
    local name = sender:get_player_name()
    if minetest.is_protected(pos, name) and not minetest.check_player_privs(name, {protection_bypass=true}) then
            minetest.record_protection_violation(pos, name)
            return
    end
    if fields.channel ~= nil then
            minetest.get_meta(pos):set_string("Repo",fields.repo)
    end
end,


})


minetest.register_alias("git", "git:repository")
