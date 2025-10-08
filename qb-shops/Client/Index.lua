local player_data = {}

-- Functions

local function setupPeds()
    TriggerCallback('server.getPeds', function(shopPeds)
        -- ped index is shop name
        for ped, data in pairs(shopPeds) do
            exports['qb-target']:AddBoxZone(ped, data.coords, 100, 100, {
                name = ped,
                heading = data.heading,
                distance = data.distance,
                debug = true
            }, data.options)
        end
    end)
end
 
-- Event Handlers

Timer.CreateThread(function()
    player_data = exports['qb-core']:GetPlayerData()
    setupPeds()
end)

RegisterClientEvent('QBCore:Client:OnPlayerLoaded', function()
    player_data = exports['qb-core']:GetPlayerData()
    setupPeds()
end)

RegisterClientEvent('qb-shops:client:openShop', function(data)
    -- wait for target UI cleanup
    Timer.SetTimeout(function()
        TriggerServerEvent('qb-shops:server:openShop', {shop = data.shop})
    end, 600)
end)