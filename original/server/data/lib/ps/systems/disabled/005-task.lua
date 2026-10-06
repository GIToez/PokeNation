print("IF YOU SEEING THIS, THE OLD TASK SYSTEM IS BEEING LOADED")

local storages = {
	base = 20000,
	status = {
		unstarted = -1,
		started = 0,
		finished = 1
	}
}

local TASKS = {
	["Rattata"] = {taskStorage = storages.base + 1, defeatsStorage = storages.base + 2, defeats = 10, rewards = {12244, 3, 12157, 10}, expReward = 150, nextTask = "Caterpie"}, -- 3x Pokemon Health Potion, 10x Empty Poke Ball
	["Caterpie"] = {taskStorage = storages.base + 3, defeatsStorage = storages.base + 4, defeats = 10, rewards = {12157, 10}, expReward = 200, nextTask = "Weedle"}, -- 10x Empty Poke Ball
	["Weedle"] = {taskStorage = storages.base + 5, defeatsStorage = storages.base + 6, defeats = 10, rewards = {12157, 10}, expReward = 200, nextTask = "Zubat"}, -- 10x Empty Poke ball
	["Zubat"] = {taskStorage = storages.base + 7, defeatsStorage = storages.base + 8, defeats = 40, rewards = {2148, 100}, expReward = 300, nextTask = "Pidgey"}, -- 100x Dollar
	["Pidgey"] = {taskStorage = storages.base + 9, defeatsStorage = storages.base + 10, defeats = 50, rewards = {}, expReward = 450, nextTask = "Metapod"},
	["Metapod"] = {taskStorage = storages.base + 11, defeatsStorage = storages.base + 12, defeats = 40, rewards = {2148, 75}, expReward = 400, nextTask = "Kakuna"}, -- 75x Dollar
	["Kakuna"] = {taskStorage = storages.base + 13, defeatsStorage = storages.base + 14, defeats = 40, rewards = {2148, 75}, expReward = 400, nextTask = "Magikarp"}, -- 75x Dollar
	["Magikarp"] = {taskStorage = storages.base + 15, defeatsStorage = storages.base + 16, defeats = 60, rewards = {12157, 15}, expReward = 300, nextTask = "Krabby"}, -- 15x Empty Poke Ball
	["Krabby"] = {taskStorage = storages.base + 17, defeatsStorage = storages.base + 18, defeats = 50, rewards = {12157, 15}, expReward = 400, nextTask = "Poliwag"}, -- 15x Empty Poke Ball
	["Poliwag"] = {taskStorage = storages.base + 19, defeatsStorage = storages.base + 20, defeats = 50, rewards = {2148, 150}, expReward = 450, nextTask = "Horsea"}, -- 150x Dollar
	["Horsea"] = {taskStorage = storages.base + 21, defeatsStorage = storages.base + 22, defeats = 50, rewards = {2148, 200}, expReward = 450, nextTask = "Goldeen"}, -- 200x Dollar
	["Goldeen"] = {taskStorage = storages.base + 23, defeatsStorage = storages.base + 24, defeats = 50, rewards = {12157, 10}, expReward = 550, nextTask = "Geodude"}, -- 10x Empty Poke Ball
	["Geodude"] = {taskStorage = storages.base + 25, defeatsStorage = storages.base + 26, defeats = 60, rewards = {12161, 10}, expReward = 500, nextTask = "Machop"}, -- 10x Empty Great Ball
	["Machop"] = {taskStorage = storages.base + 27, defeatsStorage = storages.base + 28, defeats = 60, rewards = {12161, 10}, expReward = 500, nextTask = "Oddish"}, -- 10x Empty Great Ball
	["Oddish"] = {taskStorage = storages.base + 29, defeatsStorage = storages.base + 30, defeats = 60, rewards = {}, expReward = 600, nextTask = "Bellsprout"},
	["Bellsprout"] = {taskStorage = storages.base + 31, defeatsStorage = storages.base + 32, defeats = 60, rewards = {}, expReward = 600, nextTask = "Tentacool"},
	["Tentacool"] = {taskStorage = storages.base + 33, defeatsStorage = storages.base + 34, defeats = 60, rewards = {12157, 20}, expReward = 600, nextTask = "Shellder"}, -- 20x Empty Poke Ball
	["Shellder"] = {taskStorage = storages.base + 35, defeatsStorage = storages.base + 36, defeats = 60, rewards = {12157, 20}, expReward = 600, nextTask = "Sandshrew"}, -- 20x Empty Poke Ball
	["Sandshrew"] = {taskStorage = storages.base + 37, defeatsStorage = storages.base + 38, defeats = 70, rewards = {}, expReward = 700, nextTask = "Clefairy"},
	["Clefairy"] = {taskStorage = storages.base + 39, defeatsStorage = storages.base + 40, defeats = 40, rewards = {}, expReward = 800, nextTask = "Jigglypuff"},
	["Jigglypuff"] = {taskStorage = storages.base + 41, defeatsStorage = storages.base + 42, defeats = 40, rewards = {}, expReward = 800, nextTask = "Squirtle"},
	["Squirtle"] = {taskStorage = storages.base + 43, defeatsStorage = storages.base + 44, defeats = 80, rewards = {12248, 3, 2148, 100}, expReward = 800, nextTask = "Charmander"}, -- 3x Pokemon Revive, 100x Dollar
	["Charmander"] = {taskStorage = storages.base + 45, defeatsStorage = storages.base + 46, defeats = 80, rewards = {12248, 3, 2148, 100}, expReward = 800, nextTask = "Bulbasaur"}, -- 3x Pokemon Revive, 100x Dollar
	["Bulbasaur"] = {taskStorage = storages.base + 47, defeatsStorage = storages.base + 48, defeats = 80, rewards = {12248, 3, 2148, 100}, expReward = 800, nextTask = "Psyduck"}, -- 3x Pokemon Revive, 100x Dollar
	["Psyduck"] = {taskStorage = storages.base + 49, defeatsStorage = storages.base + 50, defeats = 80, rewards = {}, expReward = 900, nextTask = "Growlithe"},
	["Growlithe"] = {taskStorage = storages.base + 51, defeatsStorage = storages.base + 52, defeats = 80, rewards = {}, expReward = 900, nextTask = "Exeggcute"},
	["Exeggcute"] = {taskStorage = storages.base + 53, defeatsStorage = storages.base + 54, defeats = 80, rewards = {}, expReward = 900, nextTask = "Abra"},
	["Abra"] = {taskStorage = storages.base + 55, defeatsStorage = storages.base + 56, defeats = 80, rewards = {2152, 3}, expReward = 900, nextTask = "Drowzee"},
	["Drowzee"] = {taskStorage = storages.base + 57, defeatsStorage = storages.base + 58, defeats = 80, rewards = {2152, 3}, expReward = 1000, nextTask = "Magnemite"},
	["Magnemite"] = {taskStorage = storages.base + 59, defeatsStorage = storages.base + 60, defeats = 90, rewards = {2152, 3}, expReward = 1000, nextTask = "Voltorb"},
	["Voltorb"] = {taskStorage = storages.base + 61, defeatsStorage = storages.base + 62, defeats = 90, rewards = {2152, 3}, expReward = 1000, nextTask = "Gastly"},
	["Gastly"] = {taskStorage = storages.base + 63, defeatsStorage = storages.base + 64, defeats = 60, rewards = {}, expReward = 1100, nextTask = "Seel"},
	["Seel"] = {taskStorage = storages.base + 65, defeatsStorage = storages.base + 66, defeats = 80, rewards = {}, expReward = 1200, nextTask = "Ivysaur"},
	["Ivysaur"] = {taskStorage = storages.base + 67, defeatsStorage = storages.base + 68, defeats = 100, rewards = {2152, 4}, expReward = 1300, nextTask = "Wartortle"},
	["Wartortle"] = {taskStorage = storages.base + 69, defeatsStorage = storages.base + 70, defeats = 100, rewards = {2152, 4}, expReward = 1300, nextTask = "Charmeleon"},
	["Charmeleon"] = {taskStorage = storages.base + 71, defeatsStorage = storages.base + 72, defeats = 100, rewards = {2152, 4}, expReward = 1300, nextTask = "Butterfree"},
	["Butterfree"] = {taskStorage = storages.base + 73, defeatsStorage = storages.base + 74, defeats = 80, rewards = {2152, 3}, expReward = 1400, nextTask = "Beedrill"},
	["Beedrill"] = {taskStorage = storages.base + 75, defeatsStorage = storages.base + 76, defeats = 80, rewards = {2152, 3}, expReward = 1400, nextTask = "Nidorina"},
	["Nidorina"] = {taskStorage = storages.base + 77, defeatsStorage = storages.base + 78, defeats = 40, rewards = {2152, 4}, expReward = 1500, nextTask = "Nidorino"},
	["Nidorino"] = {taskStorage = storages.base + 79, defeatsStorage = storages.base + 80, defeats = 40, rewards = {2152, 4}, expReward = 1500, nextTask = "Golbat"},
	["Golbat"] = {taskStorage = storages.base + 81, defeatsStorage = storages.base + 82, defeats = 110, rewards = {2152, 5}, expReward = 1600, nextTask = "Arbok"},
	["Arbok"] = {taskStorage = storages.base + 83, defeatsStorage = storages.base + 84, defeats = 110, rewards = {2152, 5}, expReward = 1600, nextTask = "Weezing"},
	["Weezing"] = {taskStorage = storages.base + 85, defeatsStorage = storages.base + 86, defeats = 110, rewards = {2152, 5}, expReward = 1600, nextTask = "Muk"},
	["Muk"] = {taskStorage = storages.base + 87, defeatsStorage = storages.base + 88, defeats = 110, rewards = {2152, 5}, expReward = 1600, nextTask = "Magneton"},
	["Magneton"] = {taskStorage = storages.base + 89, defeatsStorage = storages.base + 90, defeats = 110, rewards = {12165, 20}, expReward = 1700, nextTask = "Graveler"},
	["Graveler"] = {taskStorage = storages.base + 91, defeatsStorage = storages.base + 92, defeats = 120, rewards = {12165, 20}, expReward = 1700, nextTask = "Machoke"},
	["Machoke"] = {taskStorage = storages.base + 93, defeatsStorage = storages.base + 94, defeats = 120, rewards = {12165, 20}, expReward = 1700, nextTask = "Dugtrio"},
	["Dugtrio"] = {taskStorage = storages.base + 95, defeatsStorage = storages.base + 96, defeats = 120, rewards = {12165, 20}, expReward = 1700, nextTask = "Venomoth"},
	["Venomoth"] = {taskStorage = storages.base + 97, defeatsStorage = storages.base + 98, defeats = 100, rewards = {12245, 15}, expReward = 1800, nextTask = "Persian"},
	["Persian"] = {taskStorage = storages.base + 99, defeatsStorage = storages.base + 100, defeats = 100, rewards = {}, expReward = 2000, nextTask = "Kadabra"},
	["Kadabra"] = {taskStorage = storages.base + 101, defeatsStorage = storages.base + 102, defeats = 120, rewards = {}, expReward = 2100, nextTask = "Hypno"},
	["Hypno"] = {taskStorage = storages.base + 103, defeatsStorage = storages.base + 104, defeats = 120, rewards = {}, expReward = 2200, nextTask = "Haunter"},
	["Haunter"] = {taskStorage = storages.base + 105, defeatsStorage = storages.base + 106, defeats = 120, rewards = {}, expReward = 2300, nextTask = "Farfetchd"},
	["Farfetchd"] = {taskStorage = storages.base + 107, defeatsStorage = storages.base + 108, defeats = 50, rewards = {2152, 5}, expReward = 2300, nextTask = "Tangela"},
	["Tangela"] = {taskStorage = storages.base + 109, defeatsStorage = storages.base + 110, defeats = 80, rewards = {2152, 5}, expReward = 2400, nextTask = "Rapidash"},-- Skipping "Lickitung"},
	["Lickitung"] = {taskStorage = storages.base + 111, defeatsStorage = storages.base + 112, defeats = 30, rewards = {2152, 5}, expReward = 2500, nextTask = "Rapidash"},-- Skipping "Scyther"},
	["Scyther"] = {taskStorage = storages.base + 113, defeatsStorage = storages.base + 114, defeats = 15, rewards = {2152, 8}, expReward = 2600, nextTask = "Rapidash"},
	["Rapidash"] = {taskStorage = storages.base + 115, defeatsStorage = storages.base + 116, defeats = 130, rewards = {2152, 6}, expReward = 2700, nextTask = "Poliwrath"},
	["Poliwrath"] = {taskStorage = storages.base + 117, defeatsStorage = storages.base + 118, defeats = 130, rewards = {2152, 6}, expReward = 2700, nextTask = "Victreebel"},
	["Victreebel"] = {taskStorage = storages.base + 119, defeatsStorage = storages.base + 120, defeats = 130, rewards = {2152, 6}, expReward = 2700, nextTask = "Charizard"},
	["Charizard"] = {taskStorage = storages.base + 121, defeatsStorage = storages.base + 122, defeats = 140, rewards = {2152, 10}, expReward = 2800, nextTask = "Venusaur"},
	["Venusaur"] = {taskStorage = storages.base + 123, defeatsStorage = storages.base + 124, defeats = 140, rewards = {2152, 10}, expReward = 2800, nextTask = "Blastoise"},
	["Blastoise"] = {taskStorage = storages.base + 125, defeatsStorage = storages.base + 126, defeats = 140, rewards = {2152, 10}, expReward = 2800, nextTask = "Pidgeot"},
	["Pidgeot"] = {taskStorage = storages.base + 127, defeatsStorage = storages.base + 128, defeats = 140, rewards = {2152, 12}, expReward = 2900, nextTask = "Nidoqueen"},
	["Nidoqueen"] = {taskStorage = storages.base + 129, defeatsStorage = storages.base + 130, defeats = 25, rewards = {2152, 13}, expReward = 3000, nextTask = "Nidoking"},
	["Nidoking"] = {taskStorage = storages.base + 131, defeatsStorage = storages.base + 132, defeats = 25, rewards = {2152, 13}, expReward = 3000, nextTask = "Arcanine"},
	["Arcanine"] = {taskStorage = storages.base + 133, defeatsStorage = storages.base + 134, defeats = 150, rewards = {2152, 14}, expReward = 3100, nextTask = "Tentacruel"},
	["Tentacruel"] = {taskStorage = storages.base + 132, defeatsStorage = storages.base + 136, defeats = 150, rewards = {2152, 15}, expReward = 3200, nextTask = "Gyarados"},
	["Gyarados"] = {taskStorage = storages.base + 134, defeatsStorage = storages.base + 138, defeats = 150, rewards = {2152, 15}, expReward = 3200, nextTask = "Gengar"},
	["Gengar"] = {taskStorage = storages.base + 136, defeatsStorage = storages.base + 140, defeats = 150, rewards = {2152, 16}, expReward = 3300, nextTask = "Alakazam"},
	["Alakazam"] = {taskStorage = storages.base + 141, defeatsStorage = storages.base + 142, defeats = 150, rewards = {2152, 16}, expReward = 3300, nextTask = "Venusaur"}, -- Skipping "Scyther"},
	["Scyther"] = {taskStorage = storages.base + 143, defeatsStorage = storages.base + 144, defeats = 60, rewards = {12241, 1}, expReward = 0, nextTask = "Venusaur"},
	["Venusaur"] = {taskStorage = storages.base + 145, defeatsStorage = storages.base + 146, defeats = 2000, rewards = {12231, 1}, expReward = 0, nextTask = "Tentacruel"},
	["Tentacruel"] = {taskStorage = storages.base + 147, defeatsStorage = storages.base + 148, defeats = 2000, rewards = {12235, 1}, expReward = 0, nextTask = "Golem"},
	["Golem"] = {taskStorage = storages.base + 149, defeatsStorage = storages.base + 150, defeats = 2000, rewards = {12234, 1}, expReward = 0, nextTask = "Marowak"},
	["Marowak"] = {taskStorage = storages.base + 151, defeatsStorage = storages.base + 152, defeats = 2000, rewards = {13807, 1}, expReward = 0, nextTask = "Electabuzz"},
	["Electabuzz"] = {taskStorage = storages.base + 153, defeatsStorage = storages.base + 154, defeats = 500, rewards = {12237, 1}, expReward = 0, nextTask = "Jynx"},
	["Jynx"] = {taskStorage = storages.base + 155, defeatsStorage = storages.base + 156, defeats = 500, rewards = {12236, 1}, expReward = 0, nextTask = "Pidgeot"},
	["Pidgeot"] = {taskStorage = storages.base + 157, defeatsStorage = storages.base + 158, defeats = 2000, rewards = {12232, 1}, expReward = 0, nextTask = "Blastoise"},
	["Blastoise"] = {taskStorage = storages.base + 159, defeatsStorage = storages.base + 160, defeats = 2000, rewards = {12230, 1}, expReward = 0, nextTask = "Magmar"},
	["Magmar"] = {taskStorage = storages.base + 161, defeatsStorage = storages.base + 162, defeats = 500, rewards = {12229, 1}, expReward = 0, nextTask = "Primeape"},
	["Primeape"] = {taskStorage = storages.base + 163, defeatsStorage = storages.base + 164, defeats = 1500, rewards = {12243, 1}, expReward = 0, nextTask = "Gengar"},
	["Gengar"] = {taskStorage = storages.base + 165, defeatsStorage = storages.base + 166, defeats = 2000, rewards = {12242, 1}, expReward = 0, nextTask = "Alakazam"},
	["Alakazam"] = {taskStorage = storages.base + 167, defeatsStorage = storages.base + 168, defeats = 2000, rewards = {12233, 1}, expReward = 0, nextTask = "Gyarados"},
	["Gyarados"] = {taskStorage = storages.base + 169, defeatsStorage = storages.base + 170, defeats = 2000, rewards = {12240, 1}, expReward = 0, nextTask = nil},
}

