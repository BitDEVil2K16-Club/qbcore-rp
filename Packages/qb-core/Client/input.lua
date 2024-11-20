local my_webui = WebUI('Input', 'file://html/index.html')
local inputRoutine = nil
local function ShowInput(data)
    if not data then return end
    Input.SetMouseEnabled(true)
    my_webui:BringToFront()
    my_webui:CallEvent('OPEN_INPUT', { data = data })
    inputRoutine = coroutine.running()
    return coroutine.yield()
    -- print("Routine resumed")
    -- local dialog = {}
    -- dialog.amount = value
    -- print("dialog " ,HELIXTable.Dump(dialog))
    -- return dialog
end

Package.Export('ShowInput', ShowInput)

my_webui:Subscribe('buttonSumbit', function(data)
    Input.SetMouseEnabled(false)
    print("resume input coroutine with data", data.amount, " ",HELIXTable.Dump(data))
    if inputRoutine then
        coroutine.resume(inputRoutine, { amount = tonumber(data.amount)})
    end
end)

my_webui:Subscribe('closeMenu', function()
    Input.SetMouseEnabled(false)
end)

