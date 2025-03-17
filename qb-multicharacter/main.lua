local M = UnLua.Class()

-- function M:ReceiveBeginPlay()
-- end

function M:HandlePlay(CitizenID)
    self:GetOwningPlayer():Login_Server(CitizenID)
end

function M:HandleNewChar(CharInfoStruct, CID)
    self:GetOwningPlayer():NewCharacter_Server(CharInfoStruct, CID)
end

return M
