local RATE_CATCH = getConfigValue('rateCatch')
if (not RATE_CATCH) then
    log(LOG_TYPES.ERROR, "config value 'rateCatch' can't be found!")
    RATE_CATCH = 1.0
end

local ADVANCED_SAVE = getBooleanFromString(getConfigValue('advancedSave'))

local function onCaughtPokemon(cid, attributes, tries)
    if (not tries) then
        tries = getPlayerCatchTries(cid, getPokemonNumberByName(attributes.name))
    end

    if (string.find(string.lower(attributes.name), "shiny")) then
        updatePokedexItemStatus(cid, attributes.name, POKEDEXSTATUS_SHINYCATCHED)
        doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.CATCH_SHINY_POKEMON, 1)
    else
        updatePokedexItemStatus(cid, attributes.name, POKEDEXSTATUS_CATCHED)

        if (getPokemonGenerationByName(attributes.name) == 1) then
            doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.CATCH_POKEMON_1ST_GEN, 1)
        elseif (getPokemonGenerationByName(attributes.name) == 2) then
            doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.CATCH_POKEMON_2ND_GEN, 1)
        end
    end

    local caughts = getPlayerCaughts(cid) + 1
    setPlayerCaughts(cid, caughts)
    setPlayerPokemonCaughts(cid, attributes.name, getPlayerPokemonCaughts(cid, attributes.name) + 1)
    doQuestCatch(cid, attributes.name)
    doPokedexTryRegister(cid, attributes.name)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.CATCH_1, caughts)

    local exp = getMonsterInfo(attributes.name).experience * attributes.level * 2
    doPlayerAddExperience(cid, exp)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You earned %s experience points by catching %s!"), exp, attributes.name))

    if (not doDatalogCaught(cid, getPokemonNumberByName(attributes.name), tries)) then
        log(LOG_TYPES.ERROR, "Can't datalog caught.", getCreatureName(cid), attributes.name)
    end

    if (ADVANCED_SAVE) then
        doPlayerSave(cid, true)
    end

    if (string.find(string.lower(attributes.name), "easter")) then
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.EASTER_CAUGHT)
        print("EASTER CAUGHT: " .. attributes.name .. " by " .. getCreatureName(cid))
    end
end

function getCatchChance(cid, pokemonName, ballId, pokemonLevel)
    local catchChance = getPokemonCatchChance(pokemonName) / (RATE_CATCH + getPlayerExtraCatchRateValue(cid))
    if (getPokemonIgnoreBallCounter(pokemonName)) then
        return getRandom(1, catchChance)
    end

    local triesFactor = getPlayerCatchTries(cid, getPokemonNumberByName(pokemonName)) / catchChance
    if (triesFactor <= 0.25) then -- Never catch with equal or less 25% of tries
        return 1000 -- Higher enough to any ball
    end

    local skill = getPlayerSkillLevel(cid, PLAYER_SKILL_CATCHING)
    if (skill > PLAYER_SKILL_CATCHING_MAX) then
        skill = PLAYER_SKILL_CATCHING_MAX
    end

	local chanceMax = math.ceil((catchChance - skill / 10) -
            (triesFactor > 1.0 and ((triesFactor - 1.0) * catchChance) or 0)) -- After 100% tries, each new % will be discounted to favor the catch, Ex: 100 tries to caught Bulbasaur, on 150 tries the player will receive 50% of favor
	if (chanceMax < 5) then
        chanceMax = ((catchChance < 5 and catchChance > 0) and catchChance or 5)
    end
	return getRandom(1, chanceMax)
end

function catchMiss(cid, ballName, ballItemid, pokemon, wastedBallsMsg)
	if (not isPlayer(cid)) then
        return
    end

    if (getPlayerSkillLevel(cid, PLAYER_SKILL_CATCHING) < PLAYER_SKILL_CATCHING_MAX) then
		doPlayerAddSkillTry(cid, PLAYER_SKILL_CATCHING, math.ceil(50 / (getPlayerSkillLevel(cid, PLAYER_SKILL_CATCHING) + 1)))
	end

	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Ouch! Your %s ball broke."), ballName))
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_THREE_POINTS)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, wastedBallsMsg)

    if (balls[ballName].returnOnBroke) then
        doPlayerSafeAddItem(cid, ballItemid, 1, false, true)
    end

