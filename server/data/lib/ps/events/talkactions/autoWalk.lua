local function doAutoWalk(cid, direction, lastPosition)
	if (isPlayer(cid)) then
		local currentPosition = getCreaturePosition(cid)

        if (not getSamePosition(currentPosition, lastPosition) or not doMoveCreature(cid, direction)) then
            doPlayerSendCancel(cid, "Auto Walk OFF")
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You are no longer walking automatically.")
            setPlayerAutoWalking(cid, false)
        else
            addEvent(doAutoWalk, 700, cid, direction, getPosByDir(lastPosition, direction, 1))
        end
	end
end

function onSay(cid, words, param)
	if (isExhaust(cid)) then
		doPlayerSendCancel(cid, "You're exhaust.")

    elseif (isPlayerAutoWalking(cid)) then
        doPlayerSendCancel(cid, "You're already auto walking.")

	else
        doPlayerSendCancel(cid, "Auto Walk ON")
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You are walking automatically.")
		doAutoWalk(cid, getCreatureLookDirection(cid), getCreaturePosition(cid))
        setPlayerAutoWalking(cid, true)
		doAddExhaust(cid)
	end

	return true
end
