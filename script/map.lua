--> components
--> room_transition = { target, size }
--> spawn_data = { room, tile_id, tile_position }

--> global state
all_rooms = {}
entity_tiles = {}
current_room = nil
current_traveler = nil

--> global state functions
function add_room(room_info)
    add(all_rooms, room_info)
end

function add_entity_tile(tile_id, entity_template)
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

--> set current global state and load entities from tiles
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
        local pixel_origin = vec2((16 - size.x) * 4, (16 - size.y) * 4)

        for ix = origin.x, origin.x + size.x do
            for iy = origin.y, origin.y + size.y do
                local cell_offset = vec2((ix - origin.x) * 8, (iy - origin.y) * 8) --> pixel offset from room origin
                for il = 1, #current_room.room.layers do
                    local rx = ix + current_room.room.size.x * (il - 1)
                    local has_entity_tile = false
                    local tile_content = mget(rx, iy)
                    for id, template in pairs(entity_tiles) do
                        if tile_content == id then
                            --> create entity from tile
                            has_entity_tile = true
                            local entity_id = instantiate_entity(template)
                            local entity = all_entities[entity_id]

                            --> set spawn data
                            set_component(entity_id, "spawn_data", { 
                                room = room_id,
                                tile_id = tile_content,
                                tile_position = vec2(rx, iy)
                            })
                            
                            --> set position
                            if has_component(entity, "position") then
                                set_component(entity_id, "position", add2(pixel_origin, cell_offset))
                            end

                            --> randomize animation frame
                            if has_component(entity, "animation") then
                                entity.animation.frame = flr(rnd(#entity.animation.frames))
                                entity.animation.t = flr(rnd(entity.animation.rate))
                            end
                            
                            --> remove tile if the entity has a sprite of its own
                            if has_component(entity, "sprite") then
                                mset(rx, iy, 0)
                            end

                            --> mark entities from foreground layers
                            if current_room.room.layers[il] == "fg" then
                                add_component(entity_id, "foreground")
                            end
                            
                            -- printh(
                                --     "entity tile: @[" .. ix .. ", " .. iy .. "] (" .. id .. ") -> @[" ..
                                --     all_entities[entity_id].position.x .. ", " .. all_entities[entity_id].position.y .. "] (" .. entity_id .. ")"
                                -- )
                            -- break
                        end
                    end
                    if not has_entity_tile and fget(tile_content, solid_tile_flag) then
                        --> create invisible collision object at tile
                        local solid_entity = create_entity("wall")
                        set_component(solid_entity, "position", add2(pixel_origin, cell_offset))
                        set_component(solid_entity, "collider", { size=vec2(8, 8), offset=vec2(0, 0) })
                        add_component(solid_entity, "solid")
                        add_component(solid_entity, "static")
                        set_component(solid_entity, "spawn_data", { 
                            room = room_id,
                            tile_id = tile_content,
                            tile_position = vec2(rx, iy)
                        })
                        -- printh("Create wall @[" .. ix*8 .. ", " .. iy*8 .. "]")
                    end
                end
            end
        end
        
        -- local pixel_size = vec2(
        --     current_room.room.size.x * 8,
        --     current_room.room.size.y * 8
        -- )
        -- local pixel_origin = vec2(
        --     current_room.room.origin.x * 8,
        --     current_room.room.origin.y * 8
        -- )
        -- camera_offset = vec2(
        --     pixel_origin.x - 64 + pixel_size.x / 2,
        --     pixel_origin.y - 64 + pixel_size.y / 2 
        -- )
    else
        printh("bad room id #" .. room_id .. "!")
    end
end

--> map drawing functions
function draw_map(layer_type, z_scale_factor)
    if current_room ~= nil then
        for i, ltype in pairs(current_room.room.layers) do
            local origin = current_room.room.origin
            local size = current_room.room.size

            if ltype == layer_type then
                map(
                    --> cell start (taking layers into account)
                    origin.x + (i - 1) * size.x, origin.y,
                    --> screen start
                    (16 - size.x) * 4, (16 - size.y) * 4,
                    --> cell count
                    size.x, size.y
                )
            end
        end
    end
end

--> map system functions
ttf = 0
function track_traveler(entity)
    if ttf ~= 0 then
        ttf = (ttf + 1) % 3
        return
    end
    if current_traveler == nil then return
    else
        local traveler_position = vec2(
            current_traveler.position.x + 4,
            current_traveler.position.y + 4
        )
        if point_in_aabb(traveler_position, entity.position, entity.room_transition.size) then
            -- current_traveler.position.x = entity.room_transition.exit.x * 8
            -- current_traveler.position.y = entity.room_transition.exit.y * 8
            load_room(current_room.id + entity.room_transition.target)

            if btn(0) then current_traveler.position.x = 128 - 16 end --> left
            if btn(1) then current_traveler.position.x = 16 end --> right
            if btn(2) then current_traveler.position.y = 128 - 16 end --> up
            if btn(3) then current_traveler.position.y = 16 end --> down
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