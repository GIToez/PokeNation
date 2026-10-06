local LOLLIPOP_LEVEL_ATTR = 1000

local function getLollipopExpRate(pokemonLevel)
	if (pokemonLevel >= 90) then
		return 0.3
	elseif (pokemonLevel >= 70) then
		return 0.4
	elseif (pokemonLevel >= 50) then
		return 0.5
	elseif (pokemonLevel >= 40) then
		return 0.6
	elseif (pokemonLevel >= 30) then
		return 0.7
	end
	return 1.0
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (not isPokemonOnline(cid) or getPlayerDueling(cid) or getPlayerBattleing(cid)) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	local pokemon = getPlayerPokemon(cid)
	local pokemonPosition = getCreaturePosition(pokemon)
	if (toPosition.x ~= pokemonPosition.x or toPosition.y ~= pokemonPosition.y or toPosition.z ~= pokemonPosition.z) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return true

	elseif (getDistanceBetween(getCreaturePosition(cid), pokemonPosition) > 3) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
		return true
	end

	local pokemonLevel = getPlayerPokemonLevel(cid)
	local lollipopLevel = getItemAttribute(item.uid, LOLLIPOP_LEVEL_ATTR)
	if (not lollipopLevel) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return true

	elseif (pokemonLevel > lollipopLevel) then
		doPlayerSendCancel(cid, string.format(__L(cid, "The level of this Pokemon is too high to use this Lollipop. You can use it at maximum on level %s Pokemon."), lollipopLevel))
		return true
	end

	local ball = getPlayerBall(cid).uid
	if (getBallLastLollipopReceived(ball)) then
		local interval = getCurrentTimeInSeconds() - getBallLastLollipopReceived(ball)
		if (interval > 0 and interval < 23 * 60 * 60) then -- Interval may be negative due to a bug within getCurrentTimeInSeconds
			doPlayerSendCancel(cid, string.format(__L(cid, "This Pokemon has received a Lollipop recently. He must wait %s to receive another."), table.concat(string.timediff((23 * 60 * 60) - interval))))
			return true
		end
	end

	local expAmount = (getExperienceForLevel(pokemonLevel + 1) - getExperienceForLevel(pokemonLevel)) * getLollipopExpRate(pokemonLevel)
	-- todo check if pass maximum exp (level 100)
	if (not doPlayerPokemonAddExperience(cid, pokemon, expAmount, false)) then
		doPlayerSendCancel(cid, "Your Pokemon is already at maximum level.")
		return true
	end

	doSendMagicEffect(pokemonPosition, EFFECT_RED_BUFF)
	doRemoveItem(item.uid, 1)
	setBallLastLollipopReceived(ball, getCurrentTimeInSeconds())

	return true
end
