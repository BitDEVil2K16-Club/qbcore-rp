local playerCharacters = {}

Events.SubscribeRemote('helicam:server:toggle', function(source, bool)
    if bool then
        local character = source:GetControlledCharacter()
        if not character then return end
        local coords = character:GetLocation()
        playerCharacters[source:GetAccountID()] = coords
        source:UnPossess()
        character:Destroy()
    else
        local coords = playerCharacters[source:GetAccountID()]
        if not coords then return end
        local newChar = HCharacter(coords, Rotator(), source)
        source:Possess(newChar)
        playerCharacters[source:GetAccountID()] = nil
    end
end)

QBCore.Commands.Add('helicam', 'Toggle Helicam', {}, false, function(source)
    Events.CallRemote('helicam:client:toggle', source)
end, 'admin')
