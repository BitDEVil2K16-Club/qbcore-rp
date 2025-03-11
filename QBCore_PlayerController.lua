---@type QBCore_PlayerController_C
local M = UnLua.Class()

function M:ReceiveBeginPlay()
    if self:HasAuthority() then
        --QBCore.Player.Login(self)
        print("call what we need to from server")
        return
    end
end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

return M