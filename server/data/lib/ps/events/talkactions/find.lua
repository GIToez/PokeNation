local ENERGY_COST = 15

function onSay(cid, words, param)
    local requestEnergy = not doMasteryAdvantageCheck(cid, MASTERY_ADVANTAGES.FIND_WITHOUT_ENERGY)

    if (not getPlayerMounted(cid) and not isPokemonOnline(cid)) then
		doPlayerSendCancel(cid, "First get your Pokemon.")

	elseif (not getPokemonAbilityAvailable(nil, POKEMON_ABILITIES.FIND, getPlayerPokemonName(cid, true))) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

	elseif (requestEnergy and (isPokemonOnline(cid) and getCreatureMana(cid) < ENERGY_COST or
            getBallPokemonEnergy(getPlayerBall(cid).uid) < ENERGY_COST)) then
		doPlayerSendCancel(cid, "Your Pokemon has insuficient energy.")

	elseif (param == '') then
		doPlayerSendCancel(cid, "Player not found.")

	else
		local pid = getPlayerByNameWildcard(param)
		if (not isPlayer(pid) or isGamemaster(pid)) then
			doPlayerSendCancel(cid, "Player not found.")

		elseif (pid == cid) then
			doPlayerSendCancel(cid, "You can't search for yourself.")

		else
			local targetPosition = getCreaturePosition(pid)

			doCreatureSay(cid, string.format(__L(cid, "%s , find it!"), getPlayerPokemonNickname(cid)), TALKTYPE_MONSTER)
			doPlayerAddMapMark(cid, targetPosition, 0, string.format(__L(cid, "%s  last position."), getCreatureName(pid)))
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, param .. " " .. getSearchString(getCreaturePosition(cid), targetPosition, cid, true, true) .. ".")
			if (requestEnergy) then
                if (isPokemonOnline(cid)) then
                    doCreatureAddMana(cid, -ENERGY_COST, false)
                else
                    local ball = getPlayerBall(cid)
                    setBallPokemonEnergy(ball.uid, getBallPokemonEnergy(ball.uid) - ENERGY_COST)
                end
            end
		end
	end
	return true
end
