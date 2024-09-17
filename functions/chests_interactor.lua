-- chests_interactor.lua

local Movement = require("functions.movement")
local menu = require("menu")

local ChestsInteractor = {}

-- Initialize variables
local interactedObjects = {}
local expiration_time = 10 -- Time to stop when interacting with a chest

-- Function to move to and interact with an object
local function moveToAndInteract(obj)
    local player_pos = get_player_position()
    local obj_pos = obj:get_position()
    local distanceThreshold = 2.0
    local moveThreshold = menu.move_threshold_slider:get()
    local distance = obj_pos:dist_to(player_pos)
    
    if distance < distanceThreshold then
        Movement.set_interacting(true)
        local obj_name = obj:get_skin_name()
        interactedObjects[obj_name] = os.clock() + expiration_time
        interact_object(obj)
        console.print("Interacting with " .. obj_name)
        Movement.set_interaction_end_time(os.clock() + 5) -- 5 seconds interaction, adjust as needed
        return true
    elseif distance < moveThreshold then
        pathfinder.request_move(obj_pos)
        return false
    end
end

-- Function to interact with objects
function ChestsInteractor.interactWithObjects(doorsEnabled, interactive_patterns)
    local local_player = get_local_player()
    if not local_player then return end
    
    local objects = actors_manager.get_ally_actors()
    if not objects then return end
    
    for _, obj in ipairs(objects) do
        if obj then
            local obj_name = obj:get_skin_name()
            if obj_name and interactive_patterns[obj_name] then
                if doorsEnabled and (not interactedObjects[obj_name] or os.clock() > interactedObjects[obj_name]) then
                    if moveToAndInteract(obj) then
                        return
                    end
                end
            end
        end
    end
end

-- Function to clear interacted objects
function ChestsInteractor.clearInteractedObjects()
    interactedObjects = {}
    console.print("Cleared interacted objects list")
end

return ChestsInteractor