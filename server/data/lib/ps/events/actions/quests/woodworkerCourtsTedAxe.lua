local COUNT = 0 -- Prevent take long time

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8316) ~= QUEST_STATUS.STARTED or itemEx.itemid ~= 18308) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_SPARK)
	doSendAnimatedText(toPosition, table.random({"Poff", "Tak", "Plok", "Puff", "Tek"}), COLOR_ORANGE)

    if (getRandom(0, 100) > 10 and COUNT < 50) then
        COUNT = COUNT + 1
        return true

    elseif (not doPlayerAddUniqueItem(cid, 18302, 1, false)) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please check your backpack for free space.")
        return true
    end

    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You received a wood.")
    doRemoveItem(itemEx.uid)
    doDecayItem(doCreateItem(18307, 1, toPosition))

	return true
end