local function getTaskStatus(cid, task)
	return getCreatureStorage(cid, TASKS[task].taskStorage)
end

local function getDefeats(cid, task)
	local defeats = getCreatureStorage(cid, TASKS[task].defeatsStorage)

	if (defeats < 0) then
		defeats = 0
	end

	return defeats
end

local function increaseDefeats(cid, task)
	local defeats = getDefeats(cid, task)
	doCreatureSetStorage(cid, TASKS[task].defeatsStorage, defeats + 1)
	doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, string.format(__L(cid, "Task: %s - step complete [%s/%s]."), task, defeats + 1, TASKS[task].defeats))
end

local function startTask(cid, task)
	doCreatureSetStorage(cid, TASKS[task].taskStorage, storages.status.started)
	doCreatureSetStorage(cid, TASKS[task].defeatsStorage, 0)
end

local function endTask(cid, task)
	local rewardMessage = __L(cid, "Your reward:\n")
	if (TASKS[task].expReward > 0) then
		doPlayerAddExperience(cid, TASKS[task].expReward)
		rewardMessage = rewardMessage .. TASKS[task].expReward .. __L(cid, " experience points\n")
	end
	for i = 1, #TASKS[task].rewards, 2 do
		doPlayerAddItem(cid, TASKS[task].rewards[i], TASKS[task].rewards[i + 1], true)
		rewardMessage = rewardMessage .. getItemNameById(TASKS[task].rewards[i]) .. "[" .. TASKS[task].rewards[i + 1] .. "x]\n"
	end
	doCreatureSetStorage(cid, TASKS[task].taskStorage, storages.status.finished)
	doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, string.format(__L(cid, "Congratulations! You finished the %s task and received your reward."), task))
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, rewardMessage)
    doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.COMPLETE_TASK, 1)
	-- Start next task
	--[[if(TASKS[task].nextTask ~= nil) then
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, "You received a new task! Check your quest log for more information.")
		startTask(cid, TASKS[task].nextTask)
	end]]
end

function doTaskDefeat(cid, task)
	if(TASKS[task] and getTaskStatus(cid, task) == storages.status.started) then
		local defeats = getDefeats(cid, task)
		if(defeats + 1 >= TASKS[task].defeats) then
			endTask(cid, task)
		else
			increaseDefeats(cid, task)
		end
	end
end
