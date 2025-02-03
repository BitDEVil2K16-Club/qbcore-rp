local peds = {}

Timer.SetInterval(function()
    Config.CurrentVehicles = {}

    for _ = 1, Config.VehicleCount do
        local key = math.random(1, #Config.Vehicles)
        local randomVehicle = Config.Vehicles[key]
        if not Config.Vehicles[key] then
            Config.CurrentVehicles[#Config.CurrentVehicles + 1] = randomVehicle
        end
    end
end, 1000 * 60)

for i = 1, #Config.Locations do
    local location_info = Config.Locations[i].ped
    local coords = location_info.coords
    local heading = location_info.heading
    local ped = HCharacter(coords, Rotator(0, heading, 0), '/CharacterCreator/CharacterAssets/Avatar_FBX/Body/Male/Mesh/Male_Full_Body')
    ped:AddSkeletalMeshAttached('head', 'helix::SK_Male_Head')
    ped:AddSkeletalMeshAttached('chest', 'helix::SK_Man_Outwear_03')
    ped:AddSkeletalMeshAttached('legs', 'helix::SK_Man_Pants_05')
    ped:AddSkeletalMeshAttached('feet', 'helix::SK_Delivery_Shoes')

    peds[ped] = {
        options = {
            {
                type = 'client',
                event = 'qb-scrapyard:client:openMenu',
                label = 'Open Scrap Menu',
                icon = 'fas fa-wrench',
            },
        },
        location = i,
        distance = 400,
    }
end

-- Callbacks

QBCore.Functions.CreateCallback('qb-scrapyard:server:getPeds', function(_, cb)
    cb(peds)
end)

-- Handlers

Events.SubscribeRemote('qb-scrapyard:server:scrapVehicle', function(source)
    local ped = source:GetControlledCharacter()
    if not ped then return end

    local vehicle, distance = QBCore.Functions.GetClosestHVehicle(source)
    if not vehicle or distance > 1000 then return end
end)

-- QBCore.Functions.CreateCallback('qb-scrapyard:server:getVehicleList', function(_, cb)
--     cb(Config.CurrentVehicles or {})
-- end)