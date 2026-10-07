function onUse(cid, item, fromPosition, itemEx, toPosition)
	doPlayerSafeAddItem(cid, 14461, getRandom(1, 7), true, true)

    if (getRandom(1, 100) <= 5) then -- Paint tickets (black, fang, horn, bat, dark eye, spectral, invisible, magic, pumpkinface, pumpkinhead, x-gold, yellow trace)
        doPlayerSafeAddItem(cid, table.random({18734, 18735, 18736, 19083, 19084, 19085, 25179, 25180, 25181,
            25182, 25183, 25184}), 1, true, false)
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.HALLOWEEN_PAINT_TICKET)
    end

    doSendMagicEffect(toPosition, EFFECT_FIREWORK_RED)
    doRemoveItem(item.uid)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.HALLOWEEN_POT)
	return true
end
