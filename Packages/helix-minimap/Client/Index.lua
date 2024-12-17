local minimapUI = WebUI('Minimap', 'file:///UI/index.html')
local Minimap = {}
local blipsReceivedFromMapPackage = false

-- Generate a unique hash ID for blips
function GenerateHashId()
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local hashLength = 8
    local hash = {}

    local firstCharIndex = math.random(1, 52)
    table.insert(hash, charset:sub(firstCharIndex, firstCharIndex))

    for i = 2, hashLength do
        local randomIndex = math.random(1, #charset)
        table.insert(hash, charset:sub(randomIndex, randomIndex))
    end

    return table.concat(hash)
end

-- Assign IDs and icons to blips without them
for _, blip in ipairs(MinimapSettings.MapBlips) do
    if not blip.id then
        blip.id = GenerateHashId()
    end
    if not blip.imgUrl then
        blip.imgUrl = './media/map-icons/NonImgBlip.svg'
    end
end

-- Add a new blip to the minimap
function Minimap:AddBlip(blipData)
    if not blipData.id then
        blipData.id = GenerateHashId()
    end
    if not blipData.imgUrl then
        blipData.imgUrl = './media/map-icons/NonImgBlip.svg'
    end

    table.insert(MinimapSettings.MapBlips, blipData)
    minimapUI:CallEvent('SetBlips', MinimapSettings.MapBlips)
    minimapUI:CallEvent('BlinkBlip', blipData.id)
end

-- Remove a blip from the minimap
function Minimap:RemoveBlip(blipId)
    for i, blip in ipairs(MinimapSettings.MapBlips) do
        if blip.id == blipId then
            table.remove(MinimapSettings.MapBlips, i)
            break
        end
    end
    minimapUI:CallEvent('SetBlips', MinimapSettings.MapBlips)
end

-- Set waypoint on the minimap
function Minimap:SetWaypoint(waypointBlip)
    minimapUI:CallEvent('SetWaypoint', waypointBlip)
    minimapUI:CallEvent('BlinkWaypoint')
end

-- Remove waypoint from the minimap
function Minimap:RemoveWaypoint()
    minimapUI:CallEvent('RemoveWaypoint')
end

-- Event handlers for managing minimap blips and waypoints
Events.Subscribe('Minimap:SetWaypoint', function(waypointBlip)
    Minimap:SetWaypoint(waypointBlip)
end)

Events.Subscribe('Minimap:RemoveWaypoint', function()
    Minimap:RemoveWaypoint()
end)

Events.Subscribe('Minimap:AddBlip', function(blipData)
    if blipData.type == 'waypoint' then
        Minimap:SetWaypoint(blipData)
    else
        Minimap:AddBlip(blipData)
    end
end)

Events.Subscribe('Minimap:RemoveBlip', function(blipId)
    Minimap:RemoveBlip(blipId)
end)

-- Initialize blips if received from the map package
Events.Subscribe("Minimap:SetInitialBlips", function(blips)
    blipsReceivedFromMapPackage = true
    MinimapSettings.MapBlips = blips
    minimapUI:CallEvent('SetBlips', MinimapSettings.MapBlips)
end)

Events.Subscribe("Minimap:SetBlips", function(blips)
    MinimapSettings.MapBlips = blips
    minimapUI:CallEvent('SetBlips', MinimapSettings.MapBlips)
end)

-- Blink specific blip
Events.Subscribe('Minimap:BlinkBlip', function(blipId)
    minimapUI:CallEvent('BlinkBlip', blipId)
end)

Events.Subscribe('Minimap:BlinkWaypoint', function()
    minimapUI:CallEvent('BlinkWaypoint')
end)

-- Update player position and heading on the minimap
Client.Subscribe('Tick', function(delta_time)
    local player = Client.GetLocalPlayer()
    if not player then return end
    local char = player:GetControlledCharacter()
    if not char then return end

    local location = char:GetLocation()
    local heading = char:GetRotation().Yaw
    local cameraRotation = player:GetCameraRotation().Yaw

    minimapUI:CallEvent('UpdatePlayerPos', location.X, location.Y, heading, cameraRotation)
end)

-- Toggle minimap shape between circle and square
Console.RegisterCommand('ToggleMinimapShape', function(args)
    if MinimapSettings.Shape == 'circle' then
        MinimapSettings.Shape = 'square'
    else
        MinimapSettings.Shape = 'circle'
    end
    minimapUI:CallEvent('SetMinimapShape', MinimapSettings.Shape)
end)

-- Set known coordinates, shape, and scale on minimap load
Package.Subscribe('Load', function()
    minimapUI:CallEvent('SetKnownCoords', MinimapSettings.KnownGameCoords, MinimapSettings.KnownImageCoords)
    minimapUI:CallEvent('SetMinimapShape', MinimapSettings.Shape)
    minimapUI:CallEvent('SetMinimapScale', MinimapSettings.Scale)
    if not blipsReceivedFromMapPackage then
        MinimapSettings.MapBlips = {}
        minimapUI:CallEvent('SetBlips', MinimapSettings.MapBlips)
    end
end)

-- Generate a unique ID for blips without one
function GenerateHashId()
    local charset = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local hashLength = 4
    local hash = {}

    math.randomseed(os.time() + math.random(1000))

    for i = 1, hashLength do
        local randomIndex = math.random(1, #charset)
        table.insert(hash, charset:sub(randomIndex, randomIndex))
    end

    return table.concat(hash)
end

-- Assign IDs and icons to existing blips
for _, blip in ipairs(MinimapSettings.MapBlips) do
    if not blip.id then
        blip.id = GenerateHashId()
    end
    if not blip.imgUrl then
        blip.imgUrl = './media/map-icons/NonImgBlip.svg'
    end
end
