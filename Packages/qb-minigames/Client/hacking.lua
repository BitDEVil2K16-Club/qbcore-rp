local my_webui = WebUI("Hacking", "file://html/index.html")
local hacking

Input.Subscribe("KeyPress", function(key_name)
	if not hacking then
		return
	end
	my_webui:CallEvent("KeyPress", key_name)
end)

my_webui:Subscribe("hackSuccess", function()
	if not hacking then
		return
	end
	hacking:resolve(true)
	hacking = nil
end)

my_webui:Subscribe("hackFail", function()
	if not hacking then
		return
	end
	hacking:resolve(false)
	hacking = nil
end)

my_webui:Subscribe("hackClosed", function()
	if not hacking then
		return
	end
	hacking:resolve(false)
	hacking = nil
end)

local function Hacking(solutionsize, timeout)
	hacking = Promise.new()
	my_webui:BringToFront()
	my_webui:CallEvent("startHack", solutionsize, timeout)
	return hacking:await()
end
Package.Export("Hacking", Hacking)

Events.SubscribeRemote("qb-minigames:test:hacking", function()
	local success = Hacking(5, 10)
	if success then
		Console.Log("Hack successful!")
	else
		Console.Log("Hack failed!")
	end
end)
