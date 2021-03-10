minetest.register_node("isr:logo", {
    description = "This is the ISR logo",
    tiles = {"isr_logo.png"},
    groups = {cracky = 1},
    inventory_image = "isr_logo.png",
    sounds = default.node_sound_glass_defaults()
})

minetest.register_node("isr:blue", {
    description = "This is the blue ISR color",
    tiles = {"isr_00a7e7.png"},
    groups = {cracky = 1},
    inventory_image = "isr_00a7e7.png",
    sounds = default.node_sound_glass_defaults()
})

minetest.register_node("isr:lightgreen", {
    description = "This is the lightgreen ISR color",
    tiles = {"isr_84c9bd.png"},
    groups = {cracky = 1},
    inventory_image = "isr_84c9bd.png",
    sounds = default.node_sound_glass_defaults()
})

minetest.register_node("isr:darkgreen", {
    description = "This is the darkgreen ISR color",
    tiles = {"isr_056478.png"},
    groups = {cracky = 1},
    inventory_image = "isr_056478.png",
    sounds = default.node_sound_glass_defaults()
})

minetest.register_node("isr:orange", {
    description = "This is the orange ISR color",
    tiles = {"isr_ff9c5b.png"},
    groups = {cracky = 1},
    inventory_image = "isr_ff9c5b.png",
    sounds = default.node_sound_glass_defaults()
})

minetest.register_node("isr:lightgrey", {
    description = "This is the lightgrey ISR color",
    tiles = {"isr_dadada.png"},
    groups = {cracky = 1},
    inventory_image = "isr_dadada.png",
    sounds = default.node_sound_glass_defaults()
})

minetest.register_alias("isr", "isr:logo")
