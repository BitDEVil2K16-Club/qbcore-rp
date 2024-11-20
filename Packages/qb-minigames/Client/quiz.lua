local my_webui = WebUI("Quiz", "file://html/index.html")
local quiz
local required = 0

Input.Subscribe("KeyPress", function(key_name)
	if not quiz then
		return
	end
	my_webui:CallEvent("KeyPress", key_name)
end)

my_webui:Subscribe("exitQuiz", function()
	if not quiz then
		return
	end
	Input.SetMouseEnabled(false)
	quiz:resolve(false)
	quiz = nil
	required = 0
end)

my_webui:Subscribe("quitQuiz", function(score)
	if not quiz then
		return
	end
	if score >= required then
		quiz:resolve(true)
	else
		quiz:resolve(false)
	end
	Input.SetMouseEnabled(false)
	quiz = nil
	required = 0
end)

local function Quiz(questions, correctRequired, timer)
	for i, question in ipairs(questions) do
		question.numb = i
	end
	required = correctRequired
	quiz = Promise.new()
	my_webui:BringToFront()
	Input.SetMouseEnabled(true)
	my_webui:CallEvent("startQuiz", questions, timer)
	return quiz:await()
end
Package.Export("Quiz", Quiz)

Events.SubscribeRemote("qb-minigames:test:quiz", function()
	local success = Quiz({
		{ question = "What is 1 + 1?", answers = { "1", "2", "3", "4" }, correct = 2 },
		{ question = "What is 2 + 2?", answers = { "1", "2", "3", "4" }, correct = 4 },
		{ question = "What is 3 + 3?", answers = { "1", "2", "3", "4" }, correct = 6 },
		{ question = "What is 4 + 4?", answers = { "1", "2", "3", "4" }, correct = 8 },
		{ question = "What is 5 + 5?", answers = { "1", "2", "3", "4" }, correct = 10 },
	}, 3, 10)
	if success then
		Console.Log("Quiz successful!")
	else
		Console.Log("Quiz failed!")
	end
end)
