local promise = {}
promise.__index = promise

-- Create a new promise
function promise.new()
    local self = setmetatable({}, promise)
    self.state = 'pending'
    self.value = nil
    self.reason = nil
    self.fulfillCallbacks = {}
    self.rejectCallbacks = {}
    return self
end

-- Resolve the promise
function promise:resolve(value)
    if self.state ~= 'pending' then
        return
    end
    self.state = 'fulfilled'
    self.value = value
    for _, callback in ipairs(self.fulfillCallbacks) do
        callback(value)
    end
    self.fulfillCallbacks = nil
    self.rejectCallbacks = nil
end

-- Reject the promise
function promise:reject(reason)
    if self.state ~= 'pending' then
        return
    end
    self.state = 'rejected'
    self.reason = reason
    for _, callback in ipairs(self.rejectCallbacks) do
        callback(reason)
    end
    self.fulfillCallbacks = nil
    self.rejectCallbacks = nil
end

-- Await the promise resolution or rejection
function promise:await()
    if self.state == 'fulfilled' then
        return self.value
    elseif self.state == 'rejected' then
        error(self.reason)
    else
        local co = coroutine.running()
        if not co then
            error('promise:await() must be called from within a coroutine')
        end
        local function fulfill(value)
            coroutine.resume(co, true, value)
        end
        local function reject(reason)
            coroutine.resume(co, false, reason)
        end
        table.insert(self.fulfillCallbacks, fulfill)
        table.insert(self.rejectCallbacks, reject)
        return coroutine.yield()
    end
end

return promise
