
-- Functions

local function setupPeds()
    QBCore.Functions.TriggerCallback('qb-scrapyard:server:getPeds', function(peds)
        for ped, targetData in pairs(peds) do
            AddTargetEntity(ped, targetData)
        end
    end)
end

-- Handlers

Events.SubscribeRemote('QBCore:Client:OnPlayerLoaded', function()
    setupPeds()
end)

Package.Subscribe('Load', function()
    if Client.GetValue('isLoggedIn', false) then
        setupPeds()
    end
end)

Events.Subscribe('qb-scrapyard:client:openMenu', function(args)
    local location = Config.Locations[args.location]
    if not location then print('no location found') end

    for k, v in pairs(Config.CurrentVehicles) do
        print(k, v)
    end
end)