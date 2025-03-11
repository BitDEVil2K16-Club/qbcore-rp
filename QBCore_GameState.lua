---@type QBCore_GameState_C
local M = UnLua.Class()

function M:ReceiveBeginPlay()
    require('/QBCore/qb-core/core')
end

-- function M:ReceiveEndPlay()
-- end

return M