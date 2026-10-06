function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (not isPokemonOnline(cid) or getPlayerDueling(cid) or getPlayerBattleing(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
	else
		local pokemon = getPlayerPokemon(cid)
		local pokemonPosition = getCreaturePosition(pokemon)
		if (toPosition.x ~= pokemonPosition.x or toPosition.y ~= pokemonPosition.y or toPosition.z ~= pokemonPosition.z) then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

		elseif (getDistanceBetween(getCreaturePosition(cid), pokemonPosition) > 3) then
			doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)

		else
			local pokemonLevel = getPlayerPokemonLevel(cid)
			--[[if (pokemonLevel >= POKEMON_LEVEL_MAX) then
				doPlayerSendCancel(cid, "Your Pokemon is already at maximum level.")

			else]]if (not doPlayerPokemonAddExperience(cid, pokemon, (getExperienceForLevel(pokemonLevel + 1) -
                    getPlayerPokemonExperience(cid)), false)) then
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

            else
				doSendMagicEffect(pokemonPosition, EFFECT_RED_BUFF)
				doRemoveItem(item.uid, 1)
			end
		end
	end

	return true
end
