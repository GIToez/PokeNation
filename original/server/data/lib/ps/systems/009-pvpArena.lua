PVP_ARENA_TEAM_NONE = 0
PVP_ARENA_TEAM_BLUE = 1
PVP_ARENA_TEAM_RED = 2

local PVPARENA_THINK_INTERVAL = 10 * 60 * 1000

local ARENA_ID_1 = 1 -- Level 25, Map Castle
local ARENA_ID_2 = 2 -- Level 25, Map Mine
local ARENA_ID_3 = 3 -- Level 25, Map Forest
local ARENA_ID_4 = 4 -- Level 50, Map Castle
local ARENA_ID_5 = 5 -- Level 50, Map Mine
local ARENA_ID_6 = 6 -- Level 50, Map Forest
local ARENA_ID_7 = 7 -- Level 75, Map Castle
local ARENA_ID_8 = 8 -- Level 75, Map Mine
local ARENA_ID_9 = 9 -- Level 75, Map Forest
local ARENA_ID_10 = 10 -- Level 100, Map Castle
local ARENA_ID_11 = 11 -- Level 100, Map Mine
local ARENA_ID_12 = 12 -- Level 100, Map Forest
local ARENA_ID_13 = 13 -- Level 0, Map Castle
local ARENA_ID_14 = 14 -- Level 0, Map Mine
local ARENA_ID_15 = 15 -- Level 0, Map Forest

local ARENAS = {
	ARENA_ID_1,
	ARENA_ID_2,
	ARENA_ID_3,
	ARENA_ID_4,
	ARENA_ID_5,
	ARENA_ID_6,
	ARENA_ID_7,
	ARENA_ID_8,
	ARENA_ID_9,
	ARENA_ID_10,
	ARENA_ID_11,
	ARENA_ID_12,
	ARENA_ID_13,
	ARENA_ID_14,
	ARENA_ID_15
}

