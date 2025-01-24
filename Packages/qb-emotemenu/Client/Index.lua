Input.Register('Emote Menu', Config.Keybind)
Input.Bind('Emote Menu', InputEvent.Pressed, function()
    if Input.IsMouseEnabled() then return end
    local emote_menu = ContextMenu.new()
    for emote, data in pairs(Config.Emotes) do
        emote_menu:addDropdown(data.name, data.name, {
            {
                id = 'play-' .. emote,
                label = 'Play',
                type = 'button',
                emote = emote,
                callback = function()
                    Events.CallRemote('qb-emotemenu:server:playAnimation', emote)
                end
            },
            {
                id = 'stop-' .. emote,
                label = 'Stop',
                type = 'button',
                callback = function()
                    Events.CallRemote('qb-emotemenu:server:stopAnimation')
                end
            }
        })
    end
    emote_menu:SetHeader('Emote Menu', '')
    emote_menu:Open(false, true)
end)

local hands_up = false
Input.Register('Hands Up', 'X')
Input.Bind('Hands Up', InputEvent.Pressed, function()
    if Input.IsMouseEnabled() then return end
    if not hands_up then
        Events.CallRemote('qb-emotemenu:server:playAnimation', 'HandUp_Idle_01')
        hands_up = true
    end
end)

Input.Bind('Hands Up', InputEvent.Released, function()
    if hands_up then
        hands_up = false
        Events.CallRemote('qb-emotemenu:server:stopAnimation', 'HandUp_Idle_01')
        Events.CallRemote('qb-emotemenu:server:playAnimation', 'HandDown_01')
    end
end)