end

local function catchPokemon(cid, position, pokemonName, newBall, pokemonSex, pokemonLevel,
pokemonSpecialAbilitie, wastedBallsMsg, tries)
	if (not isPlayer(cid)) then
        return
    end

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Gotcha! You caught a %s %s (level %s)."), getSexDescription(pokemonSex), pokemonName, pokemonLevel))
    doCreatePokemonBall(cid, newBall, pokemonName, pokemonLevel, pokemonSex, nil, 0, nil, getSafariZone(cid), nil,
        nil, pokemonSpecialAbilitie, nil, nil, nil, nil, nil, getPlayerTown(cid) ~= TOWN_IDS.TUTORIAL_ISLAND)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_EXCLAMATION)

	if (getPlayerSkillLevel(cid, PLAYER_SKILL_CATCHING) < PLAYER_SKILL_CATCHING_MAX) then
		doPlayerAddSkillTry(cid, PLAYER_SKILL_CATCHING, math.ceil(PLAYER_SKILL_CATCHING_MAX / (getPlayerSkillLevel(cid, PLAYER_SKILL_CATCHING) + 1)))
    end

    onCaughtPokemon(cid, {name = pokemonName, level = pokemonLevel}, tries)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, wastedBallsMsg)
end

function catchPokemonWithSafariBall(cid, position, pokemonName, newBall, pokemonSex, pokemonLevel,
pokemonSpecialAbilitie, wastedBallsMsg, tries)
	if (not isPlayer(cid)) then
        return
    end

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Gotcha! You caught a %s %s (level %s)."), getSexDescription(pokemonSex), pokemonName, pokemonLevel))
    doCreatePokemonBall(cid, "safari", pokemonName, pokemonLevel, pokemonSex, nil, 0, nil, true, nil, nil, pokemonSpecialAbilitie)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_EXCLAMATION)
	if (getPlayerSkillLevel(cid, PLAYER_SKILL_CATCHING) < PLAYER_SKILL_CATCHING_MAX) then
		doPlayerAddSkillTry(cid, PLAYER_SKILL_CATCHING, math.ceil(PLAYER_SKILL_CATCHING_MAX / (getPlayerSkillLevel(cid, PLAYER_SKILL_CATCHING) + 1)))
    end

    onCaughtPokemon(cid, {name = pokemonName, level = pokemonLevel}, tries)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, wastedBallsMsg)
end

local function catchPokemonWithSoulBall(cid, position, pokemonName, newBall, pokemonSex,
pokemonSpecialAbilitie, wastedBallsMsg)
	if (not isPlayer(cid)) then
        return
    end

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Gotcha! You caught a %s %s."), getSexDescription(pokemonSex), pokemonName))
    doCreatePokemonBall(cid, "soul", pokemonName, 8, pokemonSex, nil, 0, cid, false, nil, nil, pokemonSpecialAbilitie)
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Now you need to talk with Professor Tommy to start your journey, speak about 'journey'.")
	doTeleportThing(cid, {x = 4711, y = 678, z = 7}, false)
	doPlayerRemoveItem(cid, 13497, getPlayerItemCount(cid, 13497)) -- Removing special small stones
	doPlayerAddItem(cid, 13820, 100, false) -- Start cookies
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_EXCLAMATION)
	doPlayerAddSkillTry(cid, PLAYER_SKILL_CATCHING, math.ceil(PLAYER_SKILL_CATCHING_MAX / (getPlayerSkillLevel(cid, PLAYER_SKILL_CATCHING) + 1)))

	local playerLevel = getPlayerLevel(cid)
	if (playerLevel < 8) then
		doPlayerAddLevel(cid, 8 - playerLevel, false)
    end

    onCaughtPokemon(cid, {name = pokemonName, level = 8}, 1)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, wastedBallsMsg)
end

local function dropCorpseItems(corpse)
    local items = getContainerItems(corpse.uid)
    local pos = getThingPosition(corpse.uid)
    for _, item in ipairs(items) do
        doMoveItem(item.uid, pos)
    end
end

