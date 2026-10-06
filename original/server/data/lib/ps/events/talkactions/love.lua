function onSay(cid)
	if (isPokemonOnline(cid)) then
		doSendMagicEffect(getCreaturePosition(getPlayerPokemon(cid)), EFFECT_LOVE_HEARTS)
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_LOVE_HEARTS)
		return true
	end
	return false
end
