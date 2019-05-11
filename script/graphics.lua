--> global state
camera_offset = vec2(-64, -64)

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
    spr(entity.sprite, entity.position.x, entity.position.y)
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
            exclude = { "hidden" },
            action = draw_sprite
        },
    })
end