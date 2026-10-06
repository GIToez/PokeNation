local targetName = "Crystal Onix"
local pictureStorage = 8327

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8326) ~= QUEST_STATUS.STARTED or not isNpc(itemEx.uid) or
            getCreatureName(itemEx.uid) ~= targetName or
            getCreatureStorage(cid, pictureStorage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_TELEPORT_TWO)

    if (not doPlayerAddUniqueItem(cid, 18309, 1, false)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please check your backpack for free space.")
        return true
    end

    doCreatureSetStorage(cid, pictureStorage, QUEST_STATUS.FINISHED)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You received a picture.")
    doRemoveCreature(itemEx.uid)
    doSendMagicEffect(toPosition, EFFECT_TELEPORT_UP)

	return true
end
