local chestStorage = 8331

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8329) ~= QUEST_STATUS.STARTED or
            getCreatureStorage(cid, chestStorage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (not doPlayerAddUniqueItem(cid, 18311, 1, false)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please check your backpack for free space.")
        return true

    elseif (not doPlayerAddUniqueItem(cid, 18178, 1, false)) then
        doPlayerRemoveItem(cid, 18311, getPlayerItemCount(cid, 18311))
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please check your backpack for free space.")
        return true
    end

    doCreatureSetStorage(cid, chestStorage, QUEST_STATUS.FINISHED)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You received the machine key and a mysterious flask.")
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_BLUE_BUFF)
    doRemoveItem(itemEx.uid)

	return true
end
