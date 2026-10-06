local TREE_ITEMID = 18648
local RESPAWN_PLACES = {{3039, 2962, 6}, {2952, 2917, 6}, {2978, 2547, 7}, {3068, 2596, 7}, {2785, 2358, 7}, {2761, 2336, 7}, {2980, 2200, 7}, {3004, 2156, 7}, {3013, 1920, 7}, {3131, 1885, 7}, {2804, 1837, 7}, {2805, 1781, 7}, {2998, 1641, 7}, {3054, 1607, 7}, {3472, 1547, 7}, {3506, 1497, 7}, {3492, 1619, 7}, {4045, 1757, 7}, {4081, 1808, 5}, {3916, 1912, 6}, {3955, 1981, 6}, {4085, 3268, 7}, {4108, 3202, 7}, {3867, 2625, 7}, {3819, 2602, 7}, {3484, 3177, 7}, {3609, 3222, 6}, {3322, 3232, 6}, {3372, 3250, 6}}
local lastPlace

function onThink()
    if (lastPlace and isItem(getTileItemById(lastPlace, TREE_ITEMID))) then
        return true
        --[[doRemoveItem(getTileItemById(lastPlace, TREE_ITEMID).uid)
        doSendMagicEffect(lastPlace, EFFECT_TELEPORT_UP)]]
    end

    local pos = table.random(RESPAWN_PLACES)
	if (doCreateItem(TREE_ITEMID, 1, {x = pos[1], y = pos[2], z = pos[3]})) then
        lastPlace = {x = pos[1], y = pos[2], z = pos[3]}
        doSendMagicEffect(lastPlace, EFFECT_TELEPORT_DOWN)
    else
        log(LOG_TYPES.ERROR, "sudowoodoTree - Can't spawn monster at position.", pos[1], pos[2], pos[3])
    end
	return true
end
