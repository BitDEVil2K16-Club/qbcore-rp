Input.Subscribe('KeyPress', function(key_name)
    local ped = Client.GetLocalPlayer():GetControlledCharacter()
    if not ped then return end
    if key_name == 'E' and ped:GetValue('holding_flashlight', false) then
        Events.CallRemote('qb-weapons:client:toggleFlashlight')
    end
end)
