-- Events

RegisterClientEvent('QBCore:Player:SetPlayerData', function(val)
    QBCore.PlayerData = val
end)

RegisterClientEvent('QBCore:Player:UpdatePlayerData', function()
    TriggerServerEvent('QBCore:UpdatePlayer')
end)

RegisterClientEvent('QBCore:Notify', function(text, type, length, icon)
    QBCore.Functions.Notify(text, type, length, icon)
end)

RegisterClientEvent('qb-core:client:DrawText', function(text, position)
    QBCore.Functions.DrawText(text, position)
end)

RegisterClientEvent('qb-core:client:ChangeText', function(text, position)
    QBCore.Functions.ChangeText(text, position)
end)

RegisterClientEvent('qb-core:client:HideText', function()
    QBCore.Functions.HideText()
end)

RegisterClientEvent('qb-core:client:KeyPressed', function()
    QBCore.Functions.KeyPressed()
end)
