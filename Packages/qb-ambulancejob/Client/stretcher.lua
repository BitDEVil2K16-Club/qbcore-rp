-- Events

Events.Subscribe('qb-ambulancejob:client:takeStretcher', function()
    -- Check for ambulance
    Events.CallRemote('qb-ambulancejob:server:takeStretcher')
end)

Events.SubscribeRemote('qb-ambulancejob:server:createNewStretcher', function(stretcher)
    AddTargetEntity(stretcher, {
        options = {
            {
                label = Lang:t('text.use_stretcher'),
                icon = 'fas fa-bed',
                type = 'server',
                event = 'qb-ambulancejob:server:useStretcher',
                stretcher = stretcher
            },
            {
                label = Lang:t('text.person_with_stretcher'),
                icon = 'fas fa-user-doctor',
                action = function()
                    if not stretcher:GetValue('user', nil) then
                        return Events.CallRemote('qb-ambulancejob:server:placeOnStretcher', stretcher)
                    end
                    Events.CallRemote('qb-ambulancejob:server:detachFromStretcher', stretcher)
                end,
                jobType = 'ems',
            },
            {
                label = Lang:t('text.grab_stretcher'),
                icon = 'fas fa-user-doctor',
                type = 'server',
                event = 'qb-ambulancejob:server:grabStretcher',
                jobType = 'ems',
            },
        },
        distance = 800,
    })
end)

Input.Subscribe('KeyPress', function(key_name)
    if key_name ~= 'E' then return end 
    local Player = Client.GetLocalPlayer()
    if not Player:GetValue('onStretcher', nil) then return end

    Events.CallRemote('qb-ambulancejob:server:detachFromStretcher', Player:GetValue('onStretcher'))
end)