local ARENAS_CONFIG = {
    [ARENA_ID_1] = {channels = {blue = 274, red = 275}, nextArena = ARENA_ID_2, maxLevel = 25, blueSpawn = {x = 5393, y = 970, z = 7}, redSpawn = {x = 5314, y = 970, z = 7}, exitPosition = {x = 4725, y = 143, z = 8},
		itemRaids = {
            items = {14750, 14751, 14752--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1218, 1571, 7}, {1222, 1558, 7}, {1227, 1552, 7}, {1242, 1540, 7}, {1247, 1556, 7}, {1241, 1570, 7}, {1267, 1560, 7}, {1273, 1571, 7}, {1272, 1560, 7}, {1260, 1554, 7}]]}
        }  -- TODO POS FIX
	},
    [ARENA_ID_2] = {channels = {blue = 276, red = 277}, nextArena = ARENA_ID_3, maxLevel = 25, blueSpawn = {x = 5379, y = 1033, z = 6}, redSpawn = {x = 5315, y = 1089, z = 6}, exitPosition = {x = 4725, y = 143, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1220, 1688, 7}, {1227, 1678, 7}, {1232, 1659, 7}, {1251, 1659, 7}, {1262, 1673, 7}, {1254, 1676, 7}, {1243, 1666, 7}, {1259, 1641, 7}, {1255, 1632, 7}, {1282, 1637, 7}]]}
        }
	},
    [ARENA_ID_3] = {channels = {blue = 278, red = 279}, nextArena = ARENA_ID_1, maxLevel = 25, blueSpawn = {x = 5326, y = 1154, z = 7}, redSpawn = {x = 5391, y = 1220, z = 7}, exitPosition = {x = 4725, y = 143, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1209, 1750, 7}, {1229, 1752, 7}, {1230, 1737, 7}, {1238, 1764, 7}, {1244, 1787, 7}, {1254, 1783, 7}, {1262, 1790, 7}, {1270, 1781, 7}, {1263, 1804, 7}, {1272, 1804, 7}]]}
        }
	},


	[ARENA_ID_4] = {channels = {blue = 280, red = 281}, nextArena = ARENA_ID_5, maxLevel = 50, blueSpawn = {x = 5256, y = 970, z = 7}, redSpawn = {x = 5177, y = 970, z = 7}, exitPosition = {x = 4726, y = 149, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1362, 1572, 7}, {1367, 1559, 7}, {1372, 1553, 7}, {1381, 1555, 7}, {1392, 1557, 7}, {1387, 1541, 7}, {1411, 1559, 7}, {1421, 1567, 7}, {1418, 1571, 7}, {1414, 1562, 7}]]}
        }
	},
    [ARENA_ID_5] = {channels = {blue = 282, red = 283}, nextArena = ARENA_ID_6, maxLevel = 50, blueSpawn = {x = 5242, y = 1033, z = 6}, redSpawn = {x = 5178, y = 1089, z = 6}, exitPosition = {x = 4726, y = 149, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1365, 1689, 7}, {1371, 1678, 7}, {1363, 1663, 7}, {1388, 1668, 7}, {1399, 1676, 7}, {1411, 1654, 7}, {1407, 1642, 7}, {1414, 1636, 7}, {1426, 1626, 7}, {1400, 1633, 7}]]}
        }
	},
    [ARENA_ID_6] = {channels = {blue = 284, red = 285}, nextArena = ARENA_ID_4, maxLevel = 50, blueSpawn = {x = 5189, y = 1154, z = 7}, redSpawn = {x = 5254, y = 1220, z = 7}, exitPosition = {x = 4726, y = 149, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1354, 1751, 7}, {1370, 1753, 7}, {1378, 1736, 7}, {1390, 1757, 7}, {1380, 1779, 7}, {1402, 1782, 7}, {1416, 1782, 7}, {1417, 1804, 7}, {1406, 1813, 7}, {1427, 1801, 7}]]}
        }
	},


	[ARENA_ID_7] = {channels = {blue = 286, red = 287}, nextArena = ARENA_ID_8, maxLevel = 75, blueSpawn = {x = 5118, y = 967, z = 7}, redSpawn = {x = 5039, y = 2689, z = 7}, exitPosition = {x = 4717, y = 149, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1493, 1575, 7}, {1500, 1564, 7}, {1505, 1572, 7}, {1510, 1556, 7}, {1519, 1544, 7}, {1533, 1549, 7}, {1547, 1572, 7}, {1552, 1576, 7}, {1550, 1564, 7}, {1539, 1587, 7}]]}
        }
	},
    [ARENA_ID_8] = {channels = {blue = 288, red = 289}, nextArena = ARENA_ID_9, maxLevel = 75, blueSpawn = {x = 5104, y = 1030, z = 6}, redSpawn = {x = 5040, y = 1086, z = 6}, exitPosition = {x = 4717, y = 149, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1498, 1691, 7}, {1503, 1692, 7}, {1510, 1678, 7}, {1512, 1663, 7}, {1533, 1661, 7}, {1541, 1664, 7}, {1550, 1659, 7}, {1542, 1645, 7}, {1536, 1643, 7}, {1559, 1655, 7}]]}
        }
	},
    [ARENA_ID_9] = {channels = {blue = 290, red = 291}, nextArena = ARENA_ID_7, maxLevel = 75, blueSpawn = {x = 5051, y = 1151, z = 7}, redSpawn = {x = 5116, y = 1217, z = 7}, exitPosition = {x = 4717, y = 149, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1500, 1754, 7}, {1508, 1744, 7}, {1523, 1745, 7}, {1521, 1768, 7}, {1532, 1761, 7}, {1537, 1787, 7}, {1528, 1793, 7}, {1542, 1807, 7}, {1552, 1811, 7}, {1566, 1804, 7}]]}
        }
	},


        [ARENA_ID_10] = {channels = {blue = 292, red = 293}, nextArena = ARENA_ID_11, maxLevel = 100, blueSpawn = {x = 4973, y = 966, z = 7}, redSpawn = {x = 4894, y = 966, z = 7}, exitPosition = {x = 4717, y = 143, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1630, 1575, 7}, {1631, 1564, 7}, {1636, 1570, 7}, {1653, 1565, 7}, {1667, 1560, 7}, {1678, 1564, 7}, {1687, 1577, 7}, {1691, 1578, 7}, {1696, 1570, 7}, {1692, 1564, 7}]]}
        }
	},
    [ARENA_ID_11] = {channels = {blue = 294, red = 295}, nextArena = ARENA_ID_12, maxLevel = 100, blueSpawn = {x = 4959, y = 1029, z = 6}, redSpawn = {x = 4895, y = 1085, z = 6}, exitPosition = {x = 4717, y = 143, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1632, 1689, 7}, {1640, 1692, 7}, {1642, 1678, 7}, {1649, 1663, 7}, {1666, 1665, 7}, {1663, 1671, 7}, {1679, 1645, 7}, {1680, 1631, 7}, {1702, 1641, 7}, {1706, 1634, 7}]]}
        }
	},
    [ARENA_ID_12] = {channels = {blue = 296, red = 297}, nextArena = ARENA_ID_10, maxLevel = 100, blueSpawn = {x = 4906, y = 1150, z = 7}, redSpawn = {x = 4971, y = 1216, z = 7}, exitPosition = {x = 4717, y = 143, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1629, 1754, 7}, {1649, 1756, 7}, {1656, 1741, 7}, {1668, 1763, 7}, {1659, 1788, 7}, {1674, 1785, 7}, {1686, 1781, 7}, {1683, 1808, 7}, {1692, 1807, 7}, {1695, 1791, 7}]]}
        }
	},


	[ARENA_ID_13] = {channels = {blue = 298, red = 299}, nextArena = ARENA_ID_14, maxLevel = 0, blueSpawn = {x = 5531, y = 970, z = 7}, redSpawn = {x = 5452, y = 970, z = 7}, exitPosition = {x = 4721, y = 139, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1769, 1564, 7}, {1768, 1575, 7}, {1780, 1562, 7}, {1793, 1564, 7}, {1807, 1553, 7}, {1814, 1565, 7}, {1816, 1564, 7}, {1821, 1546, 7}, {1794, 1544, 7}, {1830, 1564, 7}]]}
        }
	},
    [ARENA_ID_14] = {channels = {blue = 300, red = 301}, nextArena = ARENA_ID_15, maxLevel = 0, blueSpawn = {x = 5517, y = 1033, z = 6}, redSpawn = {x = 5453, y = 1089, z = 6}, exitPosition = {x = 4721, y = 139, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1778, 1692, 7}, {1780, 1678, 7}, {1794, 1664, 7}, {1813, 1657, 7}, {1817, 1645, 7}, {1827, 1643, 7}, {1840, 1641, 7}, {1839, 1629, 7}, {1818, 1632, 7}, {1813, 1657, 7}]]}
        }
	},
    [ARENA_ID_15] = {channels = {blue = 302, red = 303}, nextArena = ARENA_ID_13, maxLevel = 0, blueSpawn = {x = 5464, y = 1154, z = 7}, redSpawn = {x = 5529, y = 1220, z = 7}, exitPosition = {x = 4721, y = 139, z = 8},
		itemRaids = {
            items = {14750, 14751--[[, 14752,]]--[[, 14753,]], 14754, 14755, 14756, 14757, 14758, 14759, 14760, 14761, 14762, 14763, 14764, 14765},
            positions = {--[[{1775, 1754, 7}, {1781, 1756, 7}, {1783, 1744, 7}, {1802, 1744, 7}, {1805, 1763, 7}, {1794, 1780, 7}, {1807, 1776, 7}, {1825, 1779, 7}, {1815, 1797, 7}, {1821, 1808, 7}]]}
        }
	}
}

