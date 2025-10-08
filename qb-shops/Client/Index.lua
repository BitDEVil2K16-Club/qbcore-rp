local player_data = {}

-- Functions

local function setupPeds()
    TriggerCallback('server.getPeds', function(shopPeds)
        for ped, data in pairs(shopPeds) do
            exports['qb-target']:AddTargetEntity(ped, { options = data.options, distance = data.distance })
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