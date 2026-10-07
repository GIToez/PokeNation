local ORIENTATIONS = {
    VERTICAL = 0,
    HORIZONTAL = 1
}

local GATE_ITEMID_BY_ORIENTATION = {
    [ORIENTATIONS.VERTICAL] = 9533,
    [ORIENTATIONS.HORIZONTAL] = 9485,
}

local MECHANISM_STATUS = {
    DOWN = 0,
    UP = 1
}

local MECHANISM = { -- Structure: [actionId] = {status = MECHANISM_STATUS.DOWN, orientation = VERTICAL/HORIZONTAL, gates = {{gate1.x, gate1.y, gate1.z}, {gate2.x, gate2.y, gate2.z}}}
    [100] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{3121, 987, 7}, {3121, 988, 7}, } },
    [101] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{3136, 999, 7}, {3136, 1000, 7}, } },
    [102] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{3140, 994, 7}, {3141, 994, 7}, } },
    [103] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{3158, 993, 7}, {3158, 994, 7}, } },
    [104] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{3165, 988, 7}, {3165, 989, 7}, } },
    [105] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{3158, 965, 7}, {3159, 965, 7}, {3160, 965, 7}, } },
    [106] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{3151, 959, 7}, {3151, 960, 7}, } },
    [107] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{3142, 963, 7}, {3143, 963, 7}, } },
    [108] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2983, 987, 7}, {2983, 988, 7}, } },
    [109] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2998, 999, 7}, {2998, 1000, 7}, } },
    [110] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{3002, 994, 7}, {3003, 994, 7}, } },
    [111] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{3020, 993, 7}, {3020, 994, 7}, } },
    [112] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{3027, 988, 7}, {3027, 989, 7}, } },
    [113] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{3020, 965, 7}, {3021, 965, 7}, {3022, 965, 7}, } },
    [114] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{3013, 959, 7}, {3013, 960, 7}, } },
    [115] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{3004, 963, 7}, {3005, 963, 7}, } },
    [116] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2846, 987, 7}, {2846, 988, 7}, } },
    [117] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2861, 999, 7}, {2861, 1000, 7}, } },
    [118] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2865, 994, 7}, {2866, 994, 7}, } },
    [119] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2883, 993, 7}, {2883, 993, 7}, } },
    [120] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2890, 988, 7}, {2890, 989, 7}, } },
    [121] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2883, 965, 7}, {2884, 965, 7}, {2885, 965, 7}, } },
    [122] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2876, 959, 7}, {2876, 960, 7}, } },
    [123] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2867, 963, 7}, {2868, 963, 7}, } },
    [124] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2708, 984, 7}, {2708, 985, 7}, } },
    [125] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2723, 996, 7}, {2723, 997, 7}, } },
    [126] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2727, 991, 7}, {2728, 991, 7}, } },
    [127] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2745, 990, 7}, {2745, 991, 7}, } },
    [128] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2752, 985, 7}, {2752, 986, 7}, } },
    [129] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2745, 962, 7}, {2746, 962, 7}, {2747, 962, 7}, } },
    [130] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2738, 956, 7}, {2738, 957, 7}, } },
    [131] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2729, 960, 7}, {2730, 960, 7}, } },
    [132] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2563, 983, 7}, {2563, 984, 7}, } },
    [133] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2578, 995, 7}, {2578, 996, 7}, } },
    [134] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2582, 990, 7}, {2583, 990, 7}, } },
    [135] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2600, 989, 7}, {2600, 990, 7}, } },
    [136] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2607, 984, 7}, {2607, 985, 7}, } },
    [137] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2600, 961, 7}, {2601, 961, 7}, {2602, 961, 7}, } },
    [138] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2593, 955, 7}, {2593, 956, 7}, } },
    [139] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2584, 959, 7}, {2585, 959, 7}, } },
    --[[
    [100] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2688, 894, 7}, {2688, 895, 7}}},
    [101] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2703, 906, 7}, {2703, 907, 7}}},
    [102] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2707, 901, 7}, {2708, 901, 7}}},
    [103] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2725, 900, 7}, {2725, 901, 7}}},
    [104] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2732, 895, 7}, {2732, 896, 7}}},
    [105] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2725, 872, 7}, {2726, 872, 7}, {2727, 872, 7}}},
    [106] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2718, 866, 7}, {2718, 867, 7}}},
    [107] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2709, 870, 7}, {2710, 870, 7}}},

    [108] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2550, 894, 7}, {2550, 895, 7}}},
    [109] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2565, 906, 7}, {2565, 907, 7}}},
    [110] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2569, 901, 7}, {2570, 901, 7}}},
    [111] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2587, 900, 7}, {2587, 901, 7}}},
    [112] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2594, 895, 7}, {2594, 896, 7}}},
    [113] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2587, 872, 7}, {2588, 872, 7}, {2589, 872, 7}}},
    [114] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2580, 866, 7}, {2580, 867, 7}}},
    [115] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2571, 870, 7}, {2572, 870, 7}}},

    [116] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2413, 894, 7}, {2413, 895, 7}}},
    [117] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2428, 906, 7}, {2428, 907, 7}}},
    [118] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2432, 901, 7}, {2433, 901, 7}}},
    [119] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2450, 900, 7}, {2450, 900, 7}}},
    [120] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2457, 895, 7}, {2457, 896, 7}}},
    [121] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2450, 872, 7}, {2451, 872, 7}, {2452, 872, 7}}},
    [122] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2443, 866, 7}, {2443, 867, 7}}},
    [123] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2434, 870, 7}, {2435, 870, 7}}},

    [124] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2275, 891, 7}, {2275, 892, 7}}},
    [125] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2290, 903, 7}, {2290, 904, 7}}},
    [126] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2294, 898, 7}, {2295, 898, 7}}},
    [127] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2312, 897, 7}, {2312, 898, 7}}},
    [128] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2319, 892, 7}, {2319, 893, 7}}},
    [129] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2312, 869, 7}, {2313, 869, 7}, {2314, 869, 7}}},
    [130] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2305, 863, 7}, {2305, 864, 7}}},
    [131] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2296, 867, 7}, {2297, 867, 7}}},

    [132] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2130, 890, 7}, {2130, 891, 7}}},
    [133] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2145, 902, 7}, {2145, 903, 7}}},
    [134] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2149, 897, 7}, {2150, 897, 7}}},
    [135] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2167, 896, 7}, {2167, 897, 7}}},
    [136] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2174, 891, 7}, {2174, 892, 7}}},
    [137] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2167, 868, 7}, {2168, 868, 7}, {2169, 868, 7}}},
    [138] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.VERTICAL, gates = {{2160, 862, 7}, {2160, 863, 7}}},
    [139] = {status = MECHANISM_STATUS.DOWN, orientation = ORIENTATIONS.HORIZONTAL, gates = {{2151, 866, 7}, {2152, 866, 7}}},
    ]]
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (isExhaust(cid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local mechanism = MECHANISM[item.actionid]
    if (mechanism) then
        if (mechanism.status == MECHANISM_STATUS.DOWN) then
            for i, gate in ipairs(mechanism.gates) do
                local pos = {x = gate[1], y = gate[2], z = gate[3]}
                doSendMagicEffect(pos, EFFECT_RED_BUFF)
                doRemoveItem(getTileItemById(pos, GATE_ITEMID_BY_ORIENTATION[mechanism.orientation]).uid)
            end
            mechanism.status = MECHANISM_STATUS.UP

        else
            for i, gate in ipairs(mechanism.gates) do
                local pos = {x = gate[1], y = gate[2], z = gate[3]}
                local cid = getTopCreature(pos).uid
                if (isCreature(cid)) then
                    doTeleportThing(cid, getClosestFreeTile(cid, pos))
                end
                doCreateItem(GATE_ITEMID_BY_ORIENTATION[mechanism.orientation], 1, pos)
                doSendMagicEffect(pos, EFFECT_RED_BUFF)
            end
            mechanism.status = MECHANISM_STATUS.DOWN
        end

        doSendMagicEffect(toPosition, EFFECT_RED_BUFF)
        doAddExhaust(cid)
    end

    return true
end
