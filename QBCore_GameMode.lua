---@type QBCore_GameMode_C
local M = UnLua.Class()

-- function M:K2_PostLogin(source)
--     print('QBCore_GameMode_C:K2_PostLogin')
-- end

-- function M:K2_OnLogout(source)
--     print('QBCore_GameMode_C:K2_OnLogout')
-- end

function M:ReceiveBeginPlay()
    self.Overridden.ReceiveBeginPlay(self)
    print('QBCore_GameMode_C:ReceiveBeginPlay')
    local gameInstance = UE.UGameplayStatics.GetGameInstance(self)
    local dbSubsystem = UE.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(
        gameInstance,
        UE.UClass.Load('/QBCore/B_DatabaseSubsystem.B_DatabaseSubsystem_C')
    )
    local database = UE.NewObject(UE.UDatabase, self)
    local contentDir = UE.UKismetSystemLibrary.GetProjectContentDirectory()
    local dbPath = contentDir .. 'Script/QBCore/qb-core/qbcore.db'
    local success = database:Open(dbPath)
    if success then
        print('Database opened successfully')
        dbSubsystem:SetDatabase(database)
    end
end

function M:ReceiveEndPlay()
    self.Overridden.ReceiveEndPlay(self)
    print('QBCore_GameMode_C:ReceiveEndPlay')
    local gameInstance = UE.UGameplayStatics.GetGameInstance(self)
    local dbSubsystem = UE.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(
        gameInstance,
        UE.UClass.Load('/QBCore/B_DatabaseSubsystem.B_DatabaseSubsystem_C')
    )
    local DB = dbSubsystem:GetDatabase()
    if DB then
        print('Database closed successfully')
        DB:Close()
    end
end

return M
