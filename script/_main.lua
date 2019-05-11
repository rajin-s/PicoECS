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
    set_animation(player, {1,2,3}, 4)
    set_component(player, "internal_velocity", vec2(4, 4))
    set_component(player, "movement", { speed=1, moving = false})
    add_component(player, "player")
    add_component(player, "solid")
    set_component(player, "collider", { size=vec2(6, 6), offset=vec2(1, 1) })

    set_traveler(player)

    add_entity_tile(129, {
        name = "torch",
        position = vec2(0, 0),
        sprite = 1,
        solid = 1,
        static = 1,
        collider = { size=vec2(4, 4), offset=vec2(2, 2) },
        animation = create_animation({129,130,131}, 3)
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
    
    add_room(vec2(0, 0), vec2(8, 8))
    add_room(vec2(7, 0), vec2(11, 8))
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
    system_update(all_entities)
    commit_destroy()
    if btn(5) then
        printh("there are " .. #all_entities .. " entities")
    end
end

function _draw()
    disable_camera()
    rectfill(0, 0, 127, 127, clear_color)
    enable_camera()
    
    draw_map()
    system_draw(all_entities)
    commit_draw_queue()
end