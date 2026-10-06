local ENERGY_DELAY = 2000
local ENERGY_TICKS = 30
local ENERGY_DURATION = ENERGY_TICKS * ENERGY_DELAY / 1000

local EVENTS = {}

local ENERGY_POTIONS = {
	[13653] = {energyGain = 10, msg = "1", iconItemId = 12025}, -- Pokemon Energy Potion
	[13819] = {energyGain = 20, msg = "2", iconItemId = 12145}, -- Great Pokemon Energy Potion
}

local function doEnergyTick(cid, remaingTicks, potionItemId)
	if (isCreature(cid)) then
		doCreatureAddMana(getCreatureMaster(cid), ENERGY_POTIONS[potionItemId].energyGain, false)

		if (remaingTicks > 0) then
			EVENTS[cid] = addEvent(doEnergyTick, ENERGY_DELAY, cid, remaingTicks - 1, potionItemId)

		else
			setIsPokemonUsingEnergyPotion(cid, false)
			doSendAnimatedText(getCreaturePosition(cid), 'ENERGY -' .. ENERGY_POTIONS[potionItemId].msg, COLOR_DARKPURPLE)
			doPlayerSendTextMessage(getCreatureMaster(cid), MESSAGE_STATUS_CONSOLE_BLUE, "The increased energy regeneration of your Pokemon has ended.")
			EVENTS[cid] = nil
		end
	end
end

local function onEnergyStart(target, item, targetPosition, playerPosition, forceFirstHeal)
	setIsPokemonUsingEnergyPotion(target, true)
	doSendAnimatedText(targetPosition, "ENERGY +" .. ENERGY_POTIONS[item.itemid].msg, COLOR_LIGHTBLUE)
	doSendMagicEffect(targetPosition, EFFECT_BLUE_BUFF)
	doSendDistanceShoot(playerPosition, targetPosition, PROJECTILE_GRAVEL)
	doRemoveItem(item.uid, 1)

	if (forceFirstHeal) then
		doCreatureAddMana(getCreatureMaster(target), ENERGY_POTIONS[item.itemid].energyGain, false)
	end

	EVENTS[target] = addEvent(doEnergyTick, ENERGY_DELAY, target, ENERGY_TICKS, item.itemid)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (getPlayerDueling(cid) or getPlayerBattleing(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	if (not isPokemonOnline(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

	else
		local pokemon = getPlayerPokemon(cid)
		local pokemonPosition = getCreaturePosition(pokemon)

		if(toPosition.x ~= pokemonPosition.x or toPosition.y ~= pokemonPosition.y or toPosition.z ~= pokemonPosition.z) then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

		elseif(getDistanceBetween(getCreaturePosition(cid), pokemonPosition) > 4) then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)

		else
			local replacing = isPokemonUsingEnergyPotion(pokemon)
			if (replacing and EVENTS[pokemon]) then
				stopEvent(EVENTS[pokemon])
				EVENTS[pokemon] = nil

				for _, potion in pairs(ENERGY_POTIONS) do
					doPlayerSendPokemonStatusRemove(cid, potion.iconItemId) -- We dont know what is the currently potion, lets send an all clear
				end
			end

			onEnergyStart(pokemon, item, pokemonPosition, getCreaturePosition(cid), not replacing)

			if (replacing) then
				addEvent(function() -- Ugly hack due to slow connections
				if (isCreature(cid)) then
					doPlayerSendPokemonStatusAdd(cid, ENERGY_POTIONS[item.itemid].iconItemId, ENERGY_DURATION)
				end
				end, 100)
			else
				doPlayerSendPokemonStatusAdd(cid, ENERGY_POTIONS[item.itemid].iconItemId, ENERGY_DURATION)
			end
		end
	end

	return true
end
