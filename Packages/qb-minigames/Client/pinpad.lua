local my_webui = WebUI("PinPad", "file://html/index.html")
local pinpadPromise

Input.Subscribe("KeyPress", function(key_name)
	if not pinpadPromise then
		return
	end
	my_webui:CallEvent("KeyPress", key_name)
end)

my_webui:Subscribe("pinpadExit", function()
	if not pinpadPromise then
		return
	end
	Input.SetMouseEnabled(false)
	pinpadPromise:resolve({ quit = true })
	pinpadPromise = nil
end)

my_webui:Subscribe("pinpadFinish", function(correct)
	if not pinpadPromise then
		return
	end
	Input.SetMouseEnabled(false)
	pinpadPromise:resolve({ quit = false, correct = correct })
	pinpadPromise = nil
end)

local function StartPinpad(numbers)
	pinpadPromise = Promise.new()
	my_webui:BringToFront()
	Input.SetMouseEnabled(true)
	my_webui:CallEvent("openPinpad", numbers)
	return pinpadPromise:await()
end
Package.Export("StartPinpad", StartPinpad)

Events.SubscribeRemote("qb-minigames:test:pinpad", function()
	local result = StartPinpad(5)
	if result.quit then
		Console.Log("Pinpad exited!")
	else
		Console.Log("Pinpad finished with " .. (result.correct and "correct" or "incorrect") .. " input!")
	end
end)
