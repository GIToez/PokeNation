local DELIVERIES = {
    -- Pallet
    {
        {x = 3282, y = 815, z = 7},
        {x = 3290, y = 823, z = 7},
        {x = 3300, y = 825, z = 7},
        {x = 3317, y = 831, z = 7},
        {x = 3304, y = 813, z = 7},
    },
    -- Viridian
    {
        {x = 3290, y = 575, z = 7},
        {x = 3301, y = 581, z = 7},
        {x = 3273, y = 559, z = 7},
        {x = 3292, y = 548, z = 7},
        {x = 3317, y = 588, z = 7}
    },
    -- Pewter
    {
        {x = 3296, y = 277, z = 7},
        {x = 3321, y = 286, z = 7},
        {x = 3326, y = 302, z = 7},
        {x = 3310, y = 315, z = 7},
        {x = 3290, y = 296, z = 7},
    },
    -- Cerulean
    {
        {x = 3899, y = 275, z = 7},
        {x = 3930, y = 291, z = 7},
        {x = 3913, y = 332, z = 7},
        {x = 3858, y = 325, z = 7},
        {x = 3845, y = 295, z = 7}
    },
    -- Saffron
    {
        {x = 3927, y = 460, z = 7},
        {x = 3950, y = 461, z = 7},
        {x = 3970, y = 491, z = 7},
        {x = 3928, y = 508, z = 7},
        {x = 3914, y = 472, z = 7},
    },
    -- Celadon
    {
        {x = 3653, y = 415, z = 7},
        {x = 3704, y = 425, z = 7},
        {x = 3697, y = 459, z = 7},
        {x = 3653, y = 451, z = 7},
        {x = 3670, y = 440, z = 7},
    },
    -- Lavender
    {
        {x = 4199, y = 536, z = 7},
        {x = 4209, y = 563, z = 7},
        {x = 4200, y = 592, z = 7},
        {x = 4168, y = 587, z = 7},
        {x = 4171, y = 565, z = 7},
    },
    -- Vermilion
    {
        {x = 3946, y = 612, z = 7},
        {x = 3967, y = 610, z = 7},
        {x = 3993, y = 639, z = 7},
        {x = 3914, y = 653, z = 7},
        {x = 3910, y = 607, z = 7},
    },
    -- Fuchsia
    {
        {x = 3875, y = 814, z = 7},
        {x = 3898, y = 829, z = 7},
        {x = 3887, y = 858, z = 7},
        {x = 3864, y = 859, z = 7},
        {x = 3839, y = 828, z = 7},
    },
    -- Cinnabar
    {
        {x = 3352, y = 1019, z = 7},
        {x = 3385, y = 1017, z = 7},
        {x = 3390, y = 1038, z = 7},
        {x = 3360, y = 1057, z = 7},
        {x = 3337, y = 1036, z = 7},
    }
}

local SLEIGHS = {
    -- Pallet
    [{x = 3292, y = 794, z = 7}] = { deliveries = DELIVERIES[1], presentsStorage = 8629 },
    -- Viridian
    [{x = 3306, y = 563, z = 7}] = { deliveries = DELIVERIES[2], presentsStorage = 8630 },
    -- Pewter
    [{x = 3315, y = 300, z = 7}] = { deliveries = DELIVERIES[3], presentsStorage = 8631 },
    -- Cerulean
    [{x = 3892, y = 317, z = 7}] = { deliveries = DELIVERIES[4], presentsStorage = 8632 },
    -- Saffron
    [{x = 3916, y = 482, z = 7}] = { deliveries = DELIVERIES[5], presentsStorage = 8633 },
    -- Celadon
    [{x = 3691, y = 437, z = 7}] = { deliveries = DELIVERIES[6], presentsStorage = 8634 },
    -- Lavender
    [{x = 4198, y = 560, z = 7}] = { deliveries = DELIVERIES[7], presentsStorage = 8635 },
    -- Vermilion
    [{x = 3958, y = 643, z = 7}] = { deliveries = DELIVERIES[8], presentsStorage = 8636 },
    -- Fuchsia
    [{x = 3868, y = 846, z = 7}] = { deliveries = DELIVERIES[9], presentsStorage = 8637 },
    -- Cinnabar
    [{x = 3358, y = 1042, z = 7}] = { deliveries = DELIVERIES[10], presentsStorage = 8638 },
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, 8639) ~= QUEST_STATUS.STARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local sleigh = nil
    for k, v in pairs(SLEIGHS) do
        if (doComparePositions(fromPosition, k)) then
            sleigh = v
            break
        end
    end

    if (not sleigh) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
--        log(LOG_TYPES.ERROR, "Christmas Event Sleigh - Unknown sleigh position", getCreatureName(cid), item, fromPosition, itemEx, toPosition)
        return true
    end

    if (getCreatureStorage(cid, sleigh.presentsStorage) == QUEST_STATUS.FINISHED) then
        doPlayerSendCancel(cid, "You've already picked up the gifts from this sleigh.")
        return true
    end

    doCreatureSetStorage(cid, sleigh.presentsStorage, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 25262, 5, true, true)
    doSendMagicEffect(toPosition, EFFECT_FIREWORK_RED)

    for k, v in pairs(sleigh.deliveries) do
        doPlayerAddMapMark(cid, v, 0, "Christmas delivery position.")
    end

    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The deliveries positions were marked up on your map! Good luck!")
    return true
end
