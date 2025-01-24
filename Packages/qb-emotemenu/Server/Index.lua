local currently_playing = {}

Events.SubscribeRemote('qb-emotemenu:server:playAnimation', function(source, animation)
    local ped = source:GetControlledCharacter()
    if not ped then return end
    local account_id = source:GetAccountID()
    local available_emotes = Config.Emotes
    local emote = available_emotes[animation]
    if not emote then return end
    local animation_path = emote.animation_path
    local slot_type = emote.slot_type
    local loop_indefinitely = emote.loop
    ped:PlayAnimation(animation_path, slot_type, loop_indefinitely)
    currently_playing[account_id] = animation
end)

Events.SubscribeRemote('qb-emotemenu:server:stopAnimation', function(source)
    local ped = source:GetControlledCharacter()
    if not ped then return end
    local account_id = source:GetAccountID()
    if not currently_playing[account_id] then return end
    local animation = currently_playing[account_id]
    local available_emotes = Config.Emotes
    local emote = available_emotes[animation]
    if not emote then return end
    local animation_path = emote.animation_path
    ped:StopAnimation(animation_path)
    currently_playing[account_id] = nil
end)