function emptyBall(cid, item, fromPosition, itemEx, toPosition)
	if (getSafariZone(cid) and ballsNames[item.itemid] ~= "safari") then
		doPlayerSendCancel(cid, "You can not use poke balls while you're in Safari Zone.")
        return
    end

    local ballName = ballsNames[item.itemid]
    if (ballName == "safari") then
        onCreatureUseSafariBall(cid, item, fromPosition, itemEx, toPosition)
        return true
    end

    local corpse = getTileItemByType(toPosition, ITEM_TYPE_CONTAINER)
	if (not isItem(corpse) or not isCorpse(corpse.uid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

	else
		local playerPosition = getCreaturePosition(cid)
		if (getItemAttribute(corpse.uid, "corpseowner") and
                getItemAttribute(corpse.uid, "corpseowner") ~= getPlayerGUID(cid)) then
			doPlayerSendCancel(cid, "You didn't defeated this Pokemon.")

		else
			local pokemonName = getItemAttribute(corpse.uid, "pokemon")
			if (pokemonName and isPokemonName(pokemonName)) then
                if (balls[ballName].allowedElements and
                        not table.findAsTable(balls[ballName].allowedElements, getPokemonTypes(nil, pokemonName))) then
                    doPlayerSendCancel(cid, "You cannot catch this type of Pokemon with this type of ball.")
                    return true

                elseif (getPokemonAllowedBall(pokemonName) and ballName ~= getPokemonAllowedBall(pokemonName)) then
                    doPlayerSendCancel(cid, "You cannot catch this Pokemon with this type of ball.")
                    return true
                end

                doPlayerIncreaseWastedBalls(cid, getPokemonNumberByName(pokemonName), item.itemid)

				local pokemonSex = getItemAttribute(corpse.uid, "sex")
                local pokemonSpecialAbility = getItemAttribute(corpse.uid, "specialAbility")
                if (not table.find(getPokemonSpecialAbilities(pokemonName), pokemonSpecialAbility)) then
                    pokemonSpecialAbility = getPokemonRandomSpecialAbility(pokemonName)
                end

                if (ballName == "soul") then
                    dropCorpseItems(corpse)
					doRemoveItem(corpse.uid)
					doRemoveItem(item.uid, 1)
					doSendDistanceShoot(playerPosition, toPosition, balls[ballName].projectile)
					doCreatureSay(cid, __L(cid, "Soul ball, go!"), TALKTYPE_SAY)
					catchPokemonWithSoulBall(cid, toPosition, pokemonName, balls[ballName].charged,
                        pokemonSex, pokemonSpecialAbility, getPlayerWastedBallsMessage(cid, getPokemonNumberByName(pokemonName)) .. __L(cid, " to catch it."))
                    doPlayerResetWastedBalls(cid, getPokemonNumberByName(pokemonName))

				else
					local pokemonLevel = getItemAttribute(corpse.uid, "level")

                    doRemoveItem(item.uid, 1) -- This need to be before the coprseItemsDrop, otherwise a ball duplication can occurr, if the player put the ball inside the corpse and use it from there
                    dropCorpseItems(corpse)
                    doRemoveItem(corpse.uid)
					doSendDistanceShoot(playerPosition, toPosition, balls[ballName].projectile)
					doCreatureSay(cid, string.format(__L(cid, "%s ball, go!"), ballName:gsub("^%l", string.upper)), TALKTYPE_SAY)

					if (getCatchChance(cid, pokemonName, item.itemid, pokemonLevel) <= getBallCatchRate(ballName)) then
                        doSendMagicEffect(toPosition, balls[ballName].effects.catch)
						addEvent(catchPokemon, 5500, cid, toPosition, pokemonName, balls[ballName].charged,
                            pokemonSex, pokemonLevel, pokemonSpecialAbility,
                            getPlayerWastedBallsMessage(cid, getPokemonNumberByName(pokemonName)) .. __L(cid, " to catch it."), getPlayerCatchTries(cid, getPokemonNumberByName(pokemonName)))
                        doPlayerResetWastedBalls(cid, getPokemonNumberByName(pokemonName))

					else
						doSendMagicEffect(toPosition, balls[ballName].effects.catchMiss)
						addEvent(catchMiss, 4000, cid, ballsNames[item.itemid], item.itemid, pokemonName,
                            string.format(__L(cid, "%s trying to catch %s."), getPlayerWastedBallsMessage(cid, getPokemonNumberByName(pokemonName)), pokemonName))
					end
				end
			else
				doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
			end
		end
	end
end
