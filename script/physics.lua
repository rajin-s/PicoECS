--> components
--> position = vec2
--> velocity = vec2
--> weight   = float (not used yet)
--> drag     = float (percent reduction per frame)
--> collider = { size, offset }
--> solid
--> static

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

--> resolve collisions between a and b as if b was static
function resolve_collisions(entity)
    for other_id, other_entity in pairs(all_entities) do
        if other_entity ~= entity and 
         has_component(other_entity, "position") and has_component(other_entity, "collider") and has_component(other_entity, "solid") then
            local overlap = aabb_overlap(
                add2(entity.position, entity.collider.offset), entity.collider.size,
                add2(other_entity.position, other_entity.collider.offset), other_entity.collider.size
            )
            if overlap then
                entity.sprite = 2
                entity.position.x += overlap.x
                entity.position.y += overlap.y
            else
                entity.sprite = 3
            end
        end
    end
end

--> create physics systems
function init_physics()
    create_systems(systems, {
        {
            require = { "velocity", "drag" },
            exclude = { "frozen" },
            action  = drag_velocity
        },
        {
            require = { "position", "velocity", "weight" },
            exclude = { "frozen" },
            action  = apply_gravity
        },
        {
            require = { "position", "velocity" },
            exclude = { "frozen" },
            action  = apply_velocity
        },
        {
            require = { "position", "internal_velocity" },
            exclude = { "frozen" },
            action  = apply_internal_velocity
        },
        {
            require = { "position", "collider", "solid" },
            exclude = { "static" },
            action  = resolve_collisions
        }
    })
end