local RoadNodes = {}
local RoadConnections = {}

Package.Subscribe('Load', function()
    LoadRoadsFromConfig()
end)

function LoadRoadsFromConfig()
    print('[Info] Loading road data from Config file')

    local configData = Config.RoadsData
    if not configData or not configData.nodes or not configData.connections then
        print('[Error] Invalid road data in Config')
        return
    end

    RoadNodes = {}
    for _, node in ipairs(configData.nodes) do
        RoadNodes[node.id] = { x = node.x, y = node.y, z = node.z }
    end

    RoadConnections = configData.connections
    print('[Success] Road data loaded: ' .. tostring(#configData.nodes) .. ' nodes, ' .. tostring(#RoadConnections) .. ' connections')
end

-- BFS o A*
function FindRoute(startId, endId)
    if startId == endId then
        return { startId }
    end

    local visited = {}
    local queue = { startId }
    local cameFrom = {}

    visited[startId] = true

    while #queue > 0 do
        local current = table.remove(queue, 1)

        for _, conn in ipairs(RoadConnections) do
            local isForward  = (conn.from == current)
            local isBackward = (conn.to == current and conn.direction == 'bidirectional')
            local neighbor   = nil

            if isForward then
                neighbor = conn.to
            elseif isBackward then
                neighbor = conn.from
            end

            if neighbor and not visited[neighbor] then
                visited[neighbor] = true
                cameFrom[neighbor] = current
                table.insert(queue, neighbor)

                if neighbor == endId then
                    -- Reconstruct path
                    local route = { neighbor }
                    local prev = current
                    while prev do
                        table.insert(route, 1, prev)
                        prev = cameFrom[prev]
                    end
                    return route
                end
            end
        end
    end

    return nil
end

function RecalculateRoute(playerLoc, waypointLoc)
    local startId = GetNearestNode(playerLoc)
    local endId   = GetNearestNode(waypointLoc)

    if startId and endId then
        local routeNodeIDs = FindRoute(startId, endId)
        return routeNodeIDs
    end
    return nil
end

function GetNearestNode(loc)
    local bestId = nil
    local bestDistSqr = math.huge
    for id, nodePos in pairs(RoadNodes) do
        local dx = loc.X - nodePos.x
        local dy = loc.Y - nodePos.y
        local dz = loc.Z - (nodePos.z or 0)
        local distSqr = dx * dx + dy * dy + dz * dz
        if distSqr < bestDistSqr then
            bestDistSqr = distSqr
            bestId = id
        end
    end
    return bestId
end

function GetRoutePositionsFromIDs(routeNodeIDs)
    if not routeNodeIDs then return {} end

    local outPositions = {}
    for _, nodeId in ipairs(routeNodeIDs) do
        local np = RoadNodes[nodeId]
        if np then
            table.insert(outPositions, { x = np.x, y = np.y, z = np.z })
        end
    end
    return outPositions
end
