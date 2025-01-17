local Stretchers = {}

-- Functions

local function UseStretcher(character, prop)
    if not character or not character:IsValid() then return end
    if not prop or not prop:IsValid() then return end
    if prop:GetValue('user', nil) then return end -- Stretcher in use already 

    -- Reset ped physics 
    character:SetGravityEnabled(false)
    character:SetRagdollMode(false)
    character:SetCollision(CollisionType.NoCollision)
    character:PlayAnimation('nanos-world::A_Mannequin_Idle_05', AnimationSlotType.FullBody, true) -- Force out of crouch
    character:AttachTo(prop, AttachmentRule.SnapToTarget, '', -1, false)
    character:SetRelativeLocation(Vector(0, 0, 30)) -- Offset onto stretcher
    character:SetRelativeRotation(Rotator(90, 0, 0)) -- Rotate ped flat
    character:SetInputEnabled(false)
    character:SetCameraMode(CameraMode.TPSOnly) -- Disable camera switching. First person on stretcher is buggy due to turning movement

    -- Used to determine if in use
    prop:SetValue('user', character:GetPlayer() or character, true)
    character:GetPlayer():SetValue('onStretcher', prop, true)
end

local function DetachFromStretcher(character, prop)
    if not character or not character:IsValid() then return end
    if not prop or not prop:IsValid() then return end

    -- Detach and reset physics back to normal
    character:Detach()
    character:SetRagdollMode(false)
    character:SetCollision(CollisionType.Normal)
    character:SetGravityEnabled(true)
    character:SetInputEnabled(true)
    character:StopAnimation('nanos-world::A_Mannequin_Idle_05')
    character:GetPlayer():ResetCamera()

    -- Reset values to be used again
    prop:SetValue('user', nil, true)
    character:GetPlayer():SetValue('onStretcher', nil, true)
end

-- Events

Events.SubscribeRemote('qb-ambulancejob:server:takeStretcher', function(source)
    if Stretchers[source:GetID()] then return Events.CallRemote('QBCore:Notify', source, Lang:t('error.stretcher_exists'), 'error') end
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player or Player.PlayerData.job.type ~= 'ems' then return end

    local character = source:GetControlledCharacter()
    if not character then return end -- No possession, like in noclip

    local stretcher = Prop(character:GetLocation() + character:GetRotation():GetForwardVector() * 200, character:GetRotation(), 'ecdbd-h::stretcher', CollisionType.Auto, true, GrabMode.Disabled, CCDMode.Disabled) -- Create stretcher in front of EMS
    stretcher:SetValue('ownerID', source:GetID()) -- Define an owner for later use rather than iterating the table
    Stretchers[source:GetID()] = stretcher -- Define stretcher as out
    Events.BroadcastRemote('qb-ambulancejob:server:createNewStretcher', stretcher)
end)

Events.SubscribeRemote('qb-ambulancejob:server:removeStretcher', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player or Player.PlayerData.job.type ~= 'ems' then return end -- Allows other EMS to remove stretchers if need be

    local closestStretcher, distance = QBCore.Functions.GetClosestProp(source) -- Find nearest prop to check for stretcher
    if not closestStretcher or distance > 800 then 
        closestStretcher = Stretchers[source:GetID()] or nil -- If can't find a close stretcher, check if source has one out for destroying
        if not closestStretcher then return end
    end

    if closestStretcher:GetValue('user', nil) then DetachFromStretcher(closestStretcher:GetValue('user', nil), closestStretcher) end -- If stretcher is in use, detach user rather than destroy them

    local ownerID = closestStretcher:GetValue('ownerID') -- Obtain stored owner ID to index in global table
    Stretchers[ownerID]:Destroy()
    Stretchers[ownerID] = nil
end)

Events.SubscribeRemote('qb-ambulancejob:server:useStretcher', function(source, data)
    if source:GetValue('onStretcher', nil) then return end -- Check if source is on stretcher
    UseStretcher(source:GetControlledCharacter(), data.stretcher)
end)

Events.SubscribeRemote('qb-ambulancejob:server:detachFromStretcher', function(source, prop)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if prop:GetValue('user', nil) ~= source or Player.PlayerData.job.type ~= 'ems' then return end

    DetachFromStretcher(prop:GetValue('user', nil):GetControlledCharacter(), prop)
end)


Events.SubscribeRemote('qb-ambulancejob:server:placeOnStretcher', function(source, prop)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.type ~= 'ems' then return end
    if not prop or not prop:IsValid() then return end

    local closestCharacter, distance = QBCore.Functions.GetClosestHCharacter(source)
    if not closestCharacter or distance > 500 then return Events.CallRemote('QBCore:Notify', source, Lang:t('error.no_player'), 'error') end

    if #(prop:GetLocation() - source:GetControlledCharacter():GetLocation()) > 800 then return Events.CallRemote('QBCore:Notify', source, Lang:t('error.s_too_far'), 'error') end
    UseStretcher(closestCharacter, prop)
end)

-- Callbacks

QBCore.Functions.CreateCallback('qb-ambulancejob:server:getStretchers', function(source, cb)
    cb(Stretchers)
end)