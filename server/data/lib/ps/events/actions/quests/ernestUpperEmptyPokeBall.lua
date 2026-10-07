local npcName = "Ernest Upper Totodile"

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isNpc(itemEx.uid) or getCreatureStorage(cid, 8262) ~= QUEST_STATUS.STARTED or
            getCreatureName(itemEx.uid) ~= npcName) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doTransformItem(item.uid, 18286, 1)
    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_AZUREBALL)
    doSendMagicEffect(toPosition, EFFECT_AZUREBALL_USE)
    doRemoveCreature(itemEx.uid)
    addEvent(doCreateNpc, 5 * 60 * 1000, npcName, toPosition)

	return true
end
