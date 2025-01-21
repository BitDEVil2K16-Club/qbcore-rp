local is_working = false
local current_marker = nil
local dropoff_Location = Vector(0, 0, 0)
local pickupLocation = nil
local Passenger = ped

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
    if not Passenger then -- Refactor this into one
        QBCore.Functions.TriggerCallback('qb-taxijob:server:getJob', function(jobLocation, newPassenger)
            pickupLocation = jobLocation
--[[             current_marker = Prop(pickupLocation, Rotator(0, 0, 0), 'pco-markers::SM_MarkerArrow')
            current_marker:SetMaterialColorParameter('Color', Color(255, 0, 0, 1))
            current_marker:SetScale(Vector(100, 100, 100)) ]]
            Events.Call('Map:AddBlip', {
                id = 'taxi_job',
                name = 'Taxi Job',
                coords = { x = pickupLocation.X, y = pickupLocation.Y, z = pickupLocation.Z},
                imgUrl = './media/map-icons/Marker.svg',
                group = 'Taxi Pickup',
            })
            Passenger = newPassenger
        end, Passenger)
    else
        QBCore.Functions.TriggerCallback('qb-taxijob:server:getJob', function(jobLocation, _)
            dropoff_location = jobLocation
--[[             current_marker = Prop(dropoff_Location, Rotator(0, 0, 0), 'pco-markers::SM_MarkerArrow')
            current_marker:SetMaterialColorParameter('Color', Color(255, 0, 0, 1))
            current_marker:SetScale(Vector(100, 100, 100)) ]]
            Events.Call('Map:AddBlip', {
                id = 'taxi_job',
                name = 'Taxi Job',
                coords = { x = dropoff_Location.X, y = dropoff_Location.Y, z = dropoff_Location.Z},
                imgUrl = './media/map-icons/Marker.svg',
                group = 'Taxi Dropoff',
            })
        end, Passenger)
    end
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
    if is_working then return end
    is_working = true
    getNextLocation()
    Events.CallRemote('qb-taxijob:server:spawnTaxi')
end)

Input.Subscribe('KeyDown', function(key_name)
    if not is_working or not dropoff_location then return end
    if key_name == 'E' then
        local playerPed = Client.GetLocalPlayer():GetControlledCharacter()
        if not playerPed then return end

        if pickupLocation and Passenger then
            if playerPed:Distance(pickupLocation) > 1000 then return end
            Events.CallRemote('qb-taxijob:server:pickupPassenger', Passenger)
            return
        elseif dropoff_location then
            if playerPed:Distance(dropoffLocation) > 1000 then return end
            Events.CallRemote('qb-taxijob:server:dropoff')

        end
    end
end)
