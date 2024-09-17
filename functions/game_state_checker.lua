-- game_state_checker.lua

local GameStateChecker = {}

-- Function to check if in loading screen
function GameStateChecker.is_loading_screen()
    local world_instance = world.get_current_world()
    if world_instance then
        local zone_name = world_instance:get_current_zone_name()
        return zone_name == nil or zone_name == ""
    end
    return true
end

-- Function to check if in Helltide
function GameStateChecker.is_in_helltide(local_player)
    if not local_player then return false end

    local buffs = local_player:get_buffs()
    if not buffs then return false end

    for _, buff in ipairs(buffs) do
        if buff and buff.name_hash == 1066539 then
            return true
        end
    end
    return false
end

return GameStateChecker