-- Recursive function to apply player data to state
local function ApplyPlayerState(source, data, key)
    for k, v in pairs(data) do
        --print(string.format('Setting State: state[%s%s] = %s', key and key .. ':' or '', k, v)) Debug print
        if type(v) == 'table' then
            source.playerState[k] = {}
            ApplyPlayerState(source, v, k)
        else
            if key then
                source.playerState[key][k] = v
            else
                source.playerState[k] = v
            end
        end
    end
end

local function CreatePlayer(source, existingData, newData)
    local self = {}
    self.Functions = {}
    local playerState = source.PlayerState

    playerState.source = source
    playerState.license = 'license:qwerty'--UE.UKismetGuidLibrary:NewGuid():ToString()
    playerState.name = playerState:GetPlayerName()

    if existingData then
        for column, data in pairs(existingData) do
            if playerState[column] then
                local decodedData = json.decode(data)
                if decodedData then
                    ApplyPlayerState(source, decodedData, column)
                else
                    playerState[column] = data
                end
            end
        end
    else
        playerState.cid = newData.CID
        -- Hacky solution for writing json/table to struct via KVP
        for k, v in pairs(newData.CharInfo) do
            playerState.charinfo[k] = v
        end
        playerState.citizenid = QBCore.Functions.CreateCitizenId()
        playerState.charinfo.phone = QBCore.Functions.CreatePhoneNumber()
        playerState.charinfo.account = QBCore.Functions.CreateAccountNumber()
        playerState.metadata.bloodtype = QBCore.Functions.GetRandomElement(QBCore.Config.Player.Bloodtypes)
        playerState.metadata.fingerprint = QBCore.Functions.CreateFingerId()
        playerState.metadata.walletid = QBCore.Functions.CreateWalletId()
    end

    function self.Functions.Logout()
        QBCore.Player.Logout(playerState.source)
    end

    function self.Functions.Save()
        QBCore.Player.Save(playerState.source)
    end

    QBCore.Players[playerState.source] = self
    QBCore.Player.Save(playerState.source, newData and true or false)

    local PawnClass = UE.UClass.Load('/Game/ThirdPerson/Blueprints/BP_ThirdPersonCharacter.BP_ThirdPersonCharacter_C')
    local Transform = UE.FTransform()
    Transform.Rotation = UE.FQuat(0, 0, 0, 80)
    Transform.Translation = UE.FVector(0, 0, 100)
    local Pawn = source:GetWorld():SpawnActor(PawnClass, Transform, UE.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
    source:Possess(Pawn)

    return self
end

function QBCore.Player.Login(source, citizenid, newData)
    if not source or source == '' then
        error('[QBCore] ERROR QBCORE.PLAYER.LOGIN - NO SOURCE GIVEN!')
        --QBCore.ShowError(resourceName, 'ERROR QBCORE.PLAYER.LOGIN - NO SOURCE GIVEN!')
        return false
    end

    if citizenid then
        local DatabaseSubsystem = UE.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(source, UE.UClass.Load('/QBCore/B_DatabaseSubsystem.B_DatabaseSubsystem_C'))
        local DB = DatabaseSubsystem:GetDatabase()
        local result = DB:Select('SELECT * FROM players WHERE citizenid = ?', { citizenid })
        if not result then return error('[QBCore] Couldn\'t load PlayerData for ' .. citizenid) end
        CreatePlayer(source, json.decode(result)[1])         -- existing player
    else
        CreatePlayer(source, false, newData) -- new player
    end
    return true
end

function QBCore.Player.Logout(source)
    QBCore.Players[source] = nil
end

function QBCore.Player.Save(source, new)
    local ped = source:K2_GetPawn()
    if not QBCore.Players[source] then return end
    local playerState = source.PlayerState
    local OutPos = UE.FVector(0, 0, 0) -- Unsure if this works, just how it's documented
    local pcoords = (ped and ped:K2_GetActorLocation()) or source:GetPlayerViewpoint(OutPos)
    if playerState then
        local DatabaseSubsystem = UE.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(source, UE.UClass.Load('/QBCore/B_DatabaseSubsystem.B_DatabaseSubsystem_C'))
        local DB = DatabaseSubsystem:GetDatabase()
        if new then
            local Success = DB:Execute(string.format('INSERT INTO players (citizenid, cid, license, name, money, charinfo, job, gang, position, metadata) VALUES (\'%s\', \'%d\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')',
                playerState.citizenid,
                playerState.cid,
                playerState.license,
                playerState.name,
                playerState:GetPlayerData('money'),
                playerState:GetPlayerData('charinfo'),
                playerState:GetPlayerData('job'),
                playerState:GetPlayerData('gang'),
                json.encode({ x = pcoords.X, y = pcoords.Y, z = pcoords.Z }),
                playerState:GetPlayerData('metadata')
            ), {})
            if not Success then error('[QBCore] ERROR QBCORE.PLAYER.SAVE - FAILED TO INSERT NEW PLAYER!') end
        else
            DB:Execute(string.format('UPDATE players SET money = \'%s\', charinfo = \'%s\', job = \'%s\', gang = \'%s\', position = \'%s\', metadata = \'%s\' WHERE citizenid = \'%s\'',
                playerState:GetPlayerData('money'),
                playerState:GetPlayerData('charinfo'),
                playerState:GetPlayerData('job'),
                playerState:GetPlayerData('gang'),
                json.encode({ x = pcoords.X, y = pcoords.Y, z = pcoords.Z }),
                playerState:GetPlayerData('metadata'),
                playerState.citizenid), -- Needs changing to prepared statements
            {})
        end
        print('[QBCore] ' .. playerState.citizenid .. ' PLAYER SAVED!')
    else
        error('[QBCore] ERROR QBCORE.PLAYER.SAVE - PLAYERDATA IS EMPTY!')
    end
