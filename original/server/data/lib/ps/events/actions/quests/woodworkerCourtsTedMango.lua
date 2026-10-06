local counterStorage = 8323
local targetName = "Courts Ted's Machop"

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8320) ~= QUEST_STATUS.STARTED or not isNpc(itemEx.uid) or
            getCreatureName(itemEx.uid) ~= targetName) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doRemoveItem(item.uid, 1)
    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    doCreatureSay(itemEx.uid, "Crunch", TALKTYPE_ORANGE_1)
    doCreatureIncreaseStorage(cid, counterStorage)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Courts Ted's Machop feed step complete [%s/5]."), getCreatureStorage(cid, counterStorage)))

	return true
end
