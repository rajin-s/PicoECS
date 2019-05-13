--> global entity list (id -> entity map)
all_entities = { }
to_destroy = { }
next_entity_id = 1

component_lists = { }

--> create an entity and return its ID
function create_entity(nname)
    local id = to_string(next_entity_id)
    all_entities[id] = { name = nname }
    next_entity_id += 1
    return id
end

function instantiate_entity(template)
    local id = to_string(next_entity_id)
    local entity = copy_table(template)
    all_entities[id] = entity
    next_entity_id += 1
    
    for component_name, value in pairs(entity) do
        if component_lists[component_name] == nil then component_lists[component_name] = {} end
        add(component_lists[component_name], entity)
    end
    return id
end

function destory_entity(entity_id)
    add(to_destroy, entity_id)
end

function commit_destroy()
    for entity_id in all(to_destroy) do
        all_entities[entity_id] = nil
        -- del(all_entities, entity_id)
    end

    --> regenerate component lists
    component_lists = {}
    for id, entity in pairs(all_entities) do
        for component_name, value in pairs(entity) do
            if component_lists[component_name] == nil then component_lists[component_name] = {} end
            add(component_lists[component_name], entity)
        end
    end
    to_destroy = {}
end

--> Clear entities with spawn data matching the given room id
function clear_room_entities(room_id)
    for id, entity in pairs(all_entities) do
        if has_component(entity, "spawn_data") and entity.spawn_data.room == room_id and not has_component(entity, "persistent") then
            if not has_component(entity, "no_respawn") then
                mset(
                    entity.spawn_data.tile_position.x, entity.spawn_data.tile_position.y,
                    entity.spawn_data.tile_id
                )
                -- printh(
                --     "reset tile: @" .. entity.spawn_data.tile_position.x .. ", " .. entity.spawn_data.tile_position.y .. " -> " .. entity.spawn_data.tile_id
                -- )
            end
            destory_entity(id)
        end
    end
end

--> components
function add_component(entity_id, name)
    all_entities[entity_id][name] = 1
    
    if component_lists[name] == nil then component_lists[name] = {} end
    add(component_lists[name], all_entities[entity_id])
end
function set_component(entity_id, name, value)
    all_entities[entity_id][name] = value
    
    if component_lists[name] == nil then component_lists[name] = {} end
    add(component_lists[name], all_entities[entity_id])
end
function remove_component(entity_id, name)
    all_entities[entity_id][name] = nil
    del(component_lists[name], all_entities[entity_id])
end
function has_component(entity, name)
    if entity[name] == nil then
        return false
    else
        return true
    end
end