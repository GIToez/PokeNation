local WORDS = {
	["s1"] = 1, ["s2"] = 2, ["s3"] = 3, ["s4"] = 4, ["s5"] = 5, ["s6"] = 6, ["s7"] = 7, ["s8"] = 8, ["s9"] = 9, ["s10"] = 10, ["s11"] = 11, ["s12"] = 12, ["s13"] = 13, ["s14"] = 14, ["s15"] = 15, ["s16"] = 16,
	["m1"] = 1, ["m2"] = 2, ["m3"] = 3, ["m4"] = 4, ["m5"] = 5, ["m6"] = 6, ["m7"] = 7, ["m8"] = 8, ["m9"] = 9, ["m10"] = 10, ["m11"] = 11, ["m12"] = 12, ["m13"] = 13, ["m14"] = 14, ["m15"] = 15, ["m16"] = 16
}

function onSay(cid, words, param, channel)
    words = string.lower(words)
	if (isPokemonOnline(cid)) then
		if (isExhaust(cid)) then
			doPlayerSendCancel(cid, "Your Pokemon is exhaust.")
		elseif (hasCondition(cid, CONDITION_PACIFIED)) then
			doPlayerSendCancel(cid, "You can not attack this target right now.")
        elseif (getTilePzInfo(getCreaturePosition(cid))) then
            doPlayerSendCancel(cid, "Your Pokemon can't use moves while you're in the protection zone.")
		else
			local playerPokemon = getPlayerPokemon(cid)
            if (getTilePzInfo(getCreaturePosition(playerPokemon))) then
                doPlayerSendCancel(cid, "Your Pokemon can't use moves while he is inside a protected zone.")
                return true
            end

            local moves = (isPokemonTransformed(playerPokemon) and
                    getPokemonDefaultSkills(getPokemonCurrentTransformation(playerPokemon)) or
                    getPokemonSkills(getCreatureName(playerPokemon), getPlayerBall(cid).uid))
			if (moves[WORDS[words]] ~= nil) then
				doPokemonUseSkill(getPlayerPokemon(cid), moves[WORDS[words]])
			end
		end
	end
	return true
end
