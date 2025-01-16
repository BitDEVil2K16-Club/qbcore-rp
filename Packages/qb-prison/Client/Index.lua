Events.Subscribe('qb-policejob:client:jailPlayer', function()
    local player, distance = QBCore.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        ShowInput({
            header = Lang:t('info.jail_time_input'),
            submitText = Lang:t('info.submit'),
            inputs = {
                {
                    text = Lang:t('info.time_months'),
                    name = 'jailtime',
                    type = 'number',
                    isRequired = true
                }
            }
        }, function(dialog)
            if dialog and tonumber(dialog['jailtime']) > 0 then
                Events.CallRemote('police:server:JailPlayer', playerId, tonumber(dialog['jailtime']))
            else
                QBCore.Functions.Notify(Lang:t('error.time_higher'), 'error')
            end
        end)
    else
        QBCore.Functions.Notify(Lang:t('error.none_nearby'), 'error')
    end
end)