local LAST_EVENTS = {
	[ARENA_ID_1] = {WORKING = false},
	[ARENA_ID_2] = {WORKING = false},
	[ARENA_ID_3] = {WORKING = false},
	[ARENA_ID_4] = {WORKING = false},
	[ARENA_ID_5] = {WORKING = false},
	[ARENA_ID_6] = {WORKING = false},
	[ARENA_ID_7] = {WORKING = false},
	[ARENA_ID_8] = {WORKING = false},
	[ARENA_ID_9] = {WORKING = false},
	[ARENA_ID_10] = {WORKING = false},
	[ARENA_ID_11] = {WORKING = false},
	[ARENA_ID_12] = {WORKING = false},
	[ARENA_ID_13] = {WORKING = false},
	[ARENA_ID_14] = {WORKING = false},
	[ARENA_ID_15] = {WORKING = false},
}

local ACTION_IDS = {101, 102, 103, 104, 105}
local CURRENT_ARENAS_GLOBALSTORAGE = {
    [ACTION_IDS[1]] = 1100,
	[ACTION_IDS[2]] = 1101,
	[ACTION_IDS[3]] = 1102,
	[ACTION_IDS[4]] = 1103,
	[ACTION_IDS[5]] = 1104
}

function getPvpArenaByActionId(actionId)
	return getGlobalStorageValue(CURRENT_ARENAS_GLOBALSTORAGE[actionId])
