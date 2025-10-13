local isLoggedIn = false
local my_webui = WebUI('qb-hud', 'qb-hud/html/index.html', 0)
local player_data = {}
local round = math.floor

function onShutdown()
    if my_webui then
        my_webui:Destroy()
        my_webui = nil
    end
end

-- Event Handlers

RegisterClientEvent('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    player_data = exports['qb-core']:GetPlayerData()
    my_webui:SetLayer(2)
end)

RegisterClientEvent('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    player_data = {}
end)

RegisterClientEvent('QBCore:Player:SetPlayerData', function(val)
    player_data = val
end)

-- Money HUD

RegisterClientEvent('qb-hud:client:ShowAccounts', function(type, amount)
    if not my_webui then return end
    if type == 'cash' then
        my_webui:CallFunction('ShowCashAmount', round(amount))
    else
        my_webui:CallFunction('ShowBankAmount', round(amount))
    end
end)

RegisterClientEvent('qb-hud:client:OnMoneyChange', function(type, amount, isMinus)
    if not my_webui then return end
    local cashAmount = player_data.money['cash']
    local bankAmount = player_data.money['bank']
    my_webui:CallFunction('UpdateMoney', round(cashAmount), round(bankAmount), round(amount), isMinus, type)
end)

-- HUD Thread

Timer.SetInterval(function()
    if not isLoggedIn then return end
    local ped = HPlayer:K2_GetPawn()
    if not ped then return end
    local health     = ped.HealthComponent:GetHealth()
    local armor      = player_data.metadata['armor']
    local hunger     = player_data.metadata['hunger']
    local thirst     = player_data.metadata['thirst']
    local stress     = player_data.metadata['stress']
    local playerDead = player_data.metadata['inlaststand'] or player_data.metadata['isdead'] or false

    if my_webui then
        my_webui:CallFunction('UpdateHUD', health, armor, hunger, thirst, stress, playerDead)
    end
end, 1000)
