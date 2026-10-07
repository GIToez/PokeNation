function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (isPokemonOnline(cid)) then
		doPlayerSendCancel(cid, "You can't start or join a duel if you're using a Pokemon.")
	elseif (getPlayerDueling(cid)) then
		doPlayerSendCancel(cid, "You're already dueling.")
    elseif (getTilePzInfo(getCreaturePosition(cid))) then
        doPlayerSendCancel(cid, "You can't duel while you're on a protection zone.")
    elseif (getPlayerFrontierIsland(cid)) then
        doPlayerSendCancel(cid, "You can't duel while you're inside the Frontier Island.")
	else
		local player = getTopCreature(toPosition).uid
		if (not isPlayer(player)) then
			doPlayerSendCancel(cid, "You must select a player.")
		elseif (player == cid) then
			if (getPlayerPartyDuel(cid)) then
				doPartyDuelLeave(cid)
			else
				doPlayerSendCancel(cid, "You can't duel with yourself.")
			end
		elseif (getPlayerDueling(player)) then
			doPlayerSendCancel(cid, "This player is already dueling.")
		elseif (getPlayerPartyDuel(cid)) then
			doPartyDuelInvite(cid, player)
		elseif (getPlayerPartyDuel(player)) then
			doPartyDuelJoin(player, cid)
		else
			setPlayerLastOpponent(cid, player)
			doPlayerSendChannelsDialog(cid, {CHANNEL_1_POKEMON, CHANNEL_2_POKEMON, CHANNEL_3_POKEMON,
                CHANNEL_4_POKEMON, CHANNEL_5_POKEMON, CHANNEL_6_POKEMON})
		end
	end
	return true
end
