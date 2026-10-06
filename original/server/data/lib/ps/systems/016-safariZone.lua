local ATTRIBUTES = {
    REMAING_BAIT = 6500
}

local CATCH_FACTOR_STORAGE = pokemonsStorages.safariCatchFactor

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

function doPlayerRemoveSafariZoneItems(cid)
    doPlayerRemoveItem(cid, EMPTY_SAFARI_BALL_ID, getPlayerItemCount(cid, EMPTY_SAFARI_BALL_ID)) -- safari balls
	doPlayerRemoveItem(cid, 14800, getPlayerItemCount(cid, 14800)) -- safari bait
	doPlayerRemoveItem(cid, 14799, getPlayerItemCount(cid, 14799)) -- safari cookie
	doPlayerRemoveItem(cid, 14798, getPlayerItemCount(cid, 14798)) -- safari small stone
	doPlayerRemoveItem(cid, 14796, getPlayerItemCount(cid, 14796)) -- safari trap
	doPlayerRemoveItem(cid, 14815, getPlayerItemCount(cid, 14815)) -- net
end

--[[
-- Safari Small Stone
]]
function onCreatureUseSafariSmallStone(cid, item, fromPosition, itemEx, toPosition)
    if (not getSafariZone(cid) or not isMonster(itemEx.uid) or not canDoCombat(cid, itemEx.uid) or
            getCreatureCondition(itemEx.uid, CONDITION_INVULNERABLE) or
            getTilePzInfo(getCreaturePosition(cid))) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    if (isUnderwater(cid)) then
        doPlayerSendCancel(cid, "You can't use it while you're underwater.")
        return false
    end

    local cidPos = getCreaturePosition(cid)
    if (getDistanceBetween(cidPos, toPosition) > 5) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
        return false
    end

    local factor = getPokemonCatchFactor(itemEx.uid)
    if (factor >= getPokemonRequiredCatchFactor(itemEx.uid)) then
        doSendMagicEffect(getCreaturePosition(itemEx.uid), EFFECT_EMOTION_EXCLAMATION)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You're able to try caught %s now."), getCreatureName(itemEx.uid)))
        return true
    end

    doSendDistanceShoot(cidPos, toPosition, PROJECTILE_SMALL_STONE)
    doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_CONFUSION, nil, cid)

    local factor = (getPokemonCatchFactor(itemEx.uid) + 1)
    setPokemonCatchFactor(itemEx.uid, factor)
    if (factor >= getPokemonRequiredCatchFactor(itemEx.uid)) then
        doSendMagicEffect(getCreaturePosition(itemEx.uid), EFFECT_EMOTION_EXCLAMATION)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You're able to try caught %s now."), getCreatureName(itemEx.uid)))
    else
        doSendMagicEffect(getCreaturePosition(itemEx.uid), EFFECT_CUT)
    end

    doRemoveItem(item.uid, 1)

    if (getPlayerItemCount(cid, item.itemid) == 0) then
        doTeleportThing(cid, SAFARI_START_POSITION, false)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Your small stones has ended, you will be teleported to the entrance of the Safari Zone.")
    end

    return true
end

--[[
-- Safari Bait
 ]]
