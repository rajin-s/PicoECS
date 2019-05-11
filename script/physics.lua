--> components
--> position = vec2
--> velocity = vec2
--> weight   = float (not used yet)
--> drag     = float (percent reduction per frame)

--> system functions
function apply_velocity(entity)
    entity.position.x += entity.velocity.x
    entity.position.y += entity.velocity.y
end

function apply_internal_velocity(entity)
    entity.position.x += entity.internal_velocity.x
    entity.position.y += entity.internal_velocity.y
end

function drag_velocity(entity)
    entity.velocity.x = lerp(entity.velocity.x, 0, entity.drag.x)
    entity.velocity.y = lerp(entity.velocity.y, 0, entity.drag.y)
end

function apply_gravity(entity)
    entity.velocity.y += gravity_acceleration.y
    entity.velocity.x += gravity_acceleration.x
end

--> create physics systems
function init_physics()
    create_systems(systems, {
        {
            require = { "velocity", "drag" },
            exclude = { "frozen" },
            action = drag_velocity
        },
        {
            require = { "position", "velocity", "weight" },
            exclude = { "frozen" },
            action = apply_gravity
        },
        {
            require = { "position", "velocity" },
            exclude = { "frozen" },
            action = apply_velocity
        },
        {
            require = { "position", "internal_velocity" },
            exclude = { "frozen" },
            action = apply_internal_velocity
        },
    })
end