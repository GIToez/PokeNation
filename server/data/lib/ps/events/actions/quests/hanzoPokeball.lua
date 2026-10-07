function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8454) ~= QUEST_STATUS.STARTED or not isNpc(itemEx.uid) or
            getCreatureName(itemEx.uid) ~= "Hanzo Hasashi's Sleeping Charizard") then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_POKEBALL)
    doRemoveCreature(itemEx.uid)

    if (getRandom(1, 3) == 1) then
        addEvent(function()
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Gotcha!")
            doTransformItem(getPlayerItemById(cid, true, item.itemid).uid, 23554) -- hanzo hasashi poke ball (charged)
        end, 5500)
        doSendMagicEffect(toPosition, EFFECT_POKEBALL_CATCH_OK)

    else
        addEvent(function()
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Ooops!")
            doCreateNpc("Hanzo Hasashi's Angry Charizard", toPosition, false)
        end, 3900)
        doSendMagicEffect(toPosition, EFFECT_POKEBALL_CATCH_FAIL)

    end

    return true
end
