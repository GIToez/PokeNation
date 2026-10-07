local storages = {
    ["Young Bellossom"] = 8233,
    ["Young Butterfree"] = 8234,
    ["Young Paras"] = 8235,
    ["Young Raticate"] = 8236,
    ["Young Spinarak"] = 8237,
    ["Young Vileplume"] = 8238,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isCreature(itemEx.uid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (getDistanceBetween(getCreaturePosition(cid), toPosition) > 3) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
        return true
    end

    local name = getCreatureName(itemEx.uid)
    if (storages[name]) then
        if (getCreatureStorage(cid, storages[name]) ~= QUEST_STATUS.FINISHED) then
            doCreatureSetStorage(cid, storages[name], QUEST_STATUS.FINISHED)
            doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
            doSendMagicEffect(toPosition, EFFECT_GREEN_BUFF)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Seems that %s liked the new food."), name))
            doRemoveItem(item.uid, 1)

        else
            doPlayerSendCancel(cid, "You already fed this Pokemon.")
        end

    else
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end

	return true
end
