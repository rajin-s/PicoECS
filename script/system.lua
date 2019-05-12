--> for debugging
function do_nothing(entity) end
function report_entity(entity) printh(entity.name) end

--> global system collections
systems = { }
gfx_systems = { }
gfx_front_systems = { }
gfx_overlay_systems = { }

--> called from system scripts (physics, graphics, gameplay, etc.)
function create_system(collection, nsystem)
    add(collection, nsystem)
end
function create_systems(collection, nsystems)
    for nsystem in all(nsystems) do
        create_system(collection, nsystem)
    end
end

--> should a system act on an entity?
function check_system(system, entity)
    if entity == nil then
        return false
    end
    
    for component in all(system.require) do
        if not has_component(entity, component) then
            --> printh("success")
            return false
        end
    end
    for component in all(system.exclude) do
        if has_component(entity, component) then
            --> printh("fail")
            return false
        end
    end
    return true
end

--> called all systems in a collection on a set of entities
function call_systems(collection, entities)
    for system in all(collection) do
        for id, entity in pairs(entities) do
            if check_system(system, entity) then
                system.action(entity)
            end
        end
    end
end