local function onBaitTick(position, ticks)
    local working = ticks > 0
    if (working) then
        local bait, remaingBait = getTileItemById(position, 14801), 0
        if (isItem(bait)) then
            remaingBait = getItemAttribute(bait.uid, ATTRIBUTES.REMAING_BAIT)
        end
        working = remaingBait > 0

        if (working) then
            local spec = getSpectators(position, 5, 5)
            if (spec) then
                for i, cid in pairs(spec) do
                    if (isPokemonWild(cid)) then
                        doCreatureWalkToPosition(cid, position)
                        if (getDistanceBetween(getCreaturePosition(cid), position) <= 1) then
                            remaingBait = remaingBait - 1
                            doItemSetAttribute(bait.uid, ATTRIBUTES.REMAING_BAIT, remaingBait)
                            doSendMagicEffect(position, EFFECT_BITE)
                            working = remaingBait > 0
                        end
                    end
                    if (not working) then
                        break
                    end
                end
            end
        end
    end

    if (working) then
        addEvent(onBaitTick, 1000, position, ticks - 1)
    else
        local spec = getSpectators(position, 5, 5)
        if (spec) then
            for i, cid in pairs(spec) do
                if (isPokemonWild(cid)) then
                    if (hasTarget(cid)) then
                        doMonsterSetTarget(cid, getCreatureTarget(cid))
                    else
                        doMonsterChangeTarget(cid)
                    end
                end
            end
        end

        local bait = getTileItemById(position, 14801)
        if (isItem(bait)) then
            doRemoveItem(bait.uid)
        end
    end
    doSendMagicEffect(position, EFFECT_EMOTION_HUNGRY)
end

function onCreatureUseSafariBait(cid, item, fromPosition, itemEx, toPosition)
    if (not getSafariZone(cid) or not isWalkable(cid, toPosition) or
            isItem(getTileItemById(toPosition, item.itemid))) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    if (isUnderwater(cid)) then
        doPlayerSendCancel(cid, "You can't use it while you're underwater.")
        return false
    end

    local bait = doCreateItem(14801, 1, toPosition)
    if (bait) then
        doItemSetAttribute(bait, ATTRIBUTES.REMAING_BAIT, 10)
        onBaitTick(toPosition, 20)
        doRemoveItem(item.uid, 1)
    end
    return true
end

--[[
-- Safari Food
 ]]
function onCreatureUseSafariFood(cid, item, fromPosition, itemEx, toPosition)
    if (not getSafariZone(cid) or not isMonster(itemEx.uid) or
            not canDoCombat(cid, itemEx.uid) or hasTarget(itemEx.uid) or
            getCreatureCondition(itemEx.uid, CONDITION_INVULNERABLE) or
            getTilePzInfo(getCreaturePosition(cid))) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    if (isUnderwater(cid)) then
        doPlayerSendCancel(cid, "You can't use it while you're underwater.")
        return false
    end

    local cidPos = getCreaturePosition(cid)
    if (getDistanceBetween(cidPos, toPosition) > 5) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
        return false
    end

    local factor = getPokemonCatchFactor(itemEx.uid)
    if (factor >= getPokemonRequiredCatchFactor(itemEx.uid)) then
        doSendMagicEffect(getCreaturePosition(itemEx.uid), EFFECT_EMOTION_EXCLAMATION)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You're able to try caught %s now."), getCreatureName(itemEx.uid)))
        return true
    end

    doSendDistanceShoot(cidPos, toPosition, PROJECTILE_GRAVEL)
    if (getRandom(0, 100) <= 70) then
        local factor = factor + 1
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

    doRemoveItem(item.uid, 1)
    return true
end

--[[
-- Safari Trap
 ]]
local TRAPS = {
    [14796] = 14797
}

function onCreatureUseSafariTrap(cid, item, fromPosition, itemEx, toPosition)
    if (not getSafariZone(cid) or not isWalkable(cid, toPosition) or
            isItem(getTileItemById(toPosition, item.itemid))) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    if (isUnderwater(cid)) then
        doPlayerSendCancel(cid, "You can't use it while you're underwater.")
        return false
    end

    doCreateItem(TRAPS[item.itemid], 1, toPosition)
    doRemoveItem(item.uid, 1)
    return true
end

