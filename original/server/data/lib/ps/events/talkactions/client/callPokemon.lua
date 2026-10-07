local function doMoveBallToSlot(cid, ballUid)
    doMovePlayerItem(cid, ballUid, {y = PLAYER_SLOT_BALL, z = 0})
end

local function doUseBall(cid)
    if (isPlayer(cid)) then
        doPlayerUseBallOnSlot(cid)
    end
end

function onSay(cid, words, param)
	if (not param) then
        return true

    elseif (isExhaust(cid)) then
        doPlayerSendCancel(cid, "You're exhausted.")
        return true

    elseif (isPokemonOnline(cid)) then
        local fastcallBall = getFastcallBall(cid, param)
        if (fastcallBall) then
            local currentBall = getPlayerSlotItem(cid, PLAYER_SLOT_BALL)
            if (isItem(currentBall)) then
                doPlayerUseBallOnSlot(cid)
                if (doSwapItems(fastcallBall, currentBall.uid)) then
                    addEvent(doUseBall, 1510, cid)
                end
            else
                doMoveBallToSlot(cid, fastcallBall)
                addEvent(doUseBall, 1510, cid)
            end

        else
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        end

    else
        local currentBall = getPlayerSlotItem(cid, PLAYER_SLOT_BALL)
        if (isItem(currentBall) and doSwapItems(getFastcallBall(cid, param), currentBall.uid)) then
            doPlayerUseBallOnSlot(cid)
        else
            doMoveBallToSlot(cid, getFastcallBall(cid, param))
            doPlayerUseBallOnSlot(cid)
        end
    end

    return true
end
