local my_webui = WebUI("WordScramble", "file://html/index.html")
local wordScramble

local function CloseGame()
	my_webui:CallEvent("close")
end

my_webui:Subscribe("scrambleIncorrect", function()
	if not wordScramble then
		return
	end
	Input.SetMouseEnabled(false)
	wordScramble:resolve(false)
	wordScramble = nil
	CloseGame()
end)

my_webui:Subscribe("scrambleCorrect", function()
	if not wordScramble then
		return
	end
	Input.SetMouseEnabled(false)
	wordScramble:resolve(true)
	wordScramble = nil
	CloseGame()
end)

my_webui:Subscribe("scrambleTimeOut", function()
	if not wordScramble then
		return
	end
	Input.SetMouseEnabled(false)
	wordScramble:resolve(false)
	wordScramble = nil
	CloseGame()
end)

my_webui:Subscribe("closeScramble", function()
	if not wordScramble then
		return
	end
	Input.SetMouseEnabled(false)
	wordScramble:resolve(false)
	wordScramble = nil
	CloseGame()
end)

local function WordScramble(word, hint, timer)
	wordScramble = Promise.new()
	my_webui:BringToFront()
	Input.SetMouseEnabled(true)
	my_webui:CallEvent("wordScramble", word, hint, timer)
	return wordScramble:await()
end
Package.Export("WordScramble", WordScramble)

Events.SubscribeRemote("qb-minigames:test:wordscramble", function()
	local result = WordScramble("test", "test", 5)
	if result then
		Console.Log("Word guessed correctly!")
	else
		Console.Log("Too many guesses!")
	end
end)
