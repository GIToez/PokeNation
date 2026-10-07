local function doPlayerUseBallOnSlot(cid)
	doPlayerUseItem(cid, getPlayerSlotItem(cid, PLAYER_SLOT_BALL).uid)
end

function onUse(cid, item)
	if(isExhaust(cid)) then
		doPlayerSendCancel(cid, "You're exhausted.")

	elseif (isPlayerWithBackpackFull(cid)) then
		doPlayerSendCancel(cid, "Your backpack is full.")

	else
		if (isPokemonOnline(cid)) then
			doPlayerUseBallOnSlot(cid)
		end

		doMovePlayerItem(cid, getFastcallBall(cid, item.uid), {y = PLAYER_SLOT_BALL, z = 0})
		addEvent(doPlayerUseBallOnSlot, 2100, cid)
	end

	return true
end
