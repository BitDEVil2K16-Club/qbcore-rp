-- Get the directory of the current script
local function getScriptDir()
    local str = debug.getinfo(2, 'S').source:sub(2)
    return str:match('(.*/)')
end

-- Get current script's directory and build path to qb-core
local currentDir = getScriptDir() -- Should be: .../scripts/qb-garages/Shared/locales/
local qbCorePath = currentDir .. '../../qb-core/Shared/locale.lua'

-- Normalize the path
qbCorePath = qbCorePath:gsub('\\', '/') -- Convert backslashes to forward slashes

local Locale = dofile(qbCorePath)

local Translations = {
    error = {
        no_vehicles = 'There are no vehicles in this location!',
        not_depot = 'Your vehicle is not in depot',
        not_owned = 'This vehicle can\'t be stored',
        not_correct_type = 'You can\'t store this type of vehicle here',
        not_enough = 'Not enough money',
        no_garage = 'None',
        vehicle_occupied = 'You can\'t store this vehicle as it is not empty',
        vehicle_not_tracked = 'Could not track vehicle',
        no_spawn = 'Area too crowded'
    },
    success = {
        vehicle_parked = 'Vehicle Stored',
        vehicle_tracked = 'Vehicle Tracked',
    },
    status = {
        out = 'Out',
        garaged = 'Garaged',
        impound = 'Impounded By Police',
        house = 'House',
    },
    info = {
        car_e = 'E - Garage',
        sea_e = 'E - Boathouse',
        air_e = 'E - Hangar',
        rig_e = 'E - Rig Lot',
        depot_e = 'E - Depot',
        house_garage = 'E - House Garage',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})