function onCreatureStepInSafariTrap(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (not isMonster(cid)) then
        return false
    end

    doCreatureAddStatus(cid, CREATURE_STATUS_PARALYSIS, true, cid)
    doSendMagicEffect(position, EFFECT_POFF)
    doRemoveItem(item.uid)
    return true
end

--[[
-- Safari Ball
 ]]
function onCreatureUseSafariBall(cid, item, fromPosition, itemEx, toPosition)
    if (not getSafariZone(cid) or not isMonster(itemEx.uid) or not canDoCombat(cid, itemEx.uid) or
            getPokemonCatchFactor(itemEx.uid) < getPokemonRequiredCatchFactor(itemEx.uid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local pokemonLevel = getMonsterLevel(itemEx.uid)
    local pokemonSex = getMonsterSex(itemEx.uid)
    local pokemonName = getCreatureName(itemEx.uid)
    local pokemonSpecialAbility = getMonsterSpecialAbility(itemEx.uid)

    doRemoveCreature(itemEx.uid)
	doRemoveItem(item.uid, 1)
	doSendDistanceShoot(getCreaturePosition(cid), toPosition, balls["safari"].projectile)
	doCreatureSay(cid, "Safari ball, go!", TALKTYPE_SAY)
    doPlayerIncreaseWastedBalls(cid, getPokemonNumberByName(pokemonName), item.itemid)
    RangerClub.onPlayerKill(cid, pokemonName)

	if (getCatchChance(cid, pokemonName, item.itemid, pokemonLevel) <= getBallCatchRate("safari")) then
		doSendMagicEffect(toPosition, balls["safari"].effects.catch)
		addEvent(catchPokemonWithSafariBall, 5500, cid, toPosition, pokemonName, balls["safari"].charged,
            pokemonSex, pokemonLevel, pokemonSpecialAbility, getPlayerWastedBallsMessage(cid, getPokemonNumberByName(pokemonName)) .. __L(cid, " to catch it."))
        doPlayerResetWastedBalls(cid, getPokemonNumberByName(pokemonName), getPlayerCatchTries(cid, getPokemonNumberByName(pokemonName)))
	else
		doSendMagicEffect(toPosition, balls["safari"].effects.catchMiss)
	    addEvent(function(cid, wastedBallMsg)
                    catchMiss(cid, "safari", item.itemid, pokemonName, wastedBallMsg)
                    doSendMagicEffect(toPosition, EFFECT_TELEPORT_UP)
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "%s ran away."), pokemonName))
                end,
            4000, cid, string.format(__L(cid, "%s trying to catch %s."), getPlayerWastedBallsMessage(cid, getPokemonNumberByName(pokemonName)), pokemonName))
	end

    return true
end

--[[
-- Safari Net
]]
function onCreatureUseSafariNet(cid, item, fromPosition, itemEx, toPosition)
    if (not getSafariZone(cid) or not isMonster(itemEx.uid) or not canDoCombat(cid, itemEx.uid) or
            getCreatureCondition(itemEx.uid, CONDITION_INVULNERABLE) or
            getTilePzInfo(getCreaturePosition(cid))) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    if (not isUnderwater(cid)) then
        doPlayerSendCancel(cid, "You can use it only while you're underwater.")
        return false
    end

    local cidPos = getCreaturePosition(cid)
    if (getDistanceBetween(cidPos, toPosition) > 2) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
        return false
    end

    local factor = getPokemonCatchFactor(itemEx.uid)
    if (factor >= getPokemonRequiredCatchFactor(itemEx.uid)) then
        doSendMagicEffect(getCreaturePosition(itemEx.uid), EFFECT_EMOTION_EXCLAMATION)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You're able to try caught %s now."), getCreatureName(itemEx.uid)))
        return true
    end

    doSendDistanceShoot(cidPos, toPosition, PROJECTILE_GRAVEL)
    doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BAD, cid)

    local factor = (getPokemonCatchFactor(itemEx.uid) + 1)
    setPokemonCatchFactor(itemEx.uid, factor)
    if (factor >= getPokemonRequiredCatchFactor(itemEx.uid)) then
        doSendMagicEffect(getCreaturePosition(itemEx.uid), EFFECT_EMOTION_EXCLAMATION)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You're able to try caught %s now."), getCreatureName(itemEx.uid)))
    else
        doSendMagicEffect(getCreaturePosition(itemEx.uid), EFFECT_COBWEB)
    end

    doRemoveItem(item.uid, 1)
    return true
end