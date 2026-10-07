local elixirDelayCondition = createConditionObject(CONDITION_EXHAUST, 2 * 60 * 1000, false, CONDITION_SUBID.EXHAUST.POTIONELIXIR)

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (getPlayerDueling(cid) or getPlayerPvpArena(cid) or getPlayerBattleing(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	if (not isPokemonOnline(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	elseif (getPlayerDueling(cid)) then
		doPlayerSendCancel(cid, "You can not use this potion while you're dueling.")
	elseif (getCreatureCondition(cid, CONDITION_EXHAUST, CONDITION_SUBID.EXHAUST.POTIONELIXIR)) then
		doPlayerSendCancel(cid, "You're exhausted.")
	else
		local pokemon = getPlayerPokemon(cid)
		local pokemonPosition = getCreaturePosition(pokemon)
		if (toPosition.x ~= pokemonPosition.x or toPosition.y ~= pokemonPosition.y or toPosition.z ~= pokemonPosition.z) then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

		else
			fromPosition = getCreaturePosition(cid)

			if (getDistanceBetween(fromPosition, pokemonPosition) > 4) then
				doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
			end

			doSendAnimatedText(pokemonPosition, 'ELIXIR', COLOR_LIGHTGREEN)
			doSendMagicEffect(pokemonPosition, EFFECT_GREEN_BUFF)
			doRemoveCondition(pokemon, CONDITION_POISON)
			doRemoveCondition(pokemon, CONDITION_PARALYZE)
			doRemoveCondition(pokemon, CONDITION_FIRE)
			doRemoveCondition(pokemon, CONDITION_DRUNK)
			doCreatureAddHealth(pokemon, getCreatureMaxHealth(pokemon) - getCreatureHealth(pokemon))
			doRemoveItem(item.uid, 1)
			doAddCondition(cid, elixirDelayCondition)
		end
	end

	return true
end
