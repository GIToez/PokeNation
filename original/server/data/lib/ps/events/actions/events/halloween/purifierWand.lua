local MAX_COUNT = 40
local CORPSES = {11480, 11481, 11482, 12946, 12947, 12948}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx) or not isCorpse(itemEx.uid) or getCreatureStorage(cid, 8408) ~= QUEST_STATUS.STARTED or
            getItemAttribute(itemEx.uid, "corpseowner") ~= getPlayerGUID(cid) or
            getCreatureStorage(cid, 8409) > MAX_COUNT or not table.find(CORPSES, itemEx.itemid) or
			getItemAttribute(itemEx.uid, "pokemon")) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doRemoveItem(itemEx.uid)
    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_ENERGY)
    doSendMagicEffect(toPosition, EFFECT_TELEPORT_TWO)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Purified Pokemon: %s/%s."), doCreatureIncreaseStorage(cid, 8409), MAX_COUNT))
	return true
end
