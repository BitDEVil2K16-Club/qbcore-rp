local function connectToChannel(source, channel)
    if channel > Config.MaxFrequency then return end
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return end
    local player_job = player.PlayerData.job.name
    local rounded_channel = math.floor(channel)
    local is_restricted = Config.RestrictedChannels[rounded_channel]
    if is_restricted then
        if Config.RestrictedChannels[rounded_channel][player_job] then
            source:AddVOIPChannel(channel)
            Events.CallRemote('qb-radio:client:update', source, channel)
            return
        end
    end
    source:AddVOIPChannel(channel)
    Events.CallRemote('qb-radio:client:update', source, channel)
end

Events.SubscribeRemote('qb-radio:server:connect', function(source, channel)
    connectToChannel(source, channel)
end)

Events.SubscribeRemote('qb-radio:server:increaseChannel', function(source, current_channel)
    if current_channel == Config.MaxFrequency then
        connectToChannel(source, 1)
        return
    end
    connectToChannel(source, current_channel + 1)
end)

Events.SubscribeRemote('qb-radio:server:decreaseChannel', function(source, current_channel)
    if current_channel == 1 then
        connectToChannel(source, Config.MaxFrequency)
        return
    end
    connectToChannel(source, current_channel - 1)
end)

Events.SubscribeRemote('qb-radio:server:disconnect', function(source)
    if source:IsInVOIPChannel(1) then
        Events.CallRemote('QBCore:Notify', source, 'You are not in a radio channel', 'error')
        return
    end
    source:AddVOIPChannel(1)
end)

QBCore.Commands.Add('radio', 'Join radio channel', {}, true, function(source, args)
    local channel = tonumber(args[1])
    if not channel then return end
    if channel > Config.MaxFrequency then return end
    if channel < 1 then return end
    connectToChannel(source, channel)
end, 'user')

QBCore.Functions.CreateUseableItem('radio', function(source)
    Events.CallRemote('qb-radio:client:useRadio', source)
end)
