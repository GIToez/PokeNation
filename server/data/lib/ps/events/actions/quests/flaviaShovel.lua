local necklaceStorage = 8292

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (itemEx.itemid ~= 231 or itemEx.actionid ~= 200 or
            getCreatureStorage(cid, necklaceStorage) == QUEST_STATUS.FINISHED or
            getCreatureStorage(cid, 8346) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)

    if (getRandom(0, 100) <= 5) then
        if (doPlayerAddUniqueItem(cid, 18196, 1, false)) then
            doCreatureSetStorage(cid, necklaceStorage, QUEST_STATUS.FINISHED)
            doSendMagicEffect(toPosition, EFFECT_BLUE_BUFF)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Something has been found!")
        end

    else
        doSendMagicEffect(toPosition, EFFECT_POFF)
        doDecayItem(doCreateItem(18289, 1, toPosition))
    end

	return true
end
