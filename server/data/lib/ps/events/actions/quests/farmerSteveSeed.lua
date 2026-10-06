function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8263) ~= QUEST_STATUS.STARTED or itemEx.itemid ~= 804 or
            itemEx.actionid ~= 100) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local count = doCreatureIncreaseStorage(cid, 8347)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You planted %s %s. [%s/5]"), getItemArticleById(item.itemid), getItemNameById(item.itemid), count))
	doSendMagicEffect(toPosition, EFFECT_ROOTS)
    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
	doRemoveItem(item.uid, 1)

	return true
end
