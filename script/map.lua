--> components
--> room_transition = { target, size }
--> spawn_data = { room, tile_id, tile_position }

--> global state
all_rooms = {}
entity_tiles = {}
current_room = nil
current_traveler = nil

--> global state functions
function add_room(norigin, nsize)
    add(all_rooms, { origin=norigin, size=nsize })
end

function add_entity_tile(tile_id, entity_template)
    -- add(entity_tiles, { id=tile_id, template=entity_template })
    entity_tiles[tile_id] = entity_template
end

function set_traveler(entity_id)
    local entity = all_entities[entity_id]
    if entity.position == nil then
        printh("bad traveler #" .. entity_id .. "!")
    else
        current_traveler = entity
    end
end

function load_room(room_id)
    printh("load room #" .. room_id)
    --> remove entities belonging to the current room
    if current_room == nil then
        printh("load first room")
    else
        clear_room_entities(current_room.id)
    end

    --> unload any room if passed id=0
    if room_id == 0 then
        current_room = nil
    elseif room_id <= #all_rooms then
        current_room = { id = room_id, room = all_rooms[room_id] }
        local origin = current_room.room.origin
        local size   = current_room.room.size
        for ix = origin.x, origin.x + size.x do
            for iy = origin.y, origin.y + size.y do
                for id, template in pairs(entity_tiles) do
                    if mget(ix, iy) == id then
                        local entity_id = instantiate_entity(template)
                        local entity = all_entities[entity_id]

                        set_component(entity_id, "spawn_data", { 
                            room = room_id,
                            tile_id = id,
                            tile_position = vec2(ix, iy)
                        })

                        if has_component(entity, "position") then
                            set_component(entity_id, "position", vec2(ix * 8, iy * 8))
                        end

                        if has_component(entity, "sprite") then
                            mset(ix, iy, 0)
                        end

                        -- printh(
                        --     "entity tile: @[" .. ix .. ", " .. iy .. "] (" .. id .. ") -> @[" ..
                        --     all_entities[entity_id].position.x .. ", " .. all_entities[entity_id].position.y .. "] (" .. entity_id .. ")"
                        -- )
                    end
                end
            end
        end
        
        local pixel_size = vec2(
            current_room.room.size.x * 8,
            current_room.room.size.y * 8
        )
        local pixel_origin = vec2(
            current_room.room.origin.x * 8,
            current_room.room.origin.y * 8
        )
        camera_offset = vec2(
            pixel_origin.x - 64 + pixel_size.x / 2,
            pixel_origin.y - 64 + pixel_size.y / 2 
        )
    else
        printh("bad room id #" .. room_id .. "!")
    end
end

function draw_map()
    if current_room ~= nil then
        map(
            current_room.room.origin.x, current_room.room.origin.y,         --> cell start
            current_room.room.origin.x * 8, current_room.room.origin.y * 8, --> screen start
            current_room.room.size.x, current_room.room.size.y              --> cell count
        )
    end
end

--> component helpers

--> system functions
function track_traveler(entity)
    if current_traveler == nil then return
    else
        local traveler_position = vec2(
            current_traveler.position.x + 4,
            current_traveler.position.y + 4
        )
        if point_in_aabb(traveler_position, entity.position, entity.room_transition.size) then
            current_traveler.position.x = entity.room_transition.exit.x * 8
            current_traveler.position.y = entity.room_transition.exit.y * 8
            load_room(entity.room_transition.target)
        end
    end

end

--> create systems
function init_map()
    create_systems(systems, {
        {
            require = { "room_transition", "position" },
            exclude = { "locked" },
            action  = track_traveler
        },
    })
end