printh("Main")

function _init()
    printh("started init")
    
    --> create a map
    -- add_entity_tile(16, {
    --     name = "player",
    --     position = vec2(0, 0),
    --     internal_velocity = vec2(0, 0),
    --     movement = { speed=1, moving=false },
    --     player = 1,
    --     sprite = 1,
    --     animation = create_animation({1,2,3,4}, 4)
    -- })
    
    local player = create_entity(player)
    set_component(player, "position", vec2(4, 4))
    add_component(player, "sprite")
    set_animation(player, {1,2,3,4}, 4)
    set_component(player, "directional", {
        down = {1,2,3,4},
        right = {5,6,7,8},
        up = {9,10,11,12},
        facing = "down",
        idle_rate = 4,
        move_rate = 2
    })
    set_component(player, "internal_velocity", vec2(4, 4))
    set_component(player, "movement", { speed=1, moving = false})
    add_component(player, "player")
    add_component(player, "solid")
    set_component(player, "collider", { size=vec2(6, 6), offset=vec2(1, 1) })

    set_traveler(player)

    add_entity_tile(128, {
        name = "clover",
        position = vec2(0, 0),
        sprite = 1,
        animation = create_animation({128,143}, 4),
        talker = {
            size=vec2(12, 12),
            lines= { "feelin' lucky, punk? >:(" }
        }
    })
    
    add_entity_tile(156, {
        name = "root",
        position = vec2(0, 0),
        collider = { size=vec2(6, 6), offset=vec2(1, -1) },
        static = 1,
        solid = 1
    })
    
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
    add_entity_tile(247, {
        name = "grass",
        position = vec2(0, 0),
        sprite = 247,
        animation = create_animation({247,248,249,248}, 8),
    })

    add_entity_tile(16, {
        name = "guy",
        position = vec2(0, 0),
        sprite = 16,
        solid = 1,
        static = 1,
        collider = { size=vec2(4, 4), offset=vec2(2, 2) },
        talker = { size=vec2(14, 14), lines = {
            "how's it going?",
            "that's good to hear!"
        }}
    })
    add_entity_tile(255, {
        name = "to room 1",
        position = vec2(0, 0),
        room_transition = { target=1, size=vec2(8, 8), exit=vec2(1, 3) },
        sprite = 0
    })
    add_entity_tile(254, {
        name = "to room 2",
        position = vec2(0, 0),
        room_transition = { target=2, size=vec2(8, 8), exit=vec2(16, 3) },
        sprite = 0
    })
    
    create_rooms()
    load_room(1)

    --> initialize systems
    init_gameplay()
    init_physics()
    init_graphics()
    init_map()
    init_dialogue()

    --> report results
    printh("there are " .. #all_entities .. " entities")
    printh("there are " .. #systems .. " systems")
    printh("there are " .. #gfx_systems .. " gfx systems")

    printh("finished init")
end

function _update()
    call_systems(systems, all_entities)
    commit_destroy()
end

function _draw()
    --> clear screen
    disable_camera()
    rectfill(0, 0, 127, 127, clear_color)
    enable_camera()

    --> draw background
    draw_map("bg", 0)
    
    --> draw entities
    call_systems(gfx_systems, all_entities)
    commit_draw_queue()
    
    --> draw foreground
    draw_map("fg", 0.05)
    draw_map("fg", 0.1)

    --> draw foreground entities
    call_systems(gfx_front_systems, all_entities)
    commit_draw_queue()

    --> draw UI and other overlay elements
    call_systems(gfx_overlay_systems, all_entities)
end