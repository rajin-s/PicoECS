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

function update_facing(entity)
    local moving = false
    if btn(0) then --> left
        moving = true
        if not btn(2) and not btn(3) and not btn(1) and entity.directional.facing~="left" then
            entity.animation.frames = entity.directional.right
            entity.animation.frame = 1
            entity.animation.t = entity.animation.rate
            entity.flipped = true
            entity.directional.facing = "left"
        end
    end
    if btn(1) then --> right
        moving = true
        if not btn(2) and not btn(3) and not btn(0) and entity.directional.facing~="right" then
            entity.animation.frames = entity.directional.right
            entity.animation.frame = 1
            entity.animation.t = entity.animation.rate
            entity.flipped = false
            entity.directional.facing = "right"
        end
    end
    if btn(2) then --> up
        moving = true
        if not btn(0) and not btn(1) and not btn(3) and entity.directional.facing~="up" then
            entity.animation.frames = entity.directional.up
            entity.animation.frame = 1
            entity.animation.t = entity.animation.rate
            entity.flipped = false
            entity.directional.facing = "up"
        end
    end
    if btn(3) then --> down
        moving = true
        if not btn(0) and not btn(1) and not btn(2) and entity.directional.facing~="down" then
            entity.animation.frames = entity.directional.down
            entity.animation.frame = 1
            entity.animation.t = entity.animation.rate
            entity.flipped = false
            entity.directional.facing = "down"
        end
    end

    if moving then
        entity.animation.rate = entity.directional.move_rate
    else
        entity.animation.rate = entity.directional.idle_rate
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
        {
            require = { "animation", "sprite", "directional" },
            exclude = { },
            action = update_facing
        }
    })
end