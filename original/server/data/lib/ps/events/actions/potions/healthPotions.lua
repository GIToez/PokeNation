local HEALTH_DURATION = 60 -- Seconds
local HEALTH_DELAY = 5000 -- Interval between each regeneration
local HEALTH_TICKS = math.floor(HEALTH_DURATION / (HEALTH_DELAY / 1000)) -- How much regenerations will occur, current: 1 minute full potion work

local health1 = createConditionObject(CONDITION_REGENERATION, HEALTH_DURATION * 1000, false,
    CONDITION_SUBID.REGENERATION.HEALTH_POTION)
setConditionParam(health1, CONDITION_PARAM_HEALTHGAIN, math.floor(3000 / HEALTH_TICKS))
setConditionParam(health1, CONDITION_PARAM_HEALTHTICKS, HEALTH_DELAY)
setConditionParam(health1, CONDITION_PARAM_LIGHT_LEVEL, true) -- Show effect

local health2 = createConditionObject(CONDITION_REGENERATION, HEALTH_DURATION * 1000, false,
    CONDITION_SUBID.REGENERATION.HEALTH_POTION)
setConditionParam(health2, CONDITION_PARAM_HEALTHGAIN, math.floor(6000 / HEALTH_TICKS))
setConditionParam(health2, CONDITION_PARAM_HEALTHTICKS, HEALTH_DELAY)
setConditionParam(health2, CONDITION_PARAM_LIGHT_LEVEL, true) -- Show effect

local health3 = createConditionObject(CONDITION_REGENERATION, HEALTH_DURATION * 1000, false,
    CONDITION_SUBID.REGENERATION.HEALTH_POTION)
setConditionParam(health3, CONDITION_PARAM_HEALTHGAIN, math.floor(12000 / HEALTH_TICKS))
setConditionParam(health3, CONDITION_PARAM_HEALTHTICKS, HEALTH_DELAY)
setConditionParam(health3, CONDITION_PARAM_LIGHT_LEVEL, true) -- Show effect

local health4 = createConditionObject(CONDITION_REGENERATION, HEALTH_DURATION * 1000, false,
    CONDITION_SUBID.REGENERATION.HEALTH_POTION)
setConditionParam(health4, CONDITION_PARAM_HEALTHGAIN, math.floor(18000 / HEALTH_TICKS))
setConditionParam(health4, CONDITION_PARAM_HEALTHTICKS, HEALTH_DELAY)
setConditionParam(health4, CONDITION_PARAM_LIGHT_LEVEL, true) -- Show effect

local HEALTH_POTIONS = {
    [12244] = {healthGain = math.floor(3000 / HEALTH_TICKS), condition = health1, msg = "1", onlyPokemon = false, iconItemId = 11205}, -- Pokemon Health Potion
    [12245] = {healthGain = math.floor(6000 / HEALTH_TICKS), condition = health2, msg = "2", onlyPokemon = true, iconItemId = 11206}, -- Great Pokemon Health Potion
    [12246] = {healthGain = math.floor(12000 / HEALTH_TICKS), condition = health3, msg = "3", onlyPokemon = true, iconItemId = 11207}, -- Ultra Pokemon Health Potion
    [12247] = {healthGain = math.floor(18000 / HEALTH_TICKS), condition = health4, msg = "4", onlyPokemon = true, iconItemId = 11208}, -- Super Pokemon Health Potion
}

local EVENTS = {}

local function onHealEnd(cid, msg)
    if (isCreature(cid)) then
        setIsPokemonUsingHealthPotion(cid, false)
        doSendAnimatedText(getCreaturePosition(cid), "HEAL -" .. msg, COLOR_RED)
        EVENTS[cid] = nil
        if (isMonster(cid)) then
            doPlayerSendTextMessage(getCreatureMaster(cid), MESSAGE_STATUS_CONSOLE_BLUE, "The increased health regeneration of your Pokemon has ended.")
        else
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Your increased health regeneration has ended.")
        end
    end
end

local function onHealStart(target, item, targetPosition, playerPosition, forceFirstHeal)
    setIsPokemonUsingHealthPotion(target, true)
    doAddCondition(target, HEALTH_POTIONS[item.itemid].condition)
    EVENTS[target] = addEvent(onHealEnd, HEALTH_DURATION * 1000, target, HEALTH_POTIONS[item.itemid].msg)
    doSendAnimatedText(targetPosition, "HEAL +" .. HEALTH_POTIONS[item.itemid].msg, COLOR_LIGHTGREEN)
    doSendMagicEffect(targetPosition, EFFECT_GREEN_BUFF)
    doSendDistanceShoot(playerPosition, targetPosition, PROJECTILE_GRAVEL)
    doRemoveItem(item.uid, 1)

    if (forceFirstHeal) then
        doCreatureAddHealth(target, HEALTH_POTIONS[item.itemid].healthGain, true)
    end
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (getPlayerDueling(cid) or getPlayerPvpArena(cid) or getPlayerBattleing(cid) or not HEALTH_POTIONS[item.itemid]) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	local target, pokemon, playerPosition, msg, targetPosition = nil, getPlayerPokemon(cid), getCreaturePosition(cid), "Sorry, not possible.", nil
    local replacing = false
	if (getDistanceBetween(playerPosition, toPosition) > 4) then
		msg = "Too far."

	elseif (isCreature(pokemon)) then
		local pokemonPosition = getCreaturePosition(pokemon)
		if (getSamePosition(pokemonPosition, toPosition)) then
			if (isPokemonUsingHealthPotion(pokemon)) then
				replacing = true
            end

            target = pokemon
            targetPosition = pokemonPosition

		elseif (getSamePosition(playerPosition, toPosition)) then
			if (HEALTH_POTIONS[item.itemid].onlyPokemon) then
                msg = "You can not use this potion on yourself."
            else
                target = cid
                targetPosition = playerPosition
            end
		end

	elseif (getSamePosition(playerPosition, toPosition)) then
		if (HEALTH_POTIONS[item.itemid].onlyPokemon) then
            msg = "You can not use this potion on yourself."
        else
            target = cid
            targetPosition = playerPosition
        end
    end

    if (target == cid and isPokemonUsingHealthPotion(cid)) then
        replacing = true
    end

	if (isCreature(target)) then
        if (replacing and EVENTS[target]) then
            stopEvent(EVENTS[target])
            EVENTS[target] = nil
            doRemoveCondition(target, CONDITION_REGENERATION, CONDITION_SUBID.REGENERATION.HEALTH_POTION)

            for _, potion in pairs(HEALTH_POTIONS) do
                doPlayerSendPokemonStatusRemove(getCreatureMaster(target), potion.iconItemId) -- We dont know what is the currently potion, lets send an all clear
            end
        end

        onHealStart(target, item, targetPosition, playerPosition, not replacing)

        if (replacing) then
            addEvent(function() -- Ugly hack due to slow connections
                    if (isCreature(cid)) then
                        doPlayerSendPokemonStatusAdd(cid, HEALTH_POTIONS[item.itemid].iconItemId, HEALTH_DURATION)
                    end
                end, 100)
        else
            doPlayerSendPokemonStatusAdd(cid, HEALTH_POTIONS[item.itemid].iconItemId, HEALTH_DURATION)
        end


	else
		doPlayerSendCancel(cid, msg)
	end
	return true
end
