local specialCookieItemid = 18297

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8310) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (getPlayerItemCount(cid, specialCookieItemid) > 0) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You are already carrying special cookies.")
        return true
    end

    if (not doPlayerAddUniqueItem(cid, specialCookieItemid, 100, false)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please check your backpack for free space.")
    end

	return true
end
