function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8332) ~= QUEST_STATUS.STARTED or item.actionid ~= 200) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doTransformItem(item.uid, 18316)
    doDecayItem(item.uid)

    if (getRandom(0, 100) > 10) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Nothing was found.")
    else
        doPlayerAddUniqueItem(cid, table.random({18192, 18193, 18194}), 1, true)
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "An engine has been found!")
    end

	return true
end
