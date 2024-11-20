local my_webui = WebUI("Skillbar", "file://html/index.html")
local skillbar

Input.Subscribe("KeyPress", function(key_name)
	if not skillbar then
		return
	end
	my_webui:CallEvent("KeyPress", key_name)
end)

my_webui:Subscribe("skillbarFinish", function(data)
	if not skillbar then
		return
	end
	skillbar:resolve(data.success)
	skillbar = nil
end)

local function Skillbar(difficulty, validKeys)
	skillbar = Promise.new()
	my_webui:BringToFront()
	my_webui:CallEvent("openSkillbar", difficulty or "easy", validKeys or "1234")
	return skillbar:await()
end
Package.Export("Skillbar", Skillbar)

Events.SubscribeRemote("qb-minigames:test:skillbar", function()
	local success = Skillbar("easy", "1234")
	if success then
		Console.Log("Skillbar successful!")
	else
		Console.Log("Skillbar failed!")
	end
end)
