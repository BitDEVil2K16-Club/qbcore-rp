local my_webui = WebUI("KeyGame", "file://html/index.html")
local keyminigame

Input.Subscribe("KeyPress", function(key_name)
	if not keyminigame then
		return
	end
	my_webui:CallEvent("KeyPress", key_name)
end)

my_webui:Subscribe("keyminigameExit", function()
	if not keyminigame then
		return
	end
	keyminigame:resolve({ quit = true, faults = 0 })
	keyminigame = nil
end)

my_webui:Subscribe("keyminigameFinish", function(faults)
	if not keyminigame then
		return
	end
	keyminigame:resolve({ quit = false, faults = faults })
	keyminigame = nil
end)

local function KeyMinigame(amount)
	keyminigame = Promise.new()
	my_webui:CallEvent("startKeygame", amount)
	return keyminigame:await()
end
Package.Export("KeyMinigame", KeyMinigame)

Events.SubscribeRemote("qb-minigames:test:keygame", function()
	local result = KeyMinigame(5)
	if result.quit then
		Console.Log("Keygame exited!")
	else
		Console.Log("Keygame finished with " .. result.faults .. " faults!")
	end
end)
