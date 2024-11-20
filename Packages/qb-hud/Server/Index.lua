QBCore.Commands.Add('cash', 'Check Cash Balance', {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    local cashamount = Player.PlayerData.money.cash
    Events.CallRemote('hud:client:ShowAccounts', source, 'cash', cashamount)
end, 'user')

QBCore.Commands.Add('bank', 'Check Bank Balance', {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    local bankamount = Player.PlayerData.money.bank
    Events.CallRemote('hud:client:ShowAccounts', source, 'bank', bankamount)
end, 'user')

-- Events

Events.Subscribe('hud:server:GainStress', function(source, amount)
    if Config.DisableStress then return end
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    local Job = Player.PlayerData.job.name
    local JobType = Player.PlayerData.job.type
    local newStress
    if not Player or Config.WhitelistedJobs[JobType] or Config.WhitelistedJobs[Job] then return end
    if not ResetStress then
        if not Player.PlayerData.metadata['stress'] then
            Player.PlayerData.metadata['stress'] = 0
        end
        newStress = Player.PlayerData.metadata['stress'] + amount
        if newStress <= 0 then newStress = 0 end
    else
        newStress = 0
    end
    if newStress > 100 then
        newStress = 100
    end
    Player.Functions.SetMetaData('stress', newStress)
    Events.CallRemote('hud:client:UpdateStress', source, newStress)
    Events.CallRemote('QBCore:Notify', source, Lang:t('notify.stress_gain'), 'error', 1500)
end)

Events.Subscribe('hud:server:RelieveStress', function(source, amount)
    if Config.DisableStress then return end
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    local newStress
    if not ResetStress then
        if not Player.PlayerData.metadata['stress'] then
            Player.PlayerData.metadata['stress'] = 0
        end
        newStress = Player.PlayerData.metadata['stress'] - amount
        if newStress <= 0 then newStress = 0 end
    else
        newStress = 0
    end
    if newStress > 100 then
        newStress = 100
    end
    Player.Functions.SetMetaData('stress', newStress)
    Events.CallRemote('hud:client:UpdateStress', source, newStress)
    Events.CallRemote('QBCore:Notify', source, Lang:t('notify.stress_removed'))
end)
