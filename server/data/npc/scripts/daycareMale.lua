local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local lastName = {}
local lastTrainTime = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

local TALK_STATES = {
	NONE = 0,
	QUESTION_LEAVE_POKEMON_NAME = 1,
	QUESTION_LEAVE_POKEMON = 2,
	QUESTION_WITHDRAW_POKEMON = 3,
	QUESTION_WITHDRAW_POKEMON_WITHOUT_TRAINING = 4,
	QUESTION_LEAVE_POKEMON_TIME = 5
}


local TRAIN_TIME_OPTIONS = {1440, 2880}
local MAX_TRAIN_TIME = TRAIN_TIME_OPTIONS[#TRAIN_TIME_OPTIONS]--2880 -- 2 days

local function getPokemonGainExpPerMinute(pokemonLevel)
	if (pokemonLevel >= 100) then
		return 0
	elseif (pokemonLevel > 75) then
		return 210
	elseif (pokemonLevel > 50) then
		return 140
	end
	return 70
end

local function getPricePerMinute(pokemonLevel)
	if (pokemonLevel > 75) then
		return 4
	elseif (pokemonLevel > 50) then
		return 2
	end
    return 1
end

local function getPlayerPokemonOnDaycareByGUID(guid)
	local dbResult = db.getResult("SELECT * FROM `daycare_male` WHERE `player_id` = '".. guid ..
            " LIMIT 1';")
	if dbResult:getID() == -1 then
		return false
	end
	return dbResult
end

local function getPlayerPokemonOnDaycare(cid)
	return getPlayerPokemonOnDaycareByGUID(getPlayerGUID(cid))
end

local function getPlayerPokemonOnDaycareTrainedMinutes(cid, data)
	if (not data) then
		data = getPlayerPokemonOnDaycare(cid)
	end
	local trainedMinutes = math.floor((os.time() - data:getDataInt('date')) / 60)
	local maxTrainTime = data:getDataInt('max_training_minutes')
	if (trainedMinutes > maxTrainTime) then
		trainedMinutes = maxTrainTime
	end
	return trainedMinutes
end

local function doPlayerLeavePokemonOnDaycare(cid, ball, trainTime)
	--[[
    local query = "INSERT INTO daycare_male (player_id, date, pokemon_name, pokemon_level, pokemon_experience, pokemon_energy, pokemon_maxenergy, pokemon_nickname, pokemon_sex, pokemon_extrapoints, ball_id, max_training_minutes, pokemon_specialability, pokemon_tm1, pokemon_tm1_slot, pokemon_tm2, pokemon_tm2_slot, ball_seal) VALUES ("

	query = query .. getPlayerGUID(cid) .. ", "
	query = query .. os.time() .. ", "
	query = query .. "'" .. getBallPokemonName(ball.uid) .. "', "
	query = query .. getBallPokemonLevel(ball.uid) .. ", "
	query = query .. getBallPokemonExp(ball.uid) .. ", "
	query = query .. getBallPokemonEnergy(ball.uid) .. ", "
	query = query .. getBallPokemonMaxEnergy(ball.uid) .. ", "

	if (getBallPokemonNickname(ball.uid)) then
		query = query .. "'" .. getBallPokemonNickname(ball.uid) .. "', "
	else
		query = query .. "'', "
	end

	query = query .. getBallPokemonSex(ball.uid) .. ", "
	query = query .. getBallPokemonExtraPoints(ball.uid) .. ", "
	query = query .. ball.itemid .. ", "
	query = query .. trainTime .. ", "
    query = query .. getBallPokemonSpecialAbility(ball.uid) .. ", "
    query = query .. getBallTm(ball.uid, 1) .. ", "
    query = query .. getBallTmSlot(ball.uid, 1) .. ", "
    query = query .. getBallTm(ball.uid, 2) .. ", "
    query = query .. getBallTmSlot(ball.uid, 2) .. ", "
    query = query .. getBallSeal(ball.uid) .. ");"

	if (db.executeQuery(query)) then
		doRemoveItem(ball.uid)
		doPlayerSave(cid) -- let's save to prevent clone balls

		return true
	end

	return false
	]]
    local query = string.concat(
        "INSERT INTO daycare_male (player_id, date, ball_id, max_training_minutes, pokemon_name, pokemon_level, attributes) VALUES (",
         getPlayerGUID(cid), ",",
         os.time(), ",",
         ball.itemid, ",",
         trainTime, ",",
         "'", getBallPokemonName(ball.uid), "',",
         "'", getBallPokemonLevel(ball.uid), "',",
         getItemAttributesBlob(ball.uid), ");"
    )

	if (db.executeQuery(query)) then
		doRemoveItem(ball.uid)
		doPlayerSave(cid) -- let's save to prevent clone balls
		return true
    else
        log(LOG_TYPES.ERROR, "daycareMale:doPlayerLeavePokemonOnDaycare - Can't query.", query)
	end

	return false
end

local function doPlayerWithdrawPokemonFromDaycare(cid, data, cancelTraining)
	--[[
    if (not data) then
		data = getPlayerPokemonOnDaycare(cid)
	end

	local minTrained = getPlayerPokemonOnDaycareTrainedMinutes(cid, data)
	local pokemonName = data:getDataString('pokemon_name')
	local pokemonLevel = data:getDataInt('pokemon_level')
	local pokemonExp = data:getDataInt('pokemon_experience')
	local pokemonEnergy = data:getDataInt('pokemon_energy')
	local pokemonMaxEnergy = data:getDataInt('pokemon_maxenergy')
	local pokemonNickname = data:getDataString('pokemon_nickname')
	local pokemonSex = data:getDataInt('pokemon_sex')
	local pokemonExtraPoints = data:getDataInt('pokemon_extrapoints')
    local pokemonSpecialAbility = data:getDataInt('pokemon_specialability')
    local tm1 = data:getDataInt('pokemon_tm1')
    local tm1Slot = data:getDataInt('pokemon_tm1_slot')
    local tm2 = data:getDataInt('pokemon_tm2')
    local tm2Slot = data:getDataInt('pokemon_tm2_slot')
    local ballSeal = data:getDataInt('ball_seal')
	local ballId = data:getDataInt('ball_id')
	local gainExtraPoints = pokemonLevel

	if (pokemonNickname == '') then
		pokemonNickname = nil
	end

	if (not cancelTraining) then
		pokemonExp = pokemonExp + (getPokemonGainExpPerMinute(pokemonLevel) * minTrained)
		if (pokemonExp > getExperienceForLevel(100)) then
			pokemonExp = getExperienceForLevel(100)
		end

		pokemonLevel = getLevelByExp(pokemonExp)
	end
	gainExtraPoints = math.floor((pokemonLevel - gainExtraPoints) / 2) -- 50% of gain level

	if (db.executeQuery("DELETE FROM daycare_male WHERE player_id='" .. data:getDataInt('player_id') .. "'") and
		doCreatePokemonBall(cid, ballId, pokemonName, pokemonLevel, pokemonSex, pokemonNickname,
            pokemonExtraPoints + gainExtraPoints, nil, nil, 999999, pokemonExp, pokemonSpecialAbility,
            tm1, tm1Slot, tm2, tm2Slot, ballSeal)) then
		doPlayerSave(cid) -- let's save to prevent clone balls
		return true
	end

	return false
	]]
    if (not data) then
		data = getPlayerPokemonOnDaycare(cid)
    end

    local beforeDepotFunction = function(ball) -- This need to be executed before the item goes to depot, because the item can't be modified after it goes to depot
        local minTrained = getPlayerPokemonOnDaycareTrainedMinutes(cid, data)
        local pokemonLevel = getBallPokemonLevel(ball)
        local pokemonExp = getBallPokemonExp(ball)
        local gainExtraPoints = pokemonLevel

        if (not cancelTraining) then
            pokemonExp = pokemonExp + (getPokemonGainExpPerMinute(pokemonLevel) * minTrained)
            if (pokemonExp > getExperienceForLevel(POKEMON_LEVEL_MAX)) then
                pokemonExp = getExperienceForLevel(POKEMON_LEVEL_MAX)
            end

            pokemonLevel = getLevelByExp(pokemonExp)
        end
        gainExtraPoints = math.floor((pokemonLevel - gainExtraPoints) / 2) -- 50% of gain level

        setBallPokemonExp(ball, pokemonExp)
        setBallPokemonLevel(ball, pokemonLevel)
        setBallPokemonExtraPoints(ball, getBallPokemonExtraPoints(ball) + gainExtraPoints)
        doBallUpdateDescription(ball)
    end

    local ball
    if (data:getDataInt('pokemon_maxenergy') > 0) then -- Fix to older trains
        ball = doCreatePokemonBall(cid, data:getDataInt('ball_id'), data:getDataString('pokemon_name'),
            data:getDataInt('pokemon_level'), data:getDataInt('pokemon_sex'),
            data:getDataString('pokemon_nickname'), data:getDataInt('pokemon_extrapoints'), nil, nil, 999999,
            data:getDataInt('pokemon_experience'), data:getDataInt('pokemon_specialability'),
            data:getDataInt('pokemon_tm1'), data:getDataInt('pokemon_tm1_slot'),
            data:getDataInt('pokemon_tm2'), data:getDataInt('pokemon_tm2_slot'), data:getDataInt('ball_seal'),
            nil, nil, beforeDepotFunction)
    else
        ball = doCreatePokemonBall(cid, data:getDataInt('ball_id'), nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil, true, {column = 'attributes', result = data:getID()},
            beforeDepotFunction)
    end

    if (not ball) then
        log(LOG_TYPES.ERROR, "daycareMale:doPlayerWithdrawPokemonFromDaycare - Can't create ball.",
            getCreatureName(cid), data)
        return false
    end

	local query = string.concat("DELETE FROM daycare_male WHERE player_id='", data:getDataInt('player_id'),
        "'")
    if (db.executeQuery(query)) then
		doPlayerSave(cid) -- let's save to prevent clone balls
		return true
    else
        log(LOG_TYPES.ERROR, "daycareMale:doPlayerWithdrawPokemonFromDaycare - Can't query.", query)
        doRemoveItem(ball)
	end

	return false
end

local function hasSameAccountCharacterUsingDaycare(cid)
	local accountPlayers = getAllPlayersByAccountId(getPlayerAccountId(cid))
	for i, player in ipairs(accountPlayers) do
		if (getPlayerPokemonOnDaycareByGUID(player)) then
			return true
		end
	end
	return false
end

local function getTrainOptionsMessage()
	local message = ""
	for i, option in ipairs(TRAIN_TIME_OPTIONS) do
		if (i ~= #TRAIN_TIME_OPTIONS) then
			message = message .. "{" .. option .. "} minutes, "
		else
			message = message .. "or {" .. option .. "} minutes."
		end
	end
	return message
end
local trainOptionsMessage = getTrainOptionsMessage()
getTrainOptionsMessage = nil

--

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	msg = string.lower(msg)

	if (msgcontains(msg, 'daycare')) then
		selfSay("In this place you can {leave} your Pokemon in our care, we will train him for you.", cid)

	elseif (msgcontains(msg, 'pokemon')) then
		if (getPlayerPokemonOnDaycare(cid)) then
			selfSay("You have a Pokemon being trained by me at this moment! You can see his {status} or {withdraw} it.", cid)

		else
			selfSay("You have no Pokemon being trained by me at this moment! You can {leave} a Pokemon here if you want.", cid)
		end

	elseif (msgcontains(msg, 'status')) then
		local pokemonOnDaycare = getPlayerPokemonOnDaycare(cid)

		if (not pokemonOnDaycare) then
			selfSay("You have no Pokemon being trained by me at this moment! You can {leave} a Pokemon here if you want.", cid)

		else
			local min = getPlayerPokemonOnDaycareTrainedMinutes(cid, pokemonOnDaycare)
			local pokemonLevel = pokemonOnDaycare:getDataInt('pokemon_level')

			selfSay(string.format(__L(cid, "Your {%s} is being trained for {%s minutes} and has earned {%s experience points}. The price to remove your Pokemon is {%s dollars}. You can also {cancel} the training."), pokemonOnDaycare:getDataString('pokemon_name'), min, getPokemonGainExpPerMinute(pokemonLevel) * min, getPricePerMinute(pokemonLevel) * min), cid)
		end

	elseif (msgcontains(msg, 'withdraw') or msgcontains(msg, 'sacar')) then
		local pokemonOnDaycare = getPlayerPokemonOnDaycare(cid)

		if (not pokemonOnDaycare) then
			selfSay("You have no Pokemon being trained by me at this moment! You can {leave} a Pokemon here if you want.", cid)

		else
			talkState[talkUser] = TALK_STATES.QUESTION_WITHDRAW_POKEMON

			selfSay("Do you want to remove your Pokemon from the daycare?", cid)
		end

	elseif (msgcontains(msg, 'leave') or msgcontains(msg, 'deixar')) then
		local pokemonOnDaycare = getPlayerPokemonOnDaycare(cid)

		if (pokemonOnDaycare) then
			selfSay("You have a Pokemon being trained by me at this moment! You can {withdraw} it if you want.", cid)

		else
			if (getPlayerLevel(cid) < 85) then
				selfSay("Sorry, only players with at least level 85 can use this service.", cid)

			elseif (not isPremium(cid)) then
				selfSay("Sorry, only players with a premium account can use this service.", cid)

			elseif (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
				selfSay("You can not do it while you have a Pokemon out of the ball.", cid)

			elseif (hasSameAccountCharacterUsingDaycare(cid)) then
				selfSay("Sorry, a character of your account is already using our services.", cid)

			else
				talkState[talkUser] = TALK_STATES.QUESTION_LEAVE_POKEMON_NAME

				selfSay("So what's the name of your Pokemon that you want to leave here?", cid)
			end
		end

	elseif (msgcontains(msg, 'cancel') or msgcontains(msg, 'cancelar')) then
		local pokemonOnDaycare = getPlayerPokemonOnDaycare(cid)

		if (pokemonOnDaycare) then
			talkState[talkUser] = TALK_STATES.QUESTION_WITHDRAW_POKEMON_WITHOUT_TRAINING

			selfSay("Do you really want to cancel your Pokemon training? He will not gain any experience points and generate eggs, but you still have to pay the amount.", cid)

		else
			selfSay("You have no Pokemon being trained by me at this moment! You can {leave} a Pokemon here if you want.", cid)
		end

	elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
		if (talkState[talkUser] == TALK_STATES.QUESTION_LEAVE_POKEMON and lastName[talkUser] and lastTrainTime[talkUser]) then
			if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
				selfSay("You can not do it while you have a Pokemon out of the ball.", cid)

			else
				local daycareBall

				for i, ball in ipairs(getPlayerAllBallsWithPokemon(cid)) do
					if (getBallPokemonName(ball.uid) == lastName[talkUser]) then
						daycareBall = ball
						break
					end
				end

				if (not daycareBall) then
					talkState[talkUser] = TALK_STATES.QUESTION_LEAVE_POKEMON_NAME

					selfSay("You do not have this Pokemon! Please tell the name of a Pokemon that is with you.", cid)

				elseif (getPlayerMoney(cid) < 100) then
					talkState[talkUser] = TALK_STATES.NONE

					selfSay("You do not have enough money for this.", cid)

				elseif (getBallPokemonSex(daycareBall.uid) == POKEMON_SEX_FEMALE) then
					talkState[talkUser] = TALK_STATES.NONE

                    selfSay("Sorry, I care only male and sexless Pokemon.", cid)

				else
					talkState[talkUser] = TALK_STATES.NONE

					doPlayerRemoveMoney(cid, 100)
					doPlayerLeavePokemonOnDaycare(cid, daycareBall, lastTrainTime[talkUser])
					selfSay("Thank you for using our services, your Pokemon will be fine here.", cid)
				end
			end

		elseif (talkState[talkUser] == TALK_STATES.QUESTION_WITHDRAW_POKEMON) then
			local pokemonOnDaycare = getPlayerPokemonOnDaycare(cid)

			local remaingTrainTime = (pokemonOnDaycare:getDataInt('max_training_minutes')) - (math.floor((os.time() - pokemonOnDaycare:getDataInt('date')) / 60))
			if (remaingTrainTime > 0) then
				selfSay(string.format(__L(cid, "You can't withdraw your Pokemon right now. There's remaing %s minutes of training. If you really want, you can {cancel} the trainment."), remaingTrainTime), cid)
				talkState[talkUser] = TALK_STATES.NONE
				return true
			end

			local priceToWithdraw = getPricePerMinute(pokemonOnDaycare:getDataInt('pokemon_level')) * getPlayerPokemonOnDaycareTrainedMinutes(cid, pokemonOnDaycare) -- price per minutes * minutes
			if (getPlayerMoney(cid) < priceToWithdraw) then
				selfSay(string.format(__L(cid, "You do not have enough money for this. You need %s dollars."), priceToWithdraw), cid)

			else
				doPlayerWithdrawPokemonFromDaycare(cid, pokemonOnDaycare)
				doPlayerRemoveMoney(cid, priceToWithdraw)
				selfSay("Done. Thank you for using our services!", cid)
			end

			talkState[talkUser] = TALK_STATES.NONE

		elseif (talkState[talkUser] == TALK_STATES.QUESTION_WITHDRAW_POKEMON_WITHOUT_TRAINING) then
			local pokemonOnDaycare = getPlayerPokemonOnDaycare(cid)
			local priceToWithdraw = getPricePerMinute(pokemonOnDaycare:getDataInt('pokemon_level')) * getPlayerPokemonOnDaycareTrainedMinutes(cid, pokemonOnDaycare) -- price per minutes * minutes

			if (getPlayerMoney(cid) < priceToWithdraw) then
				selfSay(string.format(__L(cid, "You do not have enough money for this. You need %s dollars."), priceToWithdraw), cid)

			else
				doPlayerWithdrawPokemonFromDaycare(cid, pokemonOnDaycare, true)
				doPlayerRemoveMoney(cid, priceToWithdraw)
				selfSay("Done. Thank you for using our services!", cid)
			end

			talkState[talkUser] = TALK_STATES.NONE
		end

	else
		if (talkState[talkUser] == TALK_STATES.QUESTION_LEAVE_POKEMON_NAME) then
			if (not isPokemonName(msg)) then
				selfSay("Please, say the name of a Pokemon! What the name of your Pokemon that you want to leave here?", cid)

			else
				local trueName, i, word

				for i, word in ipairs(string.explode(msg, " ")) do
					if (i == 1) then
						trueName = word:gsub("^%l", string.upper)

					else
						trueName = trueName .. " " ..  word:gsub("^%l", string.upper)
					end
				end

				lastName[talkUser] = trueName
				talkState[talkUser] = TALK_STATES.QUESTION_LEAVE_POKEMON_TIME

				selfSay(string.format(__L(cid, "And how much train time do you want? The options are: %s"), trainOptionsMessage), cid)
			end

		elseif (talkState[talkUser] == TALK_STATES.QUESTION_LEAVE_POKEMON_TIME) then
			msg = tonumber(msg)
			if (not isInArray(TRAIN_TIME_OPTIONS, msg)) then
				selfSay(string.format(__L(cid, "Your options are: %s"), trainOptionsMessage), cid)

			else
				talkState[talkUser] = TALK_STATES.QUESTION_LEAVE_POKEMON
				lastTrainTime[talkUser] = msg

				selfSay(string.format(__L(cid, "Do you want to leave your %s here for %s minutes? This will cost 100 dollars to enter and an additional 1, 2 or 4 dollars per minute that he stay here (depends on the level of your Pokemon)."), lastName[talkUser], msg), cid)
			end

		else
			talkState[talkUser] = TALK_STATES.NONE

			selfSay("Ok...", cid)
		end
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