end

function setPvpArenaByActionId(actionId, pvpArena)
    setGlobalStorageValue(CURRENT_ARENAS_GLOBALSTORAGE[actionId], pvpArena)
end

local function onPvpArenaThink(ticks)
    if (ticks >= 6) then -- 6 * 10 = 60 minutes
        local player
        for i, actionid in ipairs(ACTION_IDS) do
            local currentArena = getPvpArenaByActionId(actionid)
            local nextArena = ARENAS_CONFIG[currentArena].nextArena
            setPvpArenaByActionId(actionid, nextArena)

            local users = getPvpArenaUsers(currentArena)
            if (users) then
                for i, player in ipairs(users) do
                    local team = getPlayerPvpArenaTeam(player)
                    doPlayerSendTextMessage(player, MESSAGE_STATUS_WARNING, "End of round, next scenario!")
                    doPvpArenaLeave(player)
                    doRemoveCondition(player, CONDITION_INFIGHT)
                    doPvpArenaJoin(player, nextArena, team)
                end
            end
        end
        ticks = 0

    else
        for i, arena in ipairs(LAST_EVENTS) do
            if (arena.WORKING) then
                local users = getPvpArenaUsers(arena)
				if(users and #users >= 0) then
                    local player
                    for i, player in ipairs(users) do
                        doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_ORANGE, string.format(__L(player, "Scenario change in %s minutes!"), (6 - ticks) * 10))
                    end

                    local pos = table.random(ARENAS_CONFIG[i].itemRaids.positions)
                    if (doCreateItem(table.random(ARENAS_CONFIG[i].itemRaids.items), 1, {x = pos[1], y = pos[2], z = pos[3]})) then
                        doSendMagicEffect({x = pos[1], y = pos[2], z = pos[3]}, EFFECT_RED_BUFF)
                    end
                end
            end
        end
    end
	addEvent(onPvpArenaThink, PVPARENA_THINK_INTERVAL, ticks + 1)
end

function startPvpArenas()
	for i = 1, #ARENAS do
		local config = ARENAS_CONFIG[ARENAS[i]]
		if (doPvpArenaCreate(ARENAS[i], config.blueSpawn, config.redSpawn, config.exitPosition, config.maxLevel, config.channels.blue, config.channels.red)) then
			LAST_EVENTS[ARENAS[i]].WORKING = true
		else
			log(LOG_TYPES.ERROR, "startPvpArenas - Can't create arena", i)
		end
    end

    setPvpArenaByActionId(ACTION_IDS[1], ARENA_ID_1)
    setPvpArenaByActionId(ACTION_IDS[2], ARENA_ID_4)
    setPvpArenaByActionId(ACTION_IDS[3], ARENA_ID_7)
    setPvpArenaByActionId(ACTION_IDS[4], ARENA_ID_10)
    setPvpArenaByActionId(ACTION_IDS[5], ARENA_ID_13)

	addEvent(onPvpArenaThink, PVPARENA_THINK_INTERVAL, 0)
end
