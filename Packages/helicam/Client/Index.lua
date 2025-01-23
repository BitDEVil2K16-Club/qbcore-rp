local helicamUI = WebUI('Helicam', 'file://UI/index.html')
helicamUI:SetVisibility(WidgetVisibility.Hidden)
local helicamCube = nil
local helicamLight = nil
local velocity = Vector(0, 0, 0)
local activeKeys = {}
local shiftHeld = false
local normalAccel = 25
local shiftAccel = 100
local decel = 15
local maxSpeed = 7500
local moveTimer = nil
local updateTimer = nil

local function GetCompassDirection(yaw)
    local dirs = { 'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW' }
    local i = math.floor((yaw + 22.5) / 45) % 8 + 1
    return dirs[i]
end

Input.Subscribe('KeyDown', function(key)
    activeKeys[key] = true
    if key == 'LeftShift' then
        shiftHeld = true
    end
end)

Input.Subscribe('KeyUp', function(key)
    activeKeys[key] = nil
    if key == 'LeftShift' then
        shiftHeld = false
    end
end)

local function StartHelicam()
    local player = Client.GetLocalPlayer()
    if not player then return end
    helicamCube = StaticMesh(player:GetCameraLocation(), Rotator(), 'helix::SM_Cube', CollisionType.NoCollision)
    helicamCube:SetMaterial('helix::M_Default_Translucent_Lit')
    helicamCube:SetMaterialScalarParameter('Opacity', 0)
    helicamCube:SetScale(0.05)
    player:SetCameraLocation(helicamCube:GetLocation())
    player:AttachCameraTo(helicamCube)
    player:SetCameraArmLength(0, true)
    helicamLight = Light(
        player:GetCameraLocation(),
        player:GetCameraRotation(),
        Color(1, 1, 1),
        LightType.Spot,
        10000,
        150000,
        11,
        0.85,
        0,
        true,
        true,
        true
    )
    helicamUI:SetVisibility(WidgetVisibility.Visible)

    moveTimer = Timer.SetInterval(function()
        if not helicamCube or not helicamLight then return end
        local rot = Client.GetLocalPlayer():GetCameraRotation()
        local forward = rot:GetForwardVector()
        local right = rot:GetRightVector()
        forward = forward * Vector(1, 1, 0)
        if forward:Size() > 0 then forward:Normalize() end
        if right:Size() > 0 then right:Normalize() end
        local direction = Vector(0, 0, 0)
        if activeKeys['W'] then direction = direction + forward end
        if activeKeys['S'] then direction = direction - forward end
        if activeKeys['A'] then direction = direction - right end
        if activeKeys['D'] then direction = direction + right end
        if activeKeys['SpaceBar'] then direction = direction + Vector(0, 0, 1) end
        if activeKeys['LeftControl'] then direction = direction - Vector(0, 0, 1) end
        if direction:Size() > 0 then
            direction:Normalize()
            local accel = shiftHeld and shiftAccel or normalAccel
            velocity = velocity + (direction * accel)
            if velocity:Size() > maxSpeed then
                velocity:Normalize()
                velocity = velocity * maxSpeed
            end
        else
            local currentSpeed = velocity:Size()
            if currentSpeed > 0 then
                velocity:Normalize()
                local newSpeed = math.max(currentSpeed - decel, 0)
                velocity = velocity * newSpeed
            end
        end
        helicamCube:TranslateTo(helicamCube:GetLocation() + velocity * 0.016, 0.1, 0)
    end, 40)

    updateTimer = Timer.SetInterval(function()
        if not helicamCube or not helicamLight then return end
        helicamLight:SetLocation(Client.GetLocalPlayer():GetCameraLocation())
        helicamLight:SetRotation(Client.GetLocalPlayer():GetCameraRotation())
        local speed = math.floor(velocity:Size())
        local elevation = math.floor(helicamCube:GetLocation().Z)
        local t = os.date('%H:%M:%S')
        local yaw = Client.GetLocalPlayer():GetCameraRotation().Yaw
        local compass = GetCompassDirection(yaw)
        helicamUI:CallEvent('UpdateHUD', speed, elevation, t, compass)
    end, 1)
end

local function StopHelicam()
    if helicamCube and helicamLight then
        helicamCube:Destroy()
        helicamCube = nil
        helicamLight:Destroy()
        helicamLight = nil
        velocity = Vector(0, 0, 0)
        helicamUI:SetVisibility(WidgetVisibility.Hidden)
    end
    if moveTimer then Timer.ClearInterval(moveTimer) end
    if updateTimer then Timer.ClearInterval(updateTimer) end
end

Events.SubscribeRemote('helicam:client:toggle', function()
    if helicamCube and helicamLight then
        StopHelicam()
        Events.CallRemote('helicam:server:toggle', false)
    else
        Events.CallRemote('helicam:server:toggle', true)
        Timer.SetTimeout(function()
            StartHelicam()
        end, 200)
    end
end)
