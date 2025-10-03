local Lang = require('locales/en')
local zones = {}
local isPlayerInsideBankZone = false
local my_webui = nil

-- Functions

local function setupUI()
    if my_webui then return end
    my_webui = WebUI('qb-banking', 'qb-banking/html/index.html', true)
    my_webui.Browser.OnLoadCompleted:Add(my_webui.Browser, function()
        my_webui:RegisterEventHandler('closeApp', function(_, cb)
            cb('ok')
        end)

        my_webui:RegisterEventHandler('withdraw', function(data, cb)
            TriggerCallback('withdraw', function(status)
                cb(status)
            end, data)
        end)

        my_webui:RegisterEventHandler('deposit', function(data, cb)
            TriggerCallback('deposit', function(status)
                cb(status)
            end, data)
        end)

        my_webui:RegisterEventHandler('internalTransfer', function(data, cb)
            TriggerCallback('internalTransfer', function(status)
                cb(status)
            end, data)
        end)

        my_webui:RegisterEventHandler('externalTransfer', function(data, cb)
            TriggerCallback('externalTransfer', function(status)
                cb(status)
            end, data)
        end)

        my_webui:RegisterEventHandler('orderCard', function(data, cb)
            TriggerCallback('orderCard', function(status)
                cb(status)
            end, data)
        end)

        my_webui:RegisterEventHandler('openAccount', function(data, cb)
            TriggerCallback('openAccount', function(status)
                cb(status)
            end, data)
        end)

        my_webui:RegisterEventHandler('renameAccount', function(data, cb)
            TriggerCallback('renameAccount', function(status)
                cb(status)
            end, data)
        end)

        my_webui:RegisterEventHandler('deleteAccount', function(data, cb)
            TriggerCallback('deleteAccount', function(status)
                cb(status)
            end, data)
        end)

        my_webui:RegisterEventHandler('addUser', function(data, cb)
            TriggerCallback('addUser', function(status)
                cb(status)
            end, data)
        end)

        my_webui:RegisterEventHandler('removeUser', function(data, cb)
            TriggerCallback('removeUser', function(status)
                cb(status)
            end, data)
        end)
    end)
end

local function OpenBank()
    if not my_webui then setupUI() end
    TriggerCallback('openBank', function(data)
        my_webui:CallFunction('openBank', {
            accounts = data.accounts,
            statements = data.statements,
            playerData = data.playerData
        })
    end)
end

RegisterClientEvent('qb-banking:client:openBank', function()
    OpenBank()
end)

local function OpenATM()
    if not my_webui then setupUI() end
    TriggerCallback('openATM', function(data)
        my_webui:CallFunction('openATM', {
            accounts = data.accounts,
            pinNumbers = data.acceptablePins,
            playerData = data.playerData
        })
    end)
    -- QBCore.Functions.Progressbar('accessing_atm', Lang:t('progress.atm'), 1500, false, true, {
    --     disableMovement = false,
    --     disableCarMovement = false,
    --     disableMouse = false,
    --     disableCombat = false,
    -- }, {
    --     animDict = 'amb@prop_human_atm@male@enter',
    --     anim = 'enter',
    -- }, {
    --     model = 'prop_cs_credit_card',
    --     bone = 28422,
    --     coords = vector3(0.1, 0.03, -0.05),
    --     rotation = vector3(0.0, 0.0, 180.0),
    -- }, {}, function()
    --     TriggerCallback('openATM', function(accounts, playerData, acceptablePins)
    --         SetNuiFocus(true, true)
    --         my_webui:CallFunction({
    --             action = 'openATM',
    --             accounts = accounts,
    --             pinNumbers = acceptablePins,
    --             playerData = playerData
    --         })
    --     end)
    -- end)
end

local function NearATM()
    local ped = HPlayer:K2_GetPawn()
    if not ped then return end
    local playerCoords = ped:K2_GetActorLocation()
    for _, v in pairs(Config.atmModels) do
        local hash = joaat(v)
        local atm = IsObjectNearPoint(hash, playerCoords.x, playerCoords.y, playerCoords.z, 1.5)
        if atm then
            return true
        end
    end
end

-- Events

RegisterClientEvent('qb-banking:client:useCard', function()
    if NearATM() then OpenATM() end
end)

-- Threads

-- CreateThread(function()
--     for i = 1, #Config.locations do
--         local blip = AddBlipForCoord(Config.locations[i])
--         SetBlipSprite(blip, Config.blipInfo.sprite)
--         SetBlipDisplay(blip, 4)
--         SetBlipScale(blip, Config.blipInfo.scale)
--         SetBlipColour(blip, Config.blipInfo.color)
--         SetBlipAsShortRange(blip, true)
--         BeginTextCommandSetBlipName('STRING')
--         AddTextComponentSubstringPlayerName(tostring(Config.blipInfo.name))
--         EndTextCommandSetBlipName(blip)
--     end
-- end)

if Config.useTarget then
    for i = 1, #Config.locations do
        exports['qb-target']:AddSphereZone('bank_' .. i, {
            X = Config.locations[i].X,
            Y = Config.locations[i].Y,
            Z = Config.locations[i].Z
        }, 100.0, {
            name = 'bank_' .. i,
            debug = true,
            distance = 1000
        }, {
            {
                icon = 'fas fa-university',
                label = 'Open Bank',
                event = 'qb-banking:client:openBank',
            }
        })
    end

    -- for i = 1, #Config.atmModels do
    --     local atmModel = Config.atmModels[i]
    --     exports['qb-target']:AddTargetModel(atmModel, {
    --         options = {
    --             {
    --                 icon = 'fas fa-university',
    --                 label = 'Open ATM',
    --                 item = 'bank_card',
    --                 action = function()
    --                     OpenATM()
    --                 end,
    --             }
    --         },
    --         distance = 1.5
    --     })
    -- end
end

-- if not Config.useTarget then
--     for i = 1, #Config.locations do
--         local zone = CircleZone:Create(Config.locations[i], 3.0, {
--             name = 'bank_' .. i,
--             debugPoly = false,
--         })
--         zones[#zones + 1] = zone
--     end

--     local combo = ComboZone:Create(zones, {
--         name = 'bank_combo',
--         debugPoly = false,
--     })

--     combo:onPlayerInOut(function(isPointInside)
--         isPlayerInsideBankZone = isPointInside
--         if isPlayerInsideBankZone then
--             exports['qb-core']:DrawText('Open Bank')
--             CreateThread(function()
--                 while isPlayerInsideBankZone do
--                     Wait(0)
--                     if IsControlJustPressed(0, 38) then
--                         OpenBank()
--                     end
--                 end
--             end)
--         else
--             exports['qb-core']:HideText()
--         end
--     end)
-- end
