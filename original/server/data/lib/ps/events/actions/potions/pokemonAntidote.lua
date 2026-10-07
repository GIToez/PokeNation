local delay = createConditionObject(CONDITION_EXHAUST, 1 * 60 * 1000, false, CONDITION_SUBID.EXHAUST.POTIONANTIDOTE)

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (getPlayerDueling(cid) or getPlayerPvpArena(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return true
    elseif (getCreatureCondition(cid, CONDITION_EXHAUST, CONDITION_SUBID.EXHAUST.POTIONANTIDOTE)) then
		doPlayerSendCancel(cid, "You're exhausted.")
	end

	if (not isPokemonOnline(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

	else
		local pokemon = getPlayerPokemon(cid)
		local pokemonPosition = getCreaturePosition(pokemon)

		if (toPosition.x ~= pokemonPosition.x or toPosition.y ~= pokemonPosition.y or toPosition.z ~= pokemonPosition.z) then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

		else
			fromPosition = getCreaturePosition(cid)

			if(getDistanceBetween(fromPosition, pokemonPosition) > 4) then
				doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
			end

			doSendMagicEffect(pokemonPosition, EFFECT_GREEN_BUFF)
            doSendDistanceShoot(fromPosition, pokemonPosition, PROJECTILE_GRAVEL)
            doCreatureRemoveStatus(pokemon, CREATURE_STATUS_POISON)
            doAddCondition(cid, delay)
			doRemoveItem(item.uid, 1)
		end
	end
	return true
end
