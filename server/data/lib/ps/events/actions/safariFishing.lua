local FISHING_FLOAT_ID = 13181
local SHINY_CHANCE = getConfigValue("shinyAppearChance") * 2
local FISHABLE_POKEMONS = {"Goldeen", "Poliwag", "Horsea", "Shellder", "Tentacool", "Krabby", "Magikarp", "Goldeen", "Poliwag", "Horsea", "Shellder", "Tentacool", "Krabby", "Magikarp"}

local function getPlayerFishingFormula(cid)
	return getPlayerSkill(cid, SKILL_FISHING) / 200 + 0.85 * math.random()
end

local function doFishing(cid, fromPosition, toPosition)
	if (isPlayer(cid)) then
		local currentPosition = getCreaturePosition(cid)

		if (currentPosition.x ~= fromPosition.x or currentPosition.y ~= fromPosition.y or currentPosition.z ~= fromPosition.z) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You left your fishing spot and stopped to fish.")
			doSendMagicEffect(toPosition, EFFECT_WATER_PULSE)
			doRemoveItem(getTileItemById(toPosition, FISHING_FLOAT_ID).uid)
			setFishingStatus(cid, false)

		elseif (getPlayerFishingFormula(cid) > 1.0) then
			local randomFishablePokemon = FISHABLE_POKEMONS[math.random(1, #FISHABLE_POKEMONS)]

			if (getRandom(0, SHINY_CHANCE) == 0) then
				randomFishablePokemon = getMonsterInfo(randomFishablePokemon).shiny
			end

			local pokemonFished = doSummonCreature(randomFishablePokemon, fromPosition)

			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You hooked something! (%s)."), randomFishablePokemon))
			doSendMagicEffect(fromPosition, EFFECT_EMOTION_EXCLAMATION)
			doRemoveItem(getTileItemById(toPosition, FISHING_FLOAT_ID).uid)
			doSendMagicEffect(toPosition, CONST_ME_LOSEENERGY)
			setFishingStatus(cid, false)
			setMonsterUniqueTarget(pokemonFished, cid)
			addEvent(doRemoveCreature, 2 * 60 * 1000, pokemonFished, true, false) -- remove creature after 2 min, force remove and dont show error

		else
			addEvent(doFishing, 1000, cid, fromPosition, toPosition, rod)
		end

	else
		doRemoveItem(getTileItemById(toPosition, FISHING_FLOAT_ID).uid)
	end
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (not isInArray(WATER_IDS, itemEx.itemid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

	elseif (isFishing(cid)) then
		doPlayerSendCancel(cid, "You're already fishing.")

	elseif (getPlayerMounted(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

	else
		local playerPosition = getCreaturePosition(cid)

		if (getDistanceBetween(playerPosition, toPosition) > 4) then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)

		else
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You are fishing now.")
			setFishingStatus(cid, true)
			doCreateItem(FISHING_FLOAT_ID, 1, toPosition)
			doSendDistanceShoot(playerPosition, toPosition, PROJECTILE_GRAVEL)
			doSendMagicEffect(toPosition, EFFECT_WATER_PULSE)
			addEvent(doFishing, 10 * 1000, cid, playerPosition, toPosition)
		end
	end

	return true
end
