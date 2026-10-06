function onUse(cid, item, fromPosition, itemEx, toPosition)
	doPlayerSafeAddItem(cid, 14632, getRandom(1, 7), true, true)

    if (getRandom(1, 100) <= 5) then -- Paint tickets (yereblu, star)
        doPlayerSafeAddItem(cid, table.random({14449, 14450}), 1, true, false)
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.CHRISTMAS_PAINT_TICKET)
    end

    doSendMagicEffect(toPosition, EFFECT_FIREWORK_RED)
    doRemoveItem(item.uid)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.CHRISTMAS_STOLEN_PRESENT)
	return true
end
