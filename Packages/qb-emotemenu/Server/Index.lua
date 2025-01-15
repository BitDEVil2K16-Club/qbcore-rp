Events.SubscribeRemote('qb-emotemenu:server:playAnimation', function(source, animation)
    local ped = source:GetControlledCharacter()
    if not ped then return end
    local available_emotes = Config.Emotes
    local emote = available_emotes[animation]
    if not emote then return end
    local animation_path = emote.animation_path
    local slot_type = emote.slot_type
    local loop_indefinitely = emote.loop
    ped:PlayAnimation(animation_path, slot_type, loop_indefinitely)
end)

Events.SubscribeRemote('qb-emotemenu:server:stopAnimation', function(source, animation)
    local ped = source:GetControlledCharacter()
    if not ped then return end
    local available_emotes = Config.Emotes
    local emote = available_emotes[animation]
    if not emote then return end
    local animation_path = emote.animation_path
    ped:StopAnimation(animation_path)
end)
