function onSay(cid, words, param, channel)
	param = string.explode(param, ",")

	local pokemonName = param[1] or "Rattata"
	local pokemonLevel = param[2] or 1
	local pokemonExtraPoints = param[3] or 0

    if (not isPokemonName(pokemonName, true)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Invalid Pokemon name.")
        return true
    end

	local ball = doCreatePokemonBall(cid, "poke", pokemonName, pokemonLevel, nil, nil, pokemonExtraPoints, nil, nil, 99999999999, nil, getPokemonRandomSpecialAbility(pokemonName))
	if (param[4] and getPokemonSkillCategory(param[4])) then
		setBallEggMove(ball, 2, param[4])
		doBallUpdateDescription(ball)
	end

	return true
end
