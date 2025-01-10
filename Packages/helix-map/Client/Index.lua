local mapUI = WebUI('Map', 'file://UI/index.html', WidgetVisibility.Hidden)
local Map = {}

-- Add a blip to the map and minimap, triggering necessary events
function Map:AddBlip(blipData)
    blipData.id = blipData.id or GenerateHashId()
    blipData.imgUrl = blipData.imgUrl or './media/map-icons/NonImgBlip.svg'
    table.insert(MapSettings.MapBlips, blipData)
    mapUI:CallEvent('Map:SetBlips', MapSettings.MapBlips)
    Events.Call('Minimap:AddBlip', blipData)
    mapUI:CallEvent('Map:BlinkBlip', blipData.id)
    Events.Call('Minimap:BlinkBlip', blipData.id)
    return blipData.id
end

-- Remove a blip from the map and minimap by ID
function Map:RemoveBlip(blipId)
    for i, blip in ipairs(MapSettings.MapBlips) do
        if blip.id == blipId then
            table.remove(MapSettings.MapBlips, i)
            break
        end
    end
    mapUI:CallEvent('Map:SetBlips', MapSettings.MapBlips)
    Events.Call('Minimap:RemoveBlip', blipId)
end

-- Toggle the map's visibility and adjust input/mouse settings accordingly
function Map:ToggleVisibility()
    if mapUI:GetVisibility() == WidgetVisibility.Hidden then
        mapUI:SetVisibility(WidgetVisibility.Visible)
        mapUI:BringToFront()
        mapUI:SetFocus()
        Input.SetInputEnabled(false)
        Input.SetMouseEnabled(true)
        mapUI:CallEvent('Map:UpdateView')
    else
        mapUI:SetVisibility(WidgetVisibility.Hidden)
        Input.SetInputEnabled(true)
        Input.SetMouseEnabled(false)
    end
end

-- Update a blip's name on the map and minimap
function Map:ChangeBlipName(blipId, newName)
    for _, blip in ipairs(MapSettings.MapBlips) do
        if blip.id == blipId then
            blip.name = newName
            break
        end
    end
    mapUI:CallEvent('Map:SetBlips', MapSettings.MapBlips)
    Events.Call('Minimap:SetBlips', MapSettings.MapBlips)
end

-- Update a blip's icon on the map and minimap
function Map:ChangeBlipIcon(blipId, newImgUrl)
    for _, blip in ipairs(MapSettings.MapBlips) do
        if blip.id == blipId then
            blip.imgUrl = newImgUrl
            break
        end
    end
    mapUI:CallEvent('Map:SetBlips', MapSettings.MapBlips)
    Events.Call('Minimap:SetBlips', MapSettings.MapBlips)
end

-- Generate a unique hash ID for blips
function GenerateHashId()
    local charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local hashLength = 8
    local hash = {}

    local firstCharIndex = math.random(1, 52)
    local firstChar = charset:sub(firstCharIndex, firstCharIndex)
    table.insert(hash, firstChar)

    for i = 2, hashLength do
        local randomIndex = math.random(1, #charset)
        local randomChar = charset:sub(randomIndex, randomIndex)
        table.insert(hash, randomChar)
    end

    return table.concat(hash)
end

-- Event subscriptions for remote interactions
Events.SubscribeRemote('Map:AddBlip', function(blipData) Map:AddBlip(blipData) end)
Events.SubscribeRemote('Map:RemoveBlip', function(blipId) Map:RemoveBlip(blipId) end)
Events.SubscribeRemote('Map:ChangeBlipName', function(blipId, newName) Map:ChangeBlipName(blipId, newName) end)
Events.SubscribeRemote('Map:ChangeBlipIcon', function(blipId, newImgUrl) Map:ChangeBlipIcon(blipId, newImgUrl) end)

-- Subscribes to add/remove waypoint markers on the map and minimap
mapUI:Subscribe('Map:AddWaypointBlip', function(x, y)
    local waypointBlip = {
        coords = { x = x, y = y },
        name = 'Waypoint',
        imgUrl = './media/map-icons/marker.svg',
        type = 'waypoint'
    }

    mapUI:CallEvent('Map:SetWaypoint', waypointBlip)
    mapUI:CallEvent('Map:BlinkWaypoint')
    Events.Call('Minimap:SetWaypoint', waypointBlip)
    Events.Call('Minimap:BlinkWaypoint')
end)

mapUI:Subscribe('Map:RemoveWaypointBlip', function()
    mapUI:CallEvent('Map:RemoveWaypoint')
    Events.Call('Minimap:RemoveWaypoint')
end)

-- Toggle map visibility via the "M" key
mapUI:Subscribe('Map:ExitMap', function() Map:ToggleVisibility() end)
Input.Subscribe('KeyDown', function(key_name)
    if key_name == 'M' then Map:ToggleVisibility() end
end)

-- Updates player position on the map each tick
Client.Subscribe('Tick', function(delta_time)
    local player = Client.GetLocalPlayer()
    local character = player and player:GetControlledCharacter()
    if character then
        local location = character:GetLocation()
        local heading = character:GetRotation().Yaw
        mapUI:CallEvent('Map:UpdatePlayerPos', location.X, location.Y, heading)
    end
end)

-- Outputs current coordinates to chat upon command
Chat.Subscribe('PlayerSubmit', function(message)
    if message == 'GetCoords' then
        local character = Client.GetLocalPlayer():GetControlledCharacter()
        if character then
            local location = character:GetLocation()
            Chat.AddMessage('You are at ' .. location.X .. ', ' .. location.Y .. ', ' .. location.Z)
        end
    end
end)

-- Load initial settings for blips and coordinates
Package.Subscribe('Load', function()
    mapUI:CallEvent('Map:SetKnownCoords', MapSettings.KnownGameCoords, MapSettings.KnownImageCoords)
    mapUI:CallEvent('Map:SetBlips', MapSettings.MapBlips)
    Events.Call('Minimap:SetInitialBlips', MapSettings.MapBlips)
end)

-- Initialize default blip IDs and icons if missing
for _, blip in ipairs(MapSettings.MapBlips or {}) do
    blip.id = blip.id or GenerateHashId()
    blip.imgUrl = blip.imgUrl or './media/map-icons/NonImgBlip.svg'
end

Package.Export('Map', Map)