end

local function GetPlayerTables(source)
    local DatabaseSubsystem = UE.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(source, UE.UClass.Load('/QBCore/B_DatabaseSubsystem.B_DatabaseSubsystem_C'))
    local DB = DatabaseSubsystem:GetDatabase()

    local tables = {}

    local MasterTableResults = DB:Select('SELECT name FROM sqlite_master WHERE type = "table"', {})
    for _, row in ipairs(json.decode(MasterTableResults)) do
        local TableInformation = DB:Select(string.format('PRAGMA table_info("%s")', row.name ), {})
        for _, ColumnResult in pairs(json.decode(TableInformation)) do
            if ColumnResult.name == 'citizenid' then
                tables[#tables + 1] = row.name
                break
            end
        end
    end

    return tables
end

function QBCore.Player.DeleteCharacter(source, citizenid)
    local DatabaseSubsystem = UE.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(source, UE.UClass.Load('/QBCore/B_DatabaseSubsystem.B_DatabaseSubsystem_C'))
    local DB = DatabaseSubsystem:GetDatabase() -- Database solution will be changing

    local license = source.playerState.license or 'license:qwerty'                             -- Needs changing to Helix ID
    local result = DB:Select('SELECT license FROM players WHERE citizenid = ?', { citizenid }) -- Database solution is changing
    if license == json.decode(result)[1].license then
        local tables = GetPlayerTables(source)

        -- Transactions aren't supported currently
        for _, tableName in ipairs(tables) do
            --table.insert(queries, { query = ('DELETE FROM `%s` WHERE citizenid = ?'):format(tableName), values = { citizenid } })
            DB:Execute(string.format('DELETE FROM `%s` WHERE citizenid = "%s"', tableName, citizenid), {})
        end
    else
        -- DropPlayer(source, Lang:t('info.exploit_dropped')) -- Will need to change to an UnLua kick method
        -- TriggerEvent('qb-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(source) .. ' Has Been Dropped For Character Deletion Exploit', true)
    end
end
