print("This file will be run at load time!")

minetest.register_node("rfnl:logo", {
    description = "This is a rfnl node",
    tiles = {"rfnl_logo.png"},
    groups = {cracky = 1},
    inventory_image = "rfnl_logo.png",
    sounds = default.node_sound_glass_defaults()
})

minetest.register_alias("rfnl", "rfnl:logo")
