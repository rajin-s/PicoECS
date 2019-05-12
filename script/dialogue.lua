--> components
--> textbox = { t, rate, height, background, foreground, chars, display, shown }
--> text    = string[]
--> talker  = { area_size, lines (string[]) }

--> global state
dialogue = nil
transition_min = -8

--> dialogue system functions
function show_textbox(entity, speaker_entity)
    if not entity.textbox.shown then
        entity.textbox.display = ""
        entity.textbox.line = 1
        entity.textbox.chars = 1
        entity.textbox.t = 0
        entity.textbox.transition = transition_min
        entity.textbox.shown = true
        entity.textbox.speaker = speaker_entity
    end
end

function close_textbox(entity)
    entity.textbox.shown = false
    entity.textbox.closing = true --> so you don't re-open a textbox if you're still in the trigger area
    entity.textbox.speaker = nil
end

function update_textbox(entity)
    local line = entity.text[entity.textbox.line]

    if entity.textbox.closing then
        entity.textbox.closing = false
    end

    if entity.textbox.shown then
        --> continue to next line
        if btnp(dialogue_button) then
            if entity.textbox.chars < #line then
                entity.textbox.chars = #line
                entity.textbox.display = line
                entity.textbox.t = entity.textbox.rate
            else
                if entity.textbox.line < #entity.text then
                    entity.textbox.line += 1
                    entity.textbox.display = ""
                    entity.textbox.chars = 1
                    entity.textbox.t = 0
                else
                    close_textbox(entity)
                end
            end
        end

        --> transition up
        if entity.textbox.transition < entity.textbox.height then
            entity.textbox.transition = lerp(entity.textbox.transition, entity.textbox.height, entity.textbox.transition_rate)
        end

        --> type in characters
        if entity.textbox.t == entity.textbox.rate then
            entity.textbox.t = 0
            if entity.textbox.chars ~= #line then
                entity.textbox.chars += 1
                entity.textbox.display = sub(line, 1, entity.textbox.chars)
            end
        else
            entity.textbox.t += 1
        end
    else
        --> transition down
        if entity.textbox.transition > transition_min then
            entity.textbox.transition = lerp(entity.textbox.transition, transition_min, entity.textbox.transition_rate)
        end
    end
end

--> uses current_traveler definied in map.lua
function track_traveler_dialogue(entity)
    local dialogue_entity = all_entities[dialogue]
    if current_traveler == nil then return
    else
        local traveler_position = vec2(
            current_traveler.position.x + 4,
            current_traveler.position.y + 4
        )
        local area_origin = vec2(
            entity.position.x - (entity.talker.size.x - 8) / 2,
            entity.position.y - (entity.talker.size.y - 8) / 2
        )
        if point_in_aabb(traveler_position, area_origin, entity.talker.size) then
            if not dialogue_entity.textbox.shown and not dialogue_entity.textbox.closing and btnp(dialogue_button) then
                set_component(dialogue, "text", entity.talker.lines)
                set_component(dialogue, "name", entity.name)
                show_textbox(dialogue_entity, entity)
            end
        elseif dialogue_entity.textbox.speaker == entity then
            close_textbox(dialogue_entity)
        end
    end
end

--> dialogue drawing functions
function draw_textbox(entity)
    if entity.textbox.transition > transition_min + 1 then
        disable_camera()
        palt(0, false)
        local min = vec2(0, 128 - entity.textbox.transition)
        local max = vec2(127, 128)
        rectfill(min.x, min.y, max.x, max.y, entity.textbox.background)
        rectfill(min.x, min.y, max.x, min.y, entity.textbox.foreground)
        print(entity.textbox.display, min.x + 3, min.y + 4, entity.textbox.foreground)
        
        local name_min = vec2(min.x + 3, min.y - 7)
        local name_max = vec2(name_min.x + 4 * #entity.name + 2, min.y)
        rectfill(name_min.x-1, name_min.y-1, name_max.x+1, name_max.y, entity.textbox.foreground)
        rectfill(name_min.x, name_min.y, name_max.x, name_max.y, entity.textbox.background)
        print(entity.name, name_min.x + 2, name_min.y + 2, entity.textbox.foreground)
        palt(0, true)
        enable_camera()
    end
end

--> create dialogue systems
function init_dialogue()
    dialogue = create_entity("nobody")
    set_component(dialogue, "textbox", {
        t = 0,
        transition = transition_min,
        line = 1,
        chars = 0,
        display = "debug",
        closing = false,
        
        speaker = nil,
        shown = false,

        transition_rate = 0.3,
        rate = 1,
        height = 19,
        background = 1,
        foreground = 6,
    })
    set_component(dialogue, "text", { 
        "this should not be seen"
    })

    create_systems(systems, {
        {
            require = { "textbox", "text" },
            exclude = { },
            action  = update_textbox  
        },
        {
            require = { "talker", "position" },
            exclude = { "locked" },
            action  = track_traveler_dialogue  
        }
    })
    create_systems(gfx_overlay_systems, {
        {
            require = { "textbox", "text" },
            exclude = { },
            action  = draw_textbox
        }
    })
end