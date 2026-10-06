function onSay(cid, words, param)
	if (not isPokemonOnline(cid)) then
		doPlayerSendCancel(cid, "First get your Pokemon.")
	else
		local pokemonLevel = getPlayerPokemonLevel(cid)
		local pokemonExperience = getPlayerPokemonExperience(cid)
		local TotalExpToNextLevel = getExperienceForLevel(pokemonLevel + 1)
		local TotalExpToCurrentLevel = getExperienceForLevel(pokemonLevel)

		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Your %s is at level %s and has %s experience points, he needs more %s(%s%%) experience points to advance to level %s."), getPlayerPokemonNickname(cid), pokemonLevel, pokemonExperience, TotalExpToNextLevel - pokemonExperience,  100 - math.ceil((pokemonExperience - TotalExpToCurrentLevel) /
				((TotalExpToNextLevel - TotalExpToCurrentLevel) / 100)), pokemonLevel + 1))
	end
	return true
end
