local my_webui = WebUI("Lockpick", "file://html/index.html")
local lockpick

Input.Subscribe("KeyDown", function(key_name)
	if not lockpick then
		return
	end
	my_webui:CallEvent("KeyDown", key_name)
end)

Input.Subscribe("KeyUp", function(key_name)
	if not lockpick then
		return
	end
	my_webui:CallEvent("KeyUp", key_name)
end)

my_webui:Subscribe("lockpickExit", function()
	if not lockpick then
		return
	end
	lockpick:resolve(false)
	lockpick = nil
end)

my_webui:Subscribe("lockpickFinish", function(success)
	if not lockpick then
		return
	end
	lockpick:resolve(success)
	lockpick = nil
end)

local function Lockpick(pins)
	lockpick = Promise.new()
	my_webui:BringToFront()
	my_webui:CallEvent("startLockpick", pins)
	return lockpick:await()
end
Package.Export("Lockpick", Lockpick)

Events.SubscribeRemote("qb-minigames:test:lockpick", function()
	local success = Lockpick(5)
	if success then
		Console.Log("Lockpick successful!")
	else
		Console.Log("Lockpick failed!")
	end
end)
