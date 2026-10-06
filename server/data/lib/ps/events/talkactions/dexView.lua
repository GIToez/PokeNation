function onSay(cid, words, param)
    if (not param) then
		return false
    end
    if (not isExhaust(cid)) then
        local pokemonName = getPokemonNameByNumber(tonumber(param))
        if (pokemonName and hasPlayerDexedPokemon(cid, pokemonName)) then
            doPokedexItemView(cid, pokemonName)
        end
        doAddExhaust(cid)
    end
	return true
end
