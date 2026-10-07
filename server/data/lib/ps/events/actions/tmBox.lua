local BOXES = {}
BOXES[23948] = {17363, 17352, 17337, 17338, 17344, 17382} -- Old TM Box, psychic, submission, mega punch, razor wind, body slam, tri attack
BOXES[27764] = {17340, 17355, 17358, 17372, 18913, 18916, 18923, 18930, 29165, 29160, 29159} -- common TM Box, whirlwind, rage, dragon rage, swift, headbutt, snore, mud slap, fury cutter, light screen, roar, calm mind
BOXES[27765] = {17337, 17338, 17341, 17344, 17345, 17346, 29158, 29161, 29162, 29163, 29164, 29166, 29167, 29168, 29169, 29170, 29171} -- uncommon TM Box, mega punch, razor wind, mega kick, body slam, take down, double-edge, dragon claw, hail, bulk up, bullet seed, hidden power, safeguard, brick break, shock wave, sandstorm, facade, secret power
BOXES[27766] = {17339, 17342, 17378, 18914, 18918, 18919, 18926} -- status TM Box, swords dance, toxic, thunder wave, curse, protect, rain dance, defense curl
BOXES[27767] = {17343, 17349, 17352, 17354, 17363, 17375, 17368, 17376, 17381, 18917, 18921, 18922, 18924, 18925, 18928} -- rare TM Box, horn drill, ice beam, submission, seismic toss, psychic, dream eater, metronome, sky attack, rock slide, icy wind, iron tail, shadow ball, ice punch, sludge bomb, steel wing
BOXES[27768] = {17350, 17351, 17360, 17361, 17379, 18912, 29172, 29157} -- legendary TM Box, blizzard, hyper beam, thunder, earthquake, psywave, dynamic punch, overheat, focus punch
BOXES[27769] = {17356, 17357, 18920, 24720} -- grass TM Box, mega drain, solar beam, giga drain, energy ball
BOXES[27770] = {17347, 17348, 24716} -- water TM Box, bubblebeam, water gun, water pulse
BOXES[27771] = {17371, 18929, 24719} -- fire TM Box, fire blast, fire punch, flamethrower
BOXES[27772] = {17359, 18927, 18915} -- electric TM Box, thunderbolt, thunder punch, zap cannon

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (doPlayerSafeAddItem(cid, table.random(BOXES[item.itemid]), 1, true)) then
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
        doRemoveItem(item.uid)
    end

	return true
end
