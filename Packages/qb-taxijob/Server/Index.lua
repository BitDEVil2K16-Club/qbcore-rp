local peds = {}
for i = 1, #Config.JobLocations do
    local location_info = Config.JobLocations[i]
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
                event = 'qb-taxijob:client:start',
                label = 'Start Working',
                icon = 'fas fa-taxi',
                job = 'taxi'
            },
        },
        distance = 400,
    }
end

QBCore.Functions.CreateCallback('qb-taxijob:server:getPeds', function(_, cb)
    cb(peds)
end)

Events.SubscribeRemote('qb-taxijob:server:spawnTaxi', function(source)
    QBCore.Functions.CreateVehicle(source, 'bp_taxi', Vector(22689, 100016, 98), Rotator(0, -90, 0))
end)
