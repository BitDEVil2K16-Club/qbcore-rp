local Lang = Package.Require('../Shared/locales/' .. QBConfig.Language .. '.lua')
local peds = {}

for _, depot in pairs(Config.Locations.Depots) do
    local pedData = depot.pedSpawn
    local ped = HCharacter(pedData.coords, Rotator(0, pedData.heading, 0), '/CharacterCreator/CharacterAssets/Avatar_FBX/Body/Male/Mesh/Male_Full_Body')
    ped:AddSkeletalMeshAttached('head', 'helix::SK_Male_Head')
    ped:AddSkeletalMeshAttached('chest', 'helix::SK_Man_Outwear_03')
    ped:AddSkeletalMeshAttached('legs', 'helix::SK_Man_Pants_05')
    ped:AddSkeletalMeshAttached('feet', 'helix::SK_Delivery_Shoes')

    peds[ped] = {
        options = {
            {
                type = 'server',
                event = 'QBCore:ToggleDuty',
                label = 'Toggle Duty',
                icon = 'fas fa-clipboard',
                jobType = 'garbage'
            },
        },
        distance = 400,
    }
end