--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type QBCore_GameMode_C
local M = UnLua.Class()

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

function M:ReceiveBeginPlay()
    --print('QBCore_GameMode_C:ReceiveBeginPlay')
end

function M:K2_PostLogin(NewPlayerController)
    print('QBCore_GameMode_C:K2_PostLogin', NewPlayerController)
end

function M:K2_OnLogout()
    print('QBCore_GameMode_C:K2_OnLogout')
end

function M:ReceiveEndPlay()
    --print('QBCore_GameMode_C:ReceiveEndPlay')
end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M
