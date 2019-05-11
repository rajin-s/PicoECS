--> data structures
function vec2(nx, ny)
    return { x=nx, y=ny }
end
function vec3(nx, ny, nz)
    return { x=nx, y=ny, z=nz }
end

function lerp(from, to, percent)
    return from + (to - from) * percent
end
function lerp2(from, to, percent)
    return vec2(lerp(from.x, to.x, percent), lerp(from.y, to.y, percent))
end
function lerp3(from, to, percent)
    return vec3(lerp(from.x, to.x, percent), lerp(from.y, to.y, percent), lerp(from.z, to.z, percent))
end

function point_in_aabb(point, origin, size)
    if point.x < origin.x then return false end
    if point.y < origin.y then return false end
    if point.x >= origin.x + size.x then return false end
    if point.y >= origin.y + size.y then return false end
    return true
end

function aabb_overlap(aorigin, asize, borigin, bsize)
    local amax = vec2(
        aorigin.x + asize.x,
        aorigin.y + asize.y
    )
    local bmax = vec2(
        borigin.x + bsize.x,
        borigin.y + bsize.y
    )

    --> amount needed to prevent a from overlapping b by moving in a direction
    --> note: all positive
    local move_right = bmax.x - aorigin.x
    local move_left  = amax.x - borigin.x
    local move_up    = amax.y - borigin.y
    local move_down  = bmax.y - aorigin.y
    
    --> if the amount needed to move in any direction is negative, there is no overlap
    if move_right < 0 then return false end
    if move_left  < 0 then return false end
    if move_up    < 0 then return false end
    if move_down  < 0 then return false end
    
    local move_horizontal = 0
    local move_vertical   = 0
    
    --> see which x direction is smaller
    if move_right <= move_left then
        move_horizontal = move_right
    else
        move_horizontal = -move_left
    end
    
    --> see which y direction is smaller
    if move_down <= move_up then
        move_vertical = move_down
    else
        move_vertical = -move_up
    end

    --> see which axis is smaller
    if abs(move_horizontal) < abs(move_vertical) then
        return vec2(move_horizontal, 0)
    else
        return vec2(0, move_vertical)
    end
end

function copy_table(source)
    if type(source) == 'table' then
        local result = {}
        for k, v in pairs(source) do
            result[k] = copy_table(v)
        end
        return result
    else
        return source
    end
end

function to_string(value)
    return "" .. value
end