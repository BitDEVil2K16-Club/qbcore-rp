QBCore.Commands.Add("hacking", "", {}, false, function(source)
	Events.CallRemote("qb-minigames:test:hacking", source)
end, "user")

QBCore.Commands.Add("keygame", "", {}, false, function(source)
	Events.CallRemote("qb-minigames:test:keygame", source)
end, "user")

QBCore.Commands.Add("lockpick", "", {}, false, function(source)
	Events.CallRemote("qb-minigames:test:lockpick", source)
end, "user")

QBCore.Commands.Add("pinpad", "", {}, false, function(source)
	Events.CallRemote("qb-minigames:test:pinpad", source)
end, "user")

QBCore.Commands.Add("quiz", "", {}, false, function(source)
	Events.CallRemote("qb-minigames:test:quiz", source)
end, "user")

QBCore.Commands.Add("skillbar", "", {}, false, function(source)
	Events.CallRemote("qb-minigames:test:skillbar", source)
end, "user")

QBCore.Commands.Add("wordguess", "", {}, false, function(source)
	Events.CallRemote("qb-minigames:test:wordguess", source)
end, "user")

QBCore.Commands.Add("wordscramble", "", {}, false, function(source)
	Events.CallRemote("qb-minigames:test:wordscramble", source)
end, "user")
