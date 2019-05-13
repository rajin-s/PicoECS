--> global configuration
clear_color = 1

gravity_acceleration = vec2(0, 20)
solid_tile_flag = 7

dialogue_button = 5

function define_entity_tiles()
    --> little clover
    add_entity_tile(128, {
        name = "clover",
        position = vec2(0, 0),
        sprite = 128,
        animation = create_animation({128,143}, 4),
        talker = {
            size=vec2(12, 12),
            lines= { "feelin' lucky, punk? >:(" }
        }
    })

    --> root base
    add_entity_tile(156, {
        name = "root",
        position = vec2(0, 0),
        collider = { size=vec2(6, 6), offset=vec2(1, -1) },
        static = 1,
        solid = 1
    })

    --> big clover
    add_entity_tile(131, {
        name = "plantpart",
        position = vec2(0, 0),
        sprite = 131,
        foreground = 1,
        animation = create_animation({131,141,173,141}, 8),
    })
    add_entity_tile(132, {
        name = "plantpart",
        position = vec2(0, 0),
        sprite = 132,
        foreground = 1,
        animation = create_animation({132,142,174,142}, 8),
    })
    add_entity_tile(147, {
        name = "plantpart",
        position = vec2(0, 0),
        sprite = 147,
        collider = { size=vec2(6,6), offset=vec2(5, 0)},
        solid = 1,
        static = 1,
        animation = create_animation({147,157,189,157}, 8),
    })
    add_entity_tile(148, {
        name = "plantpart",
        position = vec2(0, 0),
        sprite = 148,
        animation = create_animation({148,158,190,158}, 8),
    })
    
    --> flower
    add_entity_tile(245, {
        name = "flower",
        position = vec2(0, 0),
        sprite = 245,
        animation = create_animation({245,246}, 6),
        talker = {
            size=vec2(12, 12),
            lines= { "hi! i'm a flower :)" }
        }
    })

    --> grass
    add_entity_tile(247, {
        name = "grass",
        position = vec2(0, 0),
        sprite = 247,
        animation = create_animation({247,248,249,248}, 8),
    })

    --> raised ground collision
    add_entity_tile(200, {
        name = "cliff",
        position = vec2(0, 0),
        solid = 1,
        static = 1,
        collider = { size=vec2(2,6), offset=vec2(3,1) },
        sprite = 200
    })
    add_entity_tile(201, {
        name = "cliff",
        position = vec2(0, 0),
        solid = 1,
        static = 1,
        collider = { size=vec2(8,2), offset=vec2(0,1) },
        sprite = 201
    })
    add_entity_tile(202, {
        name = "cliff",
        position = vec2(0, 0),
        solid = 1,
        static = 1,
        collider = { size=vec2(2,6), offset=vec2(3,1) },
        sprite = 202,
    })
    add_entity_tile(216, {
        name = "cliff",
        position = vec2(0, 0),
        solid = 1,
        static = 1,
        collider = { size=vec2(2,6), offset=vec2(3,1) }
    })
    add_entity_tile(218, {
        name = "cliff",
        position = vec2(0, 0),
        solid = 1,
        static = 1,
        collider = { size=vec2(2,6), offset=vec2(3,1) }
    })
    add_entity_tile(232, {
        name = "cliff",
        position = vec2(0, 0),
        solid = 1,
        static = 1,
        collider = { size=vec2(5,7), offset=vec2(3,0) }
    })
    add_entity_tile(233, {
        name = "cliff",
        position = vec2(0, 0),
        solid = 1,
        static = 1,
        collider = { size=vec2(8,7), offset=vec2(0,0) }
    })
    add_entity_tile(234, {
        name = "cliff",
        position = vec2(0, 0),
        solid = 1,
        static = 1,
        collider = { size=vec2(5,7), offset=vec2(0,0) }
    })
    add_entity_tile(203, {
        name = "cliff",
        position = vec2(0, 0),
        solid = 1,
        static = 1,
        collider = { size=vec2(3,6), offset=vec2(3,2) }
    })
    add_entity_tile(204, {
        name = "cliff",
        position = vec2(0, 0),
        solid = 1,
        static = 1,
        collider = { size=vec2(3,6), offset=vec2(2,2) }
    })
    add_entity_tile(219, {
        name = "cliff",
        position = vec2(0, 0),
        solid = 1,
        static = 1,
        collider = { size=vec2(4,3), offset=vec2(3,1) }
    })
    add_entity_tile(220, {
        name = "cliff",
        position = vec2(0, 0),
        solid = 1,
        static = 1,
        collider = { size=vec2(4,3), offset=vec2(1,1) }
    })

    --> npcs
    add_entity_tile(17, {
        name = "gold",
        position = vec2(0, 0),
        sprite = 17,
        animation = create_animation({17,18,19,20}, 4),
        solid = 1,
        static = 1,
        collider = { size=vec2(4, 4), offset=vec2(2, 2) },
        talker = { size=vec2(14, 14), lines = {
            "greetings \137!",
            "this is all!",
            "did you \141\141 with \138\149?"
        }}
    })
    add_entity_tile(21, {
        name = "red",
        position = vec2(0, 0),
        sprite = 21,
        animation = create_animation({21,22,23,24}, 4),
        solid = 1,
        static = 1,
        collider = { size=vec2(4, 4), offset=vec2(2, 2) },
        talker = { size=vec2(14, 14), lines = {
            "greetings \137",
            "welcome to \130\138!",
            "talk \130, learn \146\141\146",
        }}
    })

    --> transitions
    add_entity_tile(32, {
        name = "forward h",
        position = vec2(0, 0),
        room_transition = { target=1, size=vec2(8, 128) },
        sprite = 0
    })
    add_entity_tile(33, {
        name = "forward v",
        position = vec2(0, 0),
        room_transition = { target=1, size=vec2(128, 8) },
        sprite = 0
    })
    add_entity_tile(34, {
        name = "back h",
        position = vec2(0, 0),
        room_transition = { target=-1, size=vec2(8, 128) },
        sprite = 0
    })
    add_entity_tile(35, {
        name = "back v",
        position = vec2(0, 0),
        room_transition = { target=-1, size=vec2(128, 8) },
        sprite = 0
    })

    -- --> test
    -- add_entity_tile(16, {
    --     name = "guy",
    --     position = vec2(0, 0),
    --     sprite = 16,
    --     solid = 1,
    --     static = 1,
    --     collider = { size=vec2(4, 4), offset=vec2(2, 2) },
    --     talker = { size=vec2(14, 14), lines = {
    --         "how's it going?",
    --         "that's good to hear!"
    --     }}
    -- })

    -- add_entity_tile(255, {
    --     name = "to room 1",
    --     position = vec2(0, 0),
    --     room_transition = { target=1, size=vec2(8, 8), exit=vec2(1, 3) },
    --     sprite = 0
    -- })
    -- add_entity_tile(254, {
    --     name = "to room 2",
    --     position = vec2(0, 0),
    --     room_transition = { target=2, size=vec2(8, 8), exit=vec2(16, 3) },
    --     sprite = 0
    -- })
end