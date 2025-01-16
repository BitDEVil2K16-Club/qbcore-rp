Events.SubscribeRemote('Map:Server:TeleportPlayer', function(source, x, y)
    if not source then return end
    local character = source:GetControlledCharacter()
    if not character then return end
    character:SetLocation(Vector(x, y, 0))
end)

Server.Subscribe('Tick', function(delta_time)
    local playerBlips = {}
    for _, p in pairs(Player.GetAll()) do
        local character = p:GetControlledCharacter()

        if character then
            local loc = character:GetLocation()
            table.insert(playerBlips, { id = p:GetAccountID(), x = loc.X, y = loc.Y })
        end
    end
    Events.BroadcastRemote('Map:UpdatePlayersPos', playerBlips)
end)
