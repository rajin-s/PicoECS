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
    
    local player = create_entity("player")
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

    define_entity_tiles()
    
    create_rooms()
    load_room(1)

    --> initialize systems
    init_gameplay()
    init_physics()
    init_graphics()
    init_map()
    init_dialogue()

    --> report results
    -- printh("there are " .. #all_entities .. " entities")
    -- printh("there are " .. #systems .. " systems")
    -- printh("there are " .. #gfx_systems .. " gfx systems")

    printh("finished init")

    music(11)
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