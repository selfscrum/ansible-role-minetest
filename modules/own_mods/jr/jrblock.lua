
local update_formspec = function(meta)
	local name = meta:get_string("name")
	local url = meta:get_string("url") or ""

	meta:set_string("formspec", "size[8,4;]" ..
		-- col 1
		"field[0.2,1;4,1;name;Name;" .. name .. "]" ..

		-- col 2
		"field[0.2,2;8,1;url;URL;" .. url .. "]" ..

		-- col 3
		"button_exit[0,3;8,1;save;Save]" ..
		"")

end

local on_receive_fields = function(pos, formname, fields, sender)

	if not jr.can_interact(pos, sender) then
		return
	end

	local meta = minetest.get_meta(pos)

	if fields.save then
		meta:set_string("name", fields.name)
		meta:set_string("url", fields.url)
	end

	update_formspec(meta)
end

function call_http()
	print("call http")
	jr.send_stats()
	local params = {method = "GET", data = { dataset = { username = "mtadmin" } } }
	-- jr.send_command("application/jobdata/tables/9FDE7EC1-3969-97A0-6F14-C4EBD742ECC1/datasets", params)
	jr.send_command("application/workitems/inbox", params)
	
  	-- minetest.after(jr.send_interval, send_stats)
end

local register_jrblock = function()

		minetest.register_node("jr:xjrblock_on" , {
			tiles = {
				"jr.png"
			},
			is_ground_content = false,
			groups = {cracky=3,dig_immediate=3, not_in_creative_inventory = 1, mesecon_effector_on = 1},
			drop = "jr:xjrblock_off 1",
			sounds = default.node_sound_glass_defaults(),
			light_source = minetest.LIGHT_MAX,
			mesecons = {effector = {
				rules = mesecon.rules.wallmounted_get,
				action_off = function (pos, node)
					-- do something to turn the effector off
					print("off")
					minetest.swap_node(pos, {name = "jr:xjrblock_off", param2 = node.param2})
				end
			}},
			on_blast = mesecon.on_blastnode
		})

	        minetest.register_node("jr:xjrblock_off" , {
			description = "JR Starter",
			tiles = {
				"jroff.png"
			},
			is_ground_content = false,
			groups = {cracky=3,dig_immediate=3, mesecon_receptor_off = 1, mesecon_effector_off = 1},
			on_construct = function(pos)
				local meta = minetest.get_meta(pos)

				meta:set_string("name", "<unconfigured>")
				meta:set_string("url", "")

				update_formspec(meta)
			end,
			on_receive_fields = on_receive_fields,
			sounds = default.node_sound_glass_defaults(),
			mesecons = {effector = {
				rules = mesecon.rules.wallmounted_get,
				action_on = function (pos, node)
					-- do something to turn the effector on
					call_http()
					print("on")
					minetest.swap_node(pos, {name = "jr:xjrblock_on", param2 = node.param2})
				end
			}},
			on_blast = mesecon.on_blastnode

        })

end

register_jrblock()

