local Lang = Package.Require('../Shared/locales/' .. QBConfig.Language .. '.lua')
local is_working = false
local current_marker = nil
local location = nil
local hasPassenger = false

for k, blip in pairs(Config.JobLocations) do
    Events.Call('Map:AddBlip', {
        id = 'start_taxi_' .. k,
        name = 'Start Taxi',
        coords = { x = blip.coords.X, y = blip.coords.Y, z = blip.coords.Z},
        imgUrl = './media/map-icons/Marker.svg',
        group = 'Start Taxi Job',
    })
end

-- Functions

local function setupPeds()
    QBCore.Functions.TriggerCallback('qb-taxijob:server:getPeds', function(jobPeds)
        for ped, data in pairs(jobPeds) do
            AddTargetEntity(ped, { options = data.options, distance = data.distance })
        end
    end)
end

local function getNextLocation()
    if current_marker then
        current_marker:Destroy()
        current_marker = nil
    end
    Events.Call('Map:RemoveBlip', 'taxi_job')
    QBCore.Functions.TriggerCallback('qb-taxijob:server:getLocation', function(jobLocation, isPickingUp)
        hasPassenger = not isPickingUp -- if new job, hasPassenger is false
        location = jobLocation -- Could be pickup, or dropoff (tracked server-side per source)
        QBCore.Functions.Notify(hasPassenger and Lang:t('info.goto_dropoff') or Lang:t('info.pickup'), 'success')
        Events.Call('Map:AddBlip', {
            id = 'taxi_job',
            name = 'Taxi Job',
            coords = { x = jobLocation.X, y = jobLocation.Y, z = jobLocation.Z},
            imgUrl = './media/map-icons/Marker.svg',
            group = newPassenger and 'Taxi Pickup' or 'Taxi Dropoff',
        })
    end)
end

-- Event Handlers

Package.Subscribe('Load', function()
    if Client.GetValue('isLoggedIn', false) then
        setupPeds()
    end
end)

Events.SubscribeRemote('QBCore:Client:OnPlayerLoaded', function()
    setupPeds()
end)

Events.Subscribe('qb-taxijob:client:start', function()
    is_working = not is_working -- Toggleable working state
    if not is_working then
        if location then Events.CallRemote('qb-taxijob:server:cancelJob') end
        location = nil
        return QBCore.Functions.Notify(Lang:t('success.clocked_off'), 'success') 
    end
    Events.CallRemote('qb-taxijob:server:spawnTaxi')
end)

Events.Subscribe('qb-taxijob:client:startMission', function()
    if not is_working then return QBCore.Functions.Notify(Lang:t('error.not_working'), 'error') end -- Could be removed and changed to a vehicle check
    if hasPassenger then return QBCore.Functions.Notify(Lang:t('error.has_passenger'), 'error') end
    if location then Events.CallRemote('qb-taxijob:server:cancelJob') end
    getNextLocation()
end)

Input.Subscribe('KeyDown', function(key_name)
    if not is_working then return end
    if key_name == 'F' then
        local playerPed = Client.GetLocalPlayer():GetControlledCharacter()
        if not playerPed then return end
        if not location or playerPed:GetLocation():Distance(location) > 1000 then return end
        if not hasPassenger then -- If passenger isn't in vehicle
            Events.CallRemote('qb-taxijob:server:pickupPassenger')
            hasPassenger = true -- Passenger is in vehicle
            getNextLocation()
        else
            Events.CallRemote('qb-taxijob:server:dropoff')
            hasPassenger = false
            location = nil
        end
    end
end)
