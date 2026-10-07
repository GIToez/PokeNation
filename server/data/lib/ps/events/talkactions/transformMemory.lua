function onSay(cid, words, param, channel)
	if (not isPokemonOnline(cid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return true
    end

    local pokemon = getPlayerPokemon(cid)
    if (not getPokemonAbilityAvailable(pokemon, POKEMON_ABILITIES.TRANSFORM) or isPokemonTransformed(pokemon)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

	local memory = getBallTransformMemory(getPlayerBall(cid).uid, tonumber(string.match(words, "%d+")))
    if (not memory) then
        doPlayerSendCancel(cid, "There is no memory to transform in such slot.")
        return true
    end

    doAbilitieTransform(cid, pokemon, nil, memory)
    return true
end
