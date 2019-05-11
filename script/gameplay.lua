--> components
--> movement = { speed, moving }

--> system functions
function do_topdown_input(entity)
    local input = vec2(false, false)
    if btn(0) then --> left
        entity.internal_velocity.x = -entity.movement.speed
        input.x = true
    end
    if btn(1) then --> right
        entity.internal_velocity.x = entity.movement.speed
        input.x = true
    end
    if btn(2) then --> up
        entity.internal_velocity.y = -entity.movement.speed
        input.y = true
    end
    if btn(3) then --> down
        entity.internal_velocity.y = entity.movement.speed
        input.y = true
    end
    if not input.x then
        entity.internal_velocity.x = 0
    end
    if not input.y then
        entity.internal_velocity.y = 0
    end
    if input.x or input.y then
        entity.movement.moving = true
    else
        entity.movement.moving = false
    end
end

--> create systems
function init_gameplay()
    create_systems(systems, {
        {
            require = { "internal_velocity", "movement", "player" },
            exclude = { },
            action  = do_topdown_input
        },
    })
end