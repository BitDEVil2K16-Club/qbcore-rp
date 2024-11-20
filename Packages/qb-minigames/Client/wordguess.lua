local my_webui = WebUI("WordGuess", "file://html/index.html")
local wordGuess

Input.Subscribe("KeyPress", function(key_name)
	if not wordGuess then
		return
	end
	my_webui:CallEvent("KeyPress", key_name)
end)

local function CloseGame()
	my_webui:CallEvent("closeWordGuess")
end

my_webui:Subscribe("wordGuessedCorrectly", function()
	if not wordGuess then
		return
	end
	Input.SetMouseEnabled(false)
	wordGuess:resolve(true)
	wordGuess = nil
	CloseGame()
end)

my_webui:Subscribe("tooManyGuesses", function()
	if not wordGuess then
		return
	end
	Input.SetMouseEnabled(false)
	wordGuess:resolve(false)
	wordGuess = nil
	CloseGame()
end)

my_webui:Subscribe("closeWordGuess", function()
	if not wordGuess then
		return
	end
	Input.SetMouseEnabled(false)
	wordGuess:resolve(false)
	wordGuess = nil
end)

local function WordGuess(word, hint, guesses)
	wordGuess = Promise.new()
	my_webui:BringToFront()
	Input.SetMouseEnabled(true)
	my_webui:CallEvent("wordGuess", word, hint, guesses)
	return wordGuess:await()
end
Package.Export("WordGuess", WordGuess)

Events.SubscribeRemote("qb-minigames:test:wordguess", function()
	local result = WordGuess("test", "test", 5)
	if result then
		Console.Log("Word guessed correctly!")
	else
		Console.Log("Too many guesses!")
	end
end)
