local function getTournamentHighscore()
    local dbResult, r = db.getResult("SELECT `players`.`tournament_score`, `players`.`name` FROM `players` WHERE `players`.`world_id` =".. getConfigValue("worldId") .." ORDER BY `players`.`tournament_score` DESC LIMIT ".. getConfigValue("highscoreDisplayPlayers") ..";"), {}
	if dbResult:getID() == -1 then
		return r
    end
    repeat
        table.insert(r, dbResult:getDataString("name"))
        table.insert(r, dbResult:getDataInt("tournament_score"))
    until not dbResult:next()
    dbResult:free()
    return r
end

function doTournamentHighscoreCheck()
    if (type(getConfigValue("updateHighscores")) == "boolean" and not getConfigValue("updateHighscores")) then
        log(LOG_TYPES.WARNING, "doTournamentHighscoreCheck - updateHighscores is off.")
        return
    end

	local highscoreTable = getTournamentHighscore(highscoreId)
	local text, k = "Highscore for Tournament\n\nRank Level - Player Name", 1
	for j = 1, #highscoreTable, 2 do
		text = text .. "\n" ..  k .. ". " .. highscoreTable[j] .. " - " .. highscoreTable[j + 1]
		k = k + 1
	end
	text = text .. "\n\nLast updated on:\n" .. os.date("%a %b %d %X %Y", os.time())
	setGlobalStorageValue(GLOBAL_STORAGES.TOURNAMENT_HIGHSCORE, text)
end

function getTournamentHighscoreText()
    local ret = getGlobalStorageValue(GLOBAL_STORAGES.TOURNAMENT_HIGHSCORE)
    if (ret == -1) then
        return "Empty highscore."
    end
    return ret
end
