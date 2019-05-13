--> gfx draw order
-->   map background layers  -> draw_map("bg")
-->   normal entities        -> gfx_systems
-->   map foreground layers  -> draw_map("fg")
-->   foreground entities    -> gfx_front_systems
-->   overlay entities       -> gfx_overlay systems

--> global state
camera_offset = vec2(0, 0)
draw_queue = { }

function enable_camera()
    camera(camera_offset.x, camera_offset.y)
end
function disable_camera()
    camera(0, 0)
end

function commit_draw_queue()
    sort(
        draw_queue,
        function(a,b)
            return a.position.y > b.position.y
        end
    )
    for entity in all(draw_queue) do
        if entity.flipped then
            spr(entity.sprite, entity.position.x, entity.position.y, 1, 1, true)
        else
            spr(entity.sprite, entity.position.x, entity.position.y)
        end
    end
    draw_queue = { }
end

--> component helpers
function set_animation(entity_id, nframes, nrate)
    set_component(entity_id, "animation", {
        t = nrate,
        rate = nrate,
        frame = 1,
        frames = nframes
    })
end

function create_animation(nframes, nrate)
    return {
        t = nrate,
        rate = nrate,
        frame = 1,
        frames = nframes
    }
end

function set_animation_offsets(entity_id, offsets, nrate)
    local entity = all_entities[entity_id]
    local nframes = {}
    for offset in all(offsets) do
        add(nframes, entity.sprite + offset)
    end
    set_component(entity_id, "animation", {
        t = nrate,
        rate = nrate,
        frame = 1,
        frames = nframes
    })
end

--> system functions
function draw_sprite(entity)
    add(draw_queue, entity)
end

function animate_sprite(entity)
    entity.animation.t += 1
    if entity.animation.t > entity.animation.rate then
        entity.animation.t = 0
        entity.animation.frame += 1

        if entity.animation.frame > #entity.animation.frames then
            entity.animation.frame = 1
        end
        entity.sprite = entity.animation.frames[entity.animation.frame]
    end
end

--> create graphics systems
function init_graphics()
    create_systems(gfx_systems, {
        {
            require = { "sprite", "animation" },
            exclude = { "hidden" },
            action  = animate_sprite
        },
        {
            require = { "position", "sprite" },
            exclude = { "hidden", "foreground" },
            action = draw_sprite
        },
    })
    
    create_systems(gfx_front_systems, {
        {
            require = { "position", "sprite", "foreground" },
            exclude = { "hidden" },
            action = draw_sprite
        },
    })
end