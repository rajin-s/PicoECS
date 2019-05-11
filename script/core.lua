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