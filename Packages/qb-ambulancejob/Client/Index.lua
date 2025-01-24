Package.Require('death.lua')
Package.Require('wounding.lua')
Package.Require('stretcher.lua')

local function initaliseData()
    QBCore.Functions.TriggerCallback('qb-ambulancejob:server:getPeds', function(peds)
        for ped, data in pairs(peds) do
            AddTargetEntity(ped, { options = data.options, distance = data.distance })
        end
    end)
    
    QBCore.Functions.TriggerCallback('qb-ambulancejob:server:getStretchers', function(stretchers)
        for _, stretcher in pairs(stretchers) do
            AddTargetEntity(v, {
                options = {
                    {
                        label = Lang:t('text.use_stretcher'),
                        icon = 'fas fa-bed',
                        type = 'server',
                        event = 'qb-ambulancejob:server:useStretcher',
                        stretcher = stretcher
                    },
                    {
                        label = function() return prop:GetValue('user', nil) and Lang:t('text.take_off_stretcher') or Lang:t('text.place_on_stretcher') end,
                        icon = 'fas fa-user-doctor',
                        action = function()
                            if not prop:GetValue('user', nil) then
                                return Events.CallRemote('qb-ambulancejob:server:placeOnStretcher', stretcher)
                            end
                            Events.CallRemote('qb-ambulancejob:server:detachFromStretcher', stretcher)
                        end,
                    },
                },
                distance = 800,
            })
        end
    end)
    Events.CallRemote('qb-ambulancejob:server:syncInjuries', Config.Bones, BleedAmount > 0 and true or false)
end

Events.SubscribeRemote('QBCore:Client:OnPlayerLoaded', function()
    initaliseData()
end)

Package.Subscribe('Load', function()
    if Client.GetValue('isLoggedIn', false) then
        initaliseData()
    end
end)

Events.SubscribeRemote('QBCore:Client:OnPlayerUnload', function()
    Events.CallRemote('qb-ambulancejob:server:syncInjuries', nil)
end)

Events.Subscribe('qb-ambulancejob:client:checkStatus', function()
    QBCore.Functions.TriggerCallback('qb-ambulancejob:server:checkStatus', function(injuryData)
        if not injuryData then return end
        local statusMenu = ContextMenu.new()
        local tableOrder = { -- Not a fan of this method of sorting, but looks nice in the menu
            [1] = 'head',
            [2] = 'neck_02',
            [3] = 'neck_01',
            [4] = 'clavicle_l',
            [5] = 'clavicle_r',
            [6] = 'upperarm_l',
            [7] = 'upperarm_r',
            [8] = 'lowerarm_l',
            [9] = 'lowerarm_r',
            [10] = 'hand_l',
            [11] = 'hand_r',
            [12] = 'spine_05',
            [13] = 'spine_04',
            [14] = 'spine_03',
            [15] = 'spine_02',
            [16] = 'pelvis',
            [17] = 'thigh_l',
            [18] = 'thigh_r',
            [19] = 'calf_l',
            [20] = 'calf_r',
            [21] = 'foot_l',
            [22] = 'foot_r',
        }
        for k, v in pairs(tableOrder) do
            statusMenu:addButton(k, string.format('%s | Damaged: %s | Severity: %s', injuryData.limbs[v].label, injuryData.limbs[v].isDamaged and 'Yes' or 'No', injuryData.limbs[v].severity))
        end

        statusMenu:setMenuInfo(string.format('Bleeding: %s', injuryData.isBleeding and 'Yes' or 'No'), '')
        statusMenu:SetHeader('Player Status')
        statusMenu:Open(false, true)
    end)
end)

AddGlobalPlayer({
    options = {
        {
            label = 'Check Health Status',
            icon = 'fas fa heart-pulse',
            type = 'client',
            event = 'qb-ambulancejob:client:checkStatus',
            jobType = 'ems',
            canInteract = function(entity)
                return entity:GetPlayer()
            end,
        },
        {
            label = 'Revive',
            icon = 'fas fa user-doctor',
            type = 'server',
            event = 'qb-ambulancejob:server:revivePlayer',
            jobType = 'ems',
            canInteract = function(entity)
                if entity:GetValue('isDead', false) then return false end
                return entity:GetPlayer()
            end,
        },
        {
            label = 'Heal wounds',
            icon = 'fas fa bandage',
            type = 'server',
            event = 'qb-ambulancejob:server:treatWounds',
            jobType = 'ems',
            canInteract = function(entity)
                if entity:GetHealth() < 100 then return false end
                return entity:GetPlayer()
            end,
        },
        {
            label = 'Escort',
            icon = 'user-group',
            type = 'fas fa server',
            event = 'qb-ambulancejob:server:escortPlayer',
            jobType = 'ems',
            canInteract = function(entity)
                if not entity:GetValue('isDead', false) then return false end
                return entity:GetPlayer()
            end,
        },
    },
    distance = 800,
})

for _, v in pairs(Config.Locations.hospital) do
    local location = v.location
    Events.Call('Map:AddBlip', {
        name = 'Hospital',
        coords = { x = location.X, y = location.Y, z = location.Z },
        imgUrl = './media/map-icons/Medicine-icon.svg'
    })
end
