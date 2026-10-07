local BALLS = {}

for k, v in pairs(balls) do
    if (v.useCounter) then
        BALLS[#BALLS + 1] = k
    end
end

local function getPlayerWastedBallsByBallName(cid, pokemonNumber, ballName)
    if (not isPlayer(cid)) then
        return 0
    end

    local ret, res = 0, db.getResult("SELECT `".. ballName .."` FROM `ball_counter` WHERE `player_id`="..
            getPlayerGUID(cid) .." AND `pokemon_id`=".. pokemonNumber .." LIMIT 1;")
    if (res:getID() ~= -1) then
		ret = res:getDataInt(ballName)
        res:free()
    end
	return ret
end

local function getPlayerWastedBalls(cid, pokemonNumber, ballItemid)
    return getPlayerWastedBallsByBallName(cid, pokemonNumber, ballsNames[ballItemid])
end

function doPlayerIncreaseWastedBalls(cid, pokemonNumber, ballItemid)
    local ballName = ballsNames[ballItemid]
    if (not table.find(BALLS, ballName)) then
        ballName = "poke"
    end

    local query = {}
    query[1] = "INSERT INTO `ball_counter` (`player_id`, `pokemon_id`, `"
    query[2] = ballName
    query[3] = "`) VALUES ("
    query[4] = getPlayerGUID(cid)
    query[5] = ","
    query[6] = pokemonNumber
    query[7] = ",1) ON DUPLICATE KEY UPDATE `"
    query[8] = ballName
    query[9] = "`=`"
    query[10] = ballName
    query[11] = "` + 1"
    query[12] = ";"

	if (not db.executeQuery(table.concat(query))) then
		log(LOG_TYPES.ERROR, "setPlayerWastedBalls - Couldn't execute query", table.concat(query))
	end
end

function doPlayerResetWastedBalls(cid, pokemonNumber)
    local query = {}
    query[1] = "DELETE FROM `ball_counter` WHERE `player_id`="
    query[2] = getPlayerGUID(cid)
    query[3] = " AND `pokemon_id`="
    query[4] = pokemonNumber
    query[5] = ";"

    if (not db.executeQuery(table.concat(query))) then
        log(LOG_TYPES.ERROR, "doPlayerResetWastedBalls - Couldn't execute query", table.concat(query))
    end
end

function getPlayerWastedBallsMessage(cid, pokemonNumber)
    local counts = {}
    for k, v in ipairs(BALLS) do
        local count = getPlayerWastedBallsByBallName(cid, pokemonNumber, v)
        if (count > 0) then
            counts[#counts + 1] = {v, count}
        end
    end

    local msg = {}
    msg[1] = __L(cid, "You've wasted ")

    for i = 1, #counts do
        msg[#msg + 1] = counts[i][2]
        msg[#msg + 1] = " "
        msg[#msg + 1] = counts[i][1]
        msg[#msg + 1] = (counts[i][2] > 1 and " balls" or " ball")

        if (i < #counts) then
            if (i + 1 < #counts) then
                msg[#msg + 1] = ", "
            else
                msg[#msg + 1] = __L(cid, " and ")
            end
        end
    end

    if (#msg == 1) then
        msg[2] = __L(cid, "nothing")
    end

    msg[#msg + 1] = ""

    return table.concat(msg)
end

function getPlayerCatchTries(cid, pokemonNumber)
    local tries = 0
    for _, ballName in ipairs(BALLS) do
        tries = tries + (getBallCatchRate(ballName) * getPlayerWastedBallsByBallName(cid, pokemonNumber, ballName))
    end
    return tries
end