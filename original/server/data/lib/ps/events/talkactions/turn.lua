local TURNS = {
	["t1"] = {toDirection = NORTH, directionString = "north"},
	["t2"] = {toDirection = EAST, directionString = "east"},
	["t3"] = {toDirection = SOUTH, directionString = "south"},
	["t4"] = {toDirection = WEST, directionString = "west"},
}

function onSay(cid, words, param, channel)
	if (not isPokemonOnline(cid)) then
		doPlayerSendCancel(cid, "First call your Pokemon.")

	else
		local pokemon = getPlayerPokemon(cid)

		doCreatureSetLookDirection(pokemon, TURNS[words].toDirection)
		doCreatureSay(cid, string.format(__L(cid, "%s, turn to the %s!"), getCreatureNickname(pokemon), __L(cid, TURNS[words].directionString)), TALKTYPE_MONSTER)
	end
	return true
end
