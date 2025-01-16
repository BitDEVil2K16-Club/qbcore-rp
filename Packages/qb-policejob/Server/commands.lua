local Lang = Package.Require('../Shared/locales/' .. QBConfig.Language .. '.lua')

local function DnaHash(s)
    local h = string.gsub(s, '.', function(c)
        return string.format('%02x', string.byte(c))
    end)
    return h
end

QBCore.Commands.Add('spikestrip', Lang:t('commands.place_spike'), {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Events.CallRemote('qb-policejob:client:SpawnSpikeStrip', source)
end, 'user')

QBCore.Commands.Add('grantlicense', Lang:t('commands.license_grant'), { { name = 'id', help = Lang:t('info.player_id') }, { name = 'license', help = Lang:t('info.license_type') } }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type == 'leo' and Player.PlayerData.job.grade.level >= Config.LicenseRank then
        if args[2] == 'driver' or args[2] == 'weapon' then
            local SearchedPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
            if not SearchedPlayer then return end
            local licenseTable = SearchedPlayer.PlayerData.metadata['licences']
            if licenseTable[args[2]] then
                Events.CallRemote('QBCore:Notify', source, Lang:t('error.license_already'), 'error')
                return
            end
            licenseTable[args[2]] = true
            SearchedPlayer.Functions.SetMetaData('licences', licenseTable)
            Events.CallRemote('QBCore:Notify', SearchedPlayer.PlayerData.source, Lang:t('success.granted_license'), 'success')
            Events.CallRemote('QBCore:Notify', source, Lang:t('success.grant_license'), 'success')
        else
            Events.CallRemote('QBCore:Notify', source, Lang:t('error.error_license_type'), 'error')
        end
    else
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.rank_license'), 'error')
    end
end, 'user')

QBCore.Commands.Add('revokelicense', Lang:t('commands.license_revoke'), { { name = 'id', help = Lang:t('info.player_id') }, { name = 'license', help = Lang:t('info.license_type') } }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type == 'leo' and Player.PlayerData.job.grade.level >= Config.LicenseRank then
        if args[2] == 'driver' or args[2] == 'weapon' then
            local SearchedPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
            if not SearchedPlayer then return end
            local licenseTable = SearchedPlayer.PlayerData.metadata['licences']
            if not licenseTable[args[2]] then
                Events.CallRemote('QBCore:Notify', source, Lang:t('error.error_license'), 'error')
                return
            end
            licenseTable[args[2]] = false
            SearchedPlayer.Functions.SetMetaData('licences', licenseTable)
            Events.CallRemote('QBCore:Notify', SearchedPlayer.PlayerData.source, Lang:t('error.revoked_license'), 'error')
            Events.CallRemote('QBCore:Notify', source, Lang:t('success.revoke_license'), 'success')
        else
            Events.CallRemote('QBCore:Notify', source, Lang:t('error.error_license'), 'error')
        end
    else
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.rank_revoke'), 'error')
    end
end, 'user')

QBCore.Commands.Add('pobject', Lang:t('commands.place_object'), { { name = 'type', help = Lang:t('info.poobject_object') } }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    local type = args[1]:lower()
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    if type == 'cone' then
        Events.CallRemote('qb-policejob:client:spawnCone', source)
    elseif type == 'barrier' then
        Events.CallRemote('qb-policejob:client:spawnBarrier', source)
    elseif type == 'roadsign' then
        Events.CallRemote('qb-policejob:client:spawnRoadSign', source)
    elseif type == 'tent' then
        Events.CallRemote('qb-policejob:client:spawnTent', source)
    elseif type == 'light' then
        Events.CallRemote('qb-policejob:client:spawnLight', source)
    elseif type == 'delete' then
        Events.CallRemote('qb-policejob:client:deleteObject', source)
    end
end, 'user')

QBCore.Commands.Add('cuff', Lang:t('commands.cuff_player'), {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Events.CallRemote('qb-policejob:client:CuffPlayer', source)
end, 'user')

QBCore.Commands.Add('escort', Lang:t('commands.escort'), {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Events.CallRemote('qb-policejob:client:EscortPlayer', source)
end, 'user')

QBCore.Commands.Add('callsign', Lang:t('commands.callsign'), { { name = 'name', help = Lang:t('info.callsign_name') } }, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Player.Functions.SetMetaData('callsign', table.concat(args, ' '))
end, 'user')

QBCore.Commands.Add('clearcasings', Lang:t('commands.clear_casign'), {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Events.CallRemote('evidence:client:ClearCasingsInArea', source)
end, 'user')

QBCore.Commands.Add('jail', Lang:t('commands.jail_player'), {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Events.CallRemote('qb-policejob:client:JailPlayer', source)
end, 'user')

QBCore.Commands.Add('unjail', Lang:t('commands.unjail_player'), { { name = 'id', help = Lang:t('info.player_id') } }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Events.CallRemote('prison:client:UnjailPerson', tonumber(args[1]))
end, 'user')

QBCore.Commands.Add('clearblood', Lang:t('commands.clearblood'), {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Events.CallRemote('evidence:client:ClearBlooddropsInArea', source)
end, 'user')

QBCore.Commands.Add('seizecash', Lang:t('commands.seizecash'), {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Events.CallRemote('qb-policejob:client:SeizeCash', source)
end, 'user')

QBCore.Commands.Add('sc', Lang:t('commands.softcuff'), {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Events.CallRemote('qb-policejob:client:CuffPlayerSoft', source)
end, 'user')

QBCore.Commands.Add('cam', Lang:t('commands.camera'), { { name = 'camid', help = Lang:t('info.camera_id') } }, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    local camera_id = tonumber(args[1])
    if not Config.SecurityCameras.cameras[camera_id] then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.no_camera'), 'error')
        return
    end
    local ped = source:GetControlledCharacter()
    if ped then
        source:UnPossess()
        ped:Destroy()
    end
    Events.CallRemote('qb-policejob:client:viewCamera', source, camera_id)
end, 'user')

QBCore.Commands.Add('flagplate', Lang:t('commands.flagplate'), { { name = 'plate', help = Lang:t('info.plate_number') }, { name = 'reason', help = Lang:t('info.flag_reason') } }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    local reason = {}
    for i = 2, #args, 1 do
        reason[#reason + 1] = args[i]
    end
    Plates[args[1]:upper()] = {
        isflagged = true,
        reason = table.concat(reason, ' ')
    }
    Events.CallRemote('QBCore:Notify', source, Lang:t('info.vehicle_flagged', { vehicle = args[1]:upper(), reason = table.concat(reason, ' ') }))
end, 'user')

QBCore.Commands.Add('unflagplate', Lang:t('commands.unflagplate'), { { name = 'plate', help = Lang:t('info.plate_number') } }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    if Plates and Plates[args[1]:upper()] then
        if Plates[args[1]:upper()].isflagged then
            Plates[args[1]:upper()].isflagged = false
            Events.CallRemote('QBCore:Notify', source, Lang:t('info.unflag_vehicle', { vehicle = args[1]:upper() }))
        else
            Events.CallRemote('QBCore:Notify', source, Lang:t('error.vehicle_not_flag'), 'error')
        end
    else
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.vehicle_not_flag'), 'error')
    end
end, 'user')

QBCore.Commands.Add('plateinfo', Lang:t('commands.plateinfo'), { { name = 'plate', help = Lang:t('info.plate_number') } }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    if Plates and Plates[args[1]:upper()] then
        if Plates[args[1]:upper()].isflagged then
            Events.CallRemote('QBCore:Notify', source, Lang:t('success.vehicle_flagged', { plate = args[1]:upper(), reason = Plates[args[1]:upper()].reason }), 'success')
        else
            Events.CallRemote('QBCore:Notify', source, Lang:t('error.vehicle_not_flag'), 'error')
        end
    else
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.vehicle_not_flag'), 'error')
    end
end, 'user')

QBCore.Commands.Add('depot', Lang:t('commands.depot'), { { name = 'price', help = Lang:t('info.impound_price') } }, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Events.CallRemote('qb-policejob:client:ImpoundVehicle', source, false, tonumber(args[1]))
end)

QBCore.Commands.Add('impound', Lang:t('commands.impound'), {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type ~= 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Events.CallRemote('qb-policejob:client:ImpoundVehicle', source, true)
end, 'user')

QBCore.Commands.Add('paytow', Lang:t('commands.paytow'), { { name = 'id', help = Lang:t('info.player_id') } }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type == 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    local playerId = tonumber(args[1])
    local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
    if OtherPlayer then
        if OtherPlayer.PlayerData.job.name == 'tow' then
            OtherPlayer.Functions.AddMoney('bank', 500, 'police-tow-paid')
            Events.CallRemote('QBCore:Notify', OtherPlayer.PlayerData.source, Lang:t('success.tow_paid'), 'success')
            Events.CallRemote('QBCore:Notify', source, Lang:t('info.tow_driver_paid'))
        else
            Events.CallRemote('QBCore:Notify', source, Lang:t('error.not_towdriver'), 'error')
        end
    end
end, 'user')

QBCore.Commands.Add('paylawyer', Lang:t('commands.paylawyer'), { { name = 'id', help = Lang:t('info.player_id') } }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type == 'leo' or Player.PlayerData.job.name == 'judge' then
        local playerId = tonumber(args[1])
        local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
        if not OtherPlayer then return end
        if OtherPlayer.PlayerData.job.name == 'lawyer' then
            OtherPlayer.Functions.AddMoney('bank', 500, 'police-lawyer-paid')
            Events.CallRemote('QBCore:Notify', OtherPlayer.PlayerData.source, Lang:t('success.tow_paid'), 'success')
            Events.CallRemote('QBCore:Notify', source, Lang:t('info.paid_lawyer'))
        else
            Events.CallRemote('QBCore:Notify', source, Lang:t('error.not_lawyer'), 'error')
        end
    else
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
    end
end, 'user')

QBCore.Commands.Add('fine', Lang:t('commands.fine'), { { name = 'id', help = Lang:t('info.player_id') }, { name = 'amount', help = Lang:t('info.amount') } }, false, function(source, args)
    local biller = QBCore.Functions.GetPlayer(source)
    if not biller then return end
    local billed = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if not billed then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.not_online'), 'error')
        return
    end
    if biller.PlayerData.job.type == 'leo' and biller.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    if biller.PlayerData.citizenid == billed.PlayerData.citizenid then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.fine_yourself'), 'error')
        return
    end
    local amount = tonumber(args[2])
    if not amount or amount < 0 then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.amount_higher'), 'error')
        return
    end
    if billed.Functions.RemoveMoney('bank', amount, 'paid-fine') then
        Events.CallRemote('QBCore:Notify', source, Lang:t('info.fine_issued'), 'success')
        Events.CallRemote('QBCore:Notify', billed.PlayerData.source, Lang:t('info.received_fine'))
        AddMoney(biller.PlayerData.job.name, amount, 'Fine')
    elseif billed.Functions.RemoveMoney('cash', amount, 'paid-fine') then
        Events.CallRemote('QBCore:Notify', source, Lang:t('info.fine_issued'), 'success')
        Events.CallRemote('QBCore:Notify', billed.PlayerData.source, Lang:t('info.received_fine'))
        AddMoney(biller.PlayerData.job.name, amount, 'Fine')
    end
end, 'user')

QBCore.Commands.Add('anklet', Lang:t('commands.anklet'), {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type == 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Events.CallRemote('qb-policejob:client:CheckDistance', source)
end, 'user')

QBCore.Commands.Add('ankletlocation', Lang:t('commands.ankletlocation'), { { name = 'cid', help = Lang:t('info.citizen_id') } }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type == 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    local citizenid = args[1]
    local Target = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if not Target then return end
    if Target.PlayerData.metadata['tracker'] then
        Events.CallRemote('qb-policejob:client:SendTrackerLocation', Target.PlayerData.source, source)
    else
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.no_anklet'), 'error')
    end
end, 'user')

QBCore.Commands.Add('takedrivinglicense', Lang:t('commands.drivinglicense'), {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.PlayerData.job.type == 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    Events.CallRemote('qb-policejob:client:SeizeDriverLicense', source)
end, 'user')

QBCore.Commands.Add('takedna', Lang:t('commands.takedna'), { { name = 'id', help = Lang:t('info.player_id') } }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    local OtherPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if not OtherPlayer then return end
    if Player.PlayerData.job.type == 'leo' and not Player.PlayerData.job.onduty then
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.on_duty_police_only'), 'error')
        return
    end
    if RemoveItem(source, 'empty_evidence_bag', 1, false, 'qb-policejob:takedna') then
        local info = {
            label = Lang:t('info.dna_sample'),
            type = 'dna',
            dnalabel = DnaHash(OtherPlayer.PlayerData.citizenid)
        }
        if not AddItem(source, 'filled_evidence_bag', 1, false, info, 'qb-policejob:takedna') then return end
        Events.CallRemote('qb-inventory:client:ItemBox', source, QBCore.Shared.Items['filled_evidence_bag'], 'add')
    else
        Events.CallRemote('QBCore:Notify', source, Lang:t('error.have_evidence_bag'), 'error')
    end
end, 'user')

QBCore.Commands.Add('911p', Lang:t('commands.police_report'), { { name = 'message', help = Lang:t('commands.message_sent') } }, false, function(source, args)
    local message
    if args[1] then message = table.concat(args, ' ') else message = Lang:t('commands.civilian_call') end
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local players = QBCore.Functions.GetQBPlayers()
    for _, v in pairs(players) do
        if v and v.PlayerData.job.type == 'leo' and v.PlayerData.job.onduty then
            Events.CallRemote('qb-policejob:client:policeAlert', v.PlayerData.source, coords, message)
        end
    end
end, 'user')
