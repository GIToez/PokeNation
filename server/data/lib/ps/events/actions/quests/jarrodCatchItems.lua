local CATCH_FACTOR_STORAGE = pokemonsStorages.safariCatchFactor
local CATCH_COUNTER_STORAGE = 8337
local CATCHABLE_NPCS = {"Test Elekid", "Test Cleffa", "Test Igglybuff", "Test Magby", "Test Smoochum",
    "Test Togepi"}

local function getPokemonCatchFactor(cid)
    local v = getCreatureStorage(cid, CATCH_FACTOR_STORAGE)
    return v > -1 and v or 0
end

local function setPokemonCatchFactor(cid, value)
    doCreatureSetStorage(cid, CATCH_FACTOR_STORAGE, value)
end

local function getPokemonRequiredCatchFactor(cid)
    --[[ 5 - 20 ]]
    return math.ceil((100 + (getPokemonCatchChance(getCreatureName(cid)) / 2)) / 20)
end

local function getCatchChance(cid, pokemonName, ballId, pokemonLevel)
    local catchChance = getPokemonCatchChance(pokemonName) / 10
	if (catchChance < 5) then
        catchChance = 5
    end
	return getRandom(1, catchChance)
end
--
local function onCatch(cid, pokemonName)
	if (not isPlayer(cid)) then
        return
    end

    local count = doCreatureIncreaseStorage(cid, CATCH_COUNTER_STORAGE)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Gotcha! You caught %s. [%s/10]"), pokemonName, count))
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_EXCLAMATION)

    if (count >= 10) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The experiment is complete! You can leave the room now.")
    end
end

local function onCatchMiss(cid, pokemon)
	if (not isPlayer(cid)) then
        return
    end

	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Your coloured ball broke.")
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_EMOTION_THREE_POINTS)
end

local ITEMS = {}
ITEMS[18297] = function(cid, item, fromPosition, itemEx, toPosition) -- Special Cookie
    if (getCreatureStorage(cid, 8310) ~= QUEST_STATUS.STARTED or not isMonster(itemEx.uid) or
            not canDoCombat(cid, itemEx.uid) or not table.find(CATCHABLE_NPCS, getCreatureName(itemEx.uid))) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return
    end

    local cidPos = getCreaturePosition(cid)
    if (getDistanceBetween(cidPos, toPosition) > 2) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
        return
    end

    doSendDistanceShoot(cidPos, toPosition, PROJECTILE_GRAVEL)
    if (getRandom(0, 100) <= 70) then
        local factor = (getPokemonCatchFactor(itemEx.uid) + 1)
        setPokemonCatchFactor(itemEx.uid, factor)
        if (factor >= getPokemonRequiredCatchFactor(itemEx.uid)) then
            doSendMagicEffect(getCreaturePosition(itemEx.uid), EFFECT_EMOTION_EXCLAMATION)
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You're able to try caught %s now."), getCreatureName(itemEx.uid)))
        else
            doSendMagicEffect(getCreaturePosition(itemEx.uid), EFFECT_LOVE_HEARTS)
        end
    else
        doSendMagicEffect(getCreaturePosition(itemEx.uid), EFFECT_EMOTION_VERY_SAD)
        doMonsterSetTarget(itemEx.uid, cid)
    end
end

ITEMS[18622] = function(cid, item, fromPosition, itemEx, toPosition) -- Coloured Poke Ball
    if (getCreatureStorage(cid, 8310) ~= QUEST_STATUS.STARTED or not isMonster(itemEx.uid) or
            not canDoCombat(cid, itemEx.uid) or not table.find(CATCHABLE_NPCS, getCreatureName(itemEx.uid)) or
            getPokemonCatchFactor(itemEx.uid) < getPokemonRequiredCatchFactor(itemEx.uid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return
    end

    local pokemonName = getCreatureName(itemEx.uid)
    local pokemonLevel = getMonsterLevel(itemEx.uid)

    doRemoveCreature(itemEx.uid)
	doSendDistanceShoot(getCreaturePosition(cid), toPosition, balls["coloured"].projectile)
	doCreatureSay(cid, __L(cid, "Coloured ball, go!"), TALKTYPE_SAY)

	if (getCatchChance(cid, pokemonName, item.itemid, pokemonLevel) <= getBallCatchRate("coloured")) then
		doSendMagicEffect(toPosition, balls["coloured"].effects.catch)
		addEvent(onCatch, 5500, cid, pokemonName)

	else
		doSendMagicEffect(toPosition, balls["coloured"].effects.catchMiss)
	    addEvent(function(cid)
                    onCatchMiss(cid, pokemonName)
                    doSendMagicEffect(toPosition, EFFECT_TELEPORT_UP)
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "%s ran away."), pokemonName))
                end, 4000, cid)
	end
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (ITEMS[item.itemid]) then
        ITEMS[item.itemid](cid, item, fromPosition, itemEx, toPosition)
    else
        log(LOG_TYPES.ERROR, "jarrodCatchItems - Unknown itemid", getCreatureName(cid), item, fromPosition,
            itemEx, toPosition)
    end
    return true
end
