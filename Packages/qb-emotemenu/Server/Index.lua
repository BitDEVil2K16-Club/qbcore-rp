local currently_playing = {}
local flattened_emotes = {}

local function flattenEmotes()
    for category, emotes in pairs(Config.Emotes) do
        for animation, data in pairs(emotes) do
            flattened_emotes[category .. ':' .. animation] = data
        end
    end
end
flattenEmotes()

Events.SubscribeRemote('qb-emotemenu:server:playAnimation', function(source, category, animation)
    local ped = source:GetControlledCharacter()
    if not ped then return end
    local account_id = source:GetAccountID()

    local emote_key = category .. ':' .. animation
    local emote = flattened_emotes[emote_key]
    if not emote then return end

    if currently_playing[account_id] == emote_key then
        ped:StopAnimation(emote.animation_path)
        currently_playing[account_id] = nil
        return
    end

    local currently_playing_key = currently_playing[account_id]
    if currently_playing_key then
        local current_emote = flattened_emotes[currently_playing_key]
        if current_emote then
            ped:StopAnimation(current_emote.animation_path)
        end
    end

    ped:PlayAnimation(
        emote.animation_path,
        emote.slot_type or AnimationSlotType.FullBody,
        emote.loop or false,
        0.5, -- blend_in_time
        0.5, -- blend_out_time
        1.0  -- play_rate
    )
    currently_playing[account_id] = emote_key
end)

Events.SubscribeRemote('qb-emotemenu:server:spawnWeapon', function(source) -- for gameplay vid
    local ped = source:GetControlledCharacter()
    if not ped then return end
    local coords = ped:GetLocation()
    local rotation = ped:GetRotation()
    local itemInfo = {
        info = {
            ammo = 1000
        }
    }
    local weapon = QBCore.Functions.CreateWeapon(source, 'weapon_mk4', coords, rotation, itemInfo)
    if not weapon then return end
    ped:PickUp(weapon)
end)

QBCore.Commands.Add('bankpeds', 'Spawns bank peds', {}, false, function()
    local peds = {
        {
            coords = Vector(-55597.1, -2611.2, 391.9),
            heading = Rotator(0.0, -80.58, 0.0),
            animation = 'rp-anims-k::AS_Supplication',
            outfit = {
                body = '/CharacterCreator/CharacterAssets/Avatar_FBX/Body/Male/Mesh/Male_Full_Body',
                head = 'helix::SK_Male_Head',
                hair = 'abcca-clhabc::Male_Hairstyle_02',
                chest = 'abcca-clhabc::SK_Man_T_Shirts_4',
                legs = 'abcca-clhabc::SK_MAN_Saggy_Pants',
                feet = 'abcca-default-wearables::SK_M_Shoes_Tennis'
            }
        },
        {
            coords = Vector(-55355.5, -3422.2, 391.9),
            heading = Rotator(0.0, 148.63209533691, 0.0),
            animation = 'rp-anims-k::AS_Supplication2',
            outfit = {
                body = '/CharacterCreator/CharacterAssets/Avatar_FBX/Body/Female/Mesh/Female_Full_Body_v05',
                head = '/CharacterCreator/CharacterAssets/Avatar_FBX/Head/Female_Head',
                hair = 'abcca-clhabc::Female_Hairstyle_SK_16_1',
                chest = 'abcca-clhabc::SK_W_Striped_Blouse',
                legs = 'abcca-default-wearables::SK_W_Bottom_Trousers',
                feet = 'abcca-default-wearables::SK_M_Shoes_Tennis'
            }
        },
        {
            coords = Vector(-56144.8, -3435.6, 391.9),
            heading = Rotator(0.0, 22.237899780273, 0.0),
            animation = 'rp-anims-k::AS_Supplication',
            outfit = {
                body = '/CharacterCreator/CharacterAssets/Avatar_FBX/Body/Male/Mesh/Male_Full_Body',
                head = 'helix::SK_Male_Head',
                hair = 'abcca-clhabc::Male_Hairstyle_SK_06_1',
                chest = 'abcca-clhabc::SK_Man_Jacket_style_3_3_1',
                legs = 'abcca-clhabc::SK_Male_Pants_14_1',
                feet = 'abcca-default-wearables::SK_M_Shoes_Tennis'
            }
        },
        {
            coords = Vector(-56146.3, -3025.6, 391.9),
            heading = Rotator(0.0, -3.53, 0.0),
            animation = 'rp-anims-k::AS_Supplication2',
            outfit = {
                body = '/CharacterCreator/CharacterAssets/Avatar_FBX/Body/Female/Mesh/Female_Full_Body_v05',
                head = '/CharacterCreator/CharacterAssets/Avatar_FBX/Head/Female_Head',
                hair = 'abcca-clhabc::Female_hair_styile_01',
                chest = 'abcca-default-wearables::SK_W_Top_Crop',
                legs = 'abcca-default-wearables::SK_W_Bottom_Skirt',
                feet = 'abcca-default-wearables::SK_M_Shoes_Tennis'
            }
        }
    }

    for i = 1, #peds do
        local ped_data = peds[i]
        local outfit_data = peds[i].outfit
        local ped = HCharacter(ped_data.coords, ped_data.heading, outfit_data.body)
        ped:AddSkeletalMeshAttached('head', outfit_data.head)
        ped:AddSkeletalMeshAttached('hair', outfit_data.hair)
        ped:AddSkeletalMeshAttached('chest', outfit_data.chest)
        ped:AddSkeletalMeshAttached('legs', outfit_data.legs)
        ped:AddSkeletalMeshAttached('feet', outfit_data.feet)
        ped:AddSkeletalMeshAttached('eyebrows', '/CharacterCreator/CharacterAssets/Avatar_FBX/OtherMeshes/Male/EyeBrow_/Male_Eyebrows_T01')
        ped:AddSkeletalMeshAttached('eyelashes', '/CharacterCreator/CharacterAssets/Avatar_FBX/OtherMeshes/Male/EyeLashes_/Eyelashes_Male')

        ped:PlayAnimation(
            ped_data.animation,
            AnimationSlotType.FullBody,
            true,
            0.5, -- blend_in_time
            0.5, -- blend_out_time
            0.8  -- play_rate
        )
    end
end, 'user')
