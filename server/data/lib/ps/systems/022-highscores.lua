HIGHSCORE_IDS = {}
HIGHSCORE_IDS.FRONTIER_ISLAND = 0
HIGHSCORE_IDS.GLADIATOR = 1
HIGHSCORE_IDS.COOPERATIVE_ELITE = 2
HIGHSCORE_IDS.COOPERATIVE_TITAN = 3
HIGHSCORE_IDS.SURVIVE_CHALLENGE = 4
HIGHSCORE_IDS.BATTLE_TOWER_TWENTY = 5
HIGHSCORE_IDS.BATTLE_TOWER_FIFTEEN = 6
HIGHSCORE_IDS.BATTLE_TOWER_TEN = 7
HIGHSCORE_IDS.SURVIVE_HARDCORE = 8
HIGHSCORE_IDS.ACHIEVEMENTS = 9
HIGHSCORE_IDS.RANGER_CLUB = 10

local HIGHSCORE_NAMES = {}
HIGHSCORE_NAMES[HIGHSCORE_IDS.FRONTIER_ISLAND] = "Frontier Island"
HIGHSCORE_NAMES[HIGHSCORE_IDS.GLADIATOR] = "Gladiator"
HIGHSCORE_NAMES[HIGHSCORE_IDS.COOPERATIVE_ELITE] = "Cooperative Elite"
HIGHSCORE_NAMES[HIGHSCORE_IDS.COOPERATIVE_TITAN] = "Cooperative Titan"
HIGHSCORE_NAMES[HIGHSCORE_IDS.SURVIVE_CHALLENGE] = "Survive Challenge"
HIGHSCORE_NAMES[HIGHSCORE_IDS.BATTLE_TOWER_TWENTY] = "Battle Tower Twenty"
HIGHSCORE_NAMES[HIGHSCORE_IDS.BATTLE_TOWER_FIFTEEN] = "Battle Tower Fifteen"
HIGHSCORE_NAMES[HIGHSCORE_IDS.BATTLE_TOWER_TEN] = "Battle Tower Ten"
HIGHSCORE_NAMES[HIGHSCORE_IDS.ACHIEVEMENTS] = "Achievements"
HIGHSCORE_NAMES[HIGHSCORE_IDS.RANGER_CLUB] = "Ranger Club"

local HIGHSCORE_TEXT_STORAGES = {}
HIGHSCORE_TEXT_STORAGES[HIGHSCORE_IDS.FRONTIER_ISLAND] = 6150
HIGHSCORE_TEXT_STORAGES[HIGHSCORE_IDS.GLADIATOR] = 6151
HIGHSCORE_TEXT_STORAGES[HIGHSCORE_IDS.COOPERATIVE_ELITE] = 6152
HIGHSCORE_TEXT_STORAGES[HIGHSCORE_IDS.COOPERATIVE_TITAN] = 6153
HIGHSCORE_TEXT_STORAGES[HIGHSCORE_IDS.SURVIVE_CHALLENGE] = 6154
HIGHSCORE_TEXT_STORAGES[HIGHSCORE_IDS.BATTLE_TOWER_TWENTY] = 6155
HIGHSCORE_TEXT_STORAGES[HIGHSCORE_IDS.BATTLE_TOWER_FIFTEEN] = 6156
HIGHSCORE_TEXT_STORAGES[HIGHSCORE_IDS.BATTLE_TOWER_TEN] = 6157
HIGHSCORE_TEXT_STORAGES[HIGHSCORE_IDS.ACHIEVEMENTS] = 6158
HIGHSCORE_TEXT_STORAGES[HIGHSCORE_IDS.RANGER_CLUB] = 6159

local function getHighscore(scoreId)
    local dbResult, r = db.getResult("SELECT `PH`.`value`, `P`.`name` FROM `player_highscores` `PH` INNER JOIN `players` `P` ON `P`.`id` = `PH`.`player_id` WHERE `PH`.`score_id` = '".. scoreId .."' AND `P`.`world_id` =".. getConfigValue("worldId") .." ORDER BY `PH`.`value` DESC LIMIT ".. getConfigValue("highscoreDisplayPlayers") ..";"), {}
	if dbResult:getID() == -1 then
		return r
    end
    repeat
        table.insert(r, dbResult:getDataString("name"))
        table.insert(r, dbResult:getDataInt("value"))
    until not dbResult:next()
    dbResult:free()
    return r
end

function doHighscoreTextUpdate()
    if (type(getConfigValue("updateHighscores")) == "boolean" and not getConfigValue("updateHighscores")) then
        log(LOG_TYPES.WARNING, "doHighscoreTextUpdate - updateHighscores is off.")
        return
    end

	local dateNow = os.date("%a %b %d %X %Y", os.time())
    for i, scoreId in pairs(HIGHSCORE_IDS) do
        local highscoreTable, text, k = getHighscore(scoreId), {}, 1
        text[1] = "Highscore for "
        text[2] = HIGHSCORE_NAMES[scoreId]
        text[3] = "\n\nRank Level - Player Name"
        for j = 1, #highscoreTable, 2 do
            text[#text + 1] = "\n"
            text[#text + 1] = k
            text[#text + 1] = ". "
            text[#text + 1] = highscoreTable[j]
            text[#text + 1] = " - "
            text[#text + 1] = highscoreTable[j + 1]
            k = k + 1
        end
        text[#text + 1] = "\n\nLast updated on:\n"
        text[#text + 1] = dateNow
        setGlobalStorageValue(HIGHSCORE_TEXT_STORAGES[scoreId], table.concat(text))
    end
end

function getHighscoreText(scoreId)
    local ret = getGlobalStorageValue(HIGHSCORE_TEXT_STORAGES[scoreId])
    if (ret == -1) then
        return "Empty highscore."
    end
    return ret
end

function doPlayerAddHighscoreValue(cid, scoreId, value)
    local query = {}
    query[1] = "INSERT INTO `player_highscores` (`player_id`, `score_id`, `value`) VALUES ("
    query[2] = getPlayerGUID(cid)
    query[3] = ","
    query[4] = scoreId
    query[5] = ","
    query[6] = value
    query[7] = ") ON DUPLICATE KEY UPDATE `value`=`value` + "
    query[8] = value
    query[9] = ";"

	if (not db.executeQuery(table.concat(query))) then
		log(LOG_TYPES.ERROR, "doPlayerAddHighscoreValue - Couldn't execute query", table.concat(query))
	end
end

function getPlayerHighscoreValue(cid, scoreId)
    local ret, res = 0, db.getResult("SELECT value FROM `player_highscores` WHERE `player_id`="..
            getPlayerGUID(cid) .." AND `score_id`=".. scoreId .." LIMIT 1;")
    if (res:getID() ~= -1) then
        ret = res:getDataInt("value")
        res:free()
    end
    return ret
end
