---@type QBCore_PlayerState_C
local M = UnLua.Class()

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

function M:OnRep_money()
end

function M:OnRep_job()
end

function M:OnRep_gang()
end

function M:OnRep_charinfo()
end

function M:OnRep_metadata()
    print('M:OnRep_metadata()')
--     local meta = self.metadata
--     local player = self:GetOwningPlayer() -- controller
--     local widget = player.hud -- get reference to widget
--     widget:UpdateValue('Hunger', meta.hunger)
--     widget:UpdateValue('Thirst', meta.thirst)
    --widget:UpdateValue('Health', meta.health)
    --widget:UpdateValue('Armor', meta.armor)
    --widget:UpdateValue('Stamina', meta.stamina)
    --widget:UpdateValue('Voice', meta.voice)
end

function M:OnRep_items()
end

return M