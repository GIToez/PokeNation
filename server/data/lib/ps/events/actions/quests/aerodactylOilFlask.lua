local OIL_RECIPE_ITEMID = 10966
local OIL_RECIPE_ACTIONID = 100
local DESTINATION = { x = 3597, y = 2740, z = 13 }
local LEVER_ITEMID = 10044
local MODIFIED_LEVER_ITEMID = 10045
local LAST_LEVER_ACTIONID = 109
local EMPTY_FLASK_ITEMID = 18163
local OLD_AMBER_STORAGE = 8382

local nearbyChecks = {
    --{{x = 1010 - (1010 - 984), y = 2420 - (2420 - 2393), z = 13}, (1010 - 984) / 2, (2420 - 2393) / 2, false},
    doGenerateAreaCheckParams(3584, 3610, 2714, 2741, 13, false),
    doGenerateAreaCheckParams(3577, 3582, 2739, 2743, 13, false),
    doGenerateAreaCheckParams(3603, 3621, 2704, 2733, 14, false),
    doGenerateAreaCheckParams(3580, 3102, 2710, 2720, 14, false),
    doGenerateAreaCheckParams(3545, 3598, 2726, 2743, 14, false),
    doGenerateAreaCheckParams(3508, 3569, 2664, 2724, 14, false),
    doGenerateAreaCheckParams(3592, 3602, 2707, 2727, 15, false),
    doGenerateAreaCheckParams(3568, 3580, 2714, 2718, 15, false),
    doGenerateAreaCheckParams(3453, 3552, 2692, 2769, 15, false),
    doGenerateAreaCheckParams(3560, 3359, 2742, 2766, 12, false),
    doGenerateAreaCheckParams(3556, 3583, 2755, 2770, 11, false),
    --[[{{x = 3347, y = 2407, z = 13}, 13, 14, false},
    {{x = 3319, y = 2441, z = 11}, 14, 8, false},
    {{x = 3322, y = 2433, z = 12}, 12, 12, false},
    {{x = 3330, y = 2419, z = 12}, 3, 2, false},
    {{x = 3330, y = 2419, z = 12}, 3, 2, false},
    {{x = 3347, y = 2406, z = 12}, 13, 14, false},
    {{x = 3349, y = 2402, z = 14}, 22, 19, false},
    {{x = 3291, y = 2379, z = 14}, 34, 36, false},]]
}

local function hasPlayerNearbyQuest()
    for _, check in pairs(nearbyChecks) do
        local spec = getSpectators(check[1], check[2], check[3], check[4])
        if (spec) then
            for __, v in pairs(spec) do
                if (isPlayer(v)) then
                    return true
                end
            end
        end
    end

    return false
end

local function resetQuest()
    -- Remove monsters
    local checks = {
        { { x = 3569, y = 2762, z = 11 }, 14, 8, false },
        { { x = 3572, y = 2754, z = 12 }, 12, 12, false },
        { { x = 3580, y = 2740, z = 12 }, 3, 2, false },
        { { x = 3580, y = 2740, z = 12 }, 3, 2, false },
        { { x = 3597, y = 2727, z = 12 }, 13, 14, false },
        { { x = 3599, y = 2723, z = 14 }, 22, 19, false },
        { { x = 3541, y = 2700, z = 14 }, 34, 36, false },
    }

    for _, check in pairs(checks) do
        local spec = getSpectators(check[1], check[2], check[3], check[4])
        if (spec) then
            for __, v in pairs(spec) do
                doRemoveCreature(v)
            end
        end
    end

    -- Add electric walls
    for _, pos in pairs({ { x = 3597, y = 2723, z = 15 }, { x = 3598, y = 2723, z = 15 }, { x = 3578, y = 2758, z = 12 } }) do
        local item = getTileItemById(pos, 14811)
        if (not isItem(item)) then
            doCreateItem(14811, 1, pos)
        end
    end

    -- Shuffle levers
    local levers = {
        { x = 3595, y = 2725, z = 13 },
        { x = 3600, y = 2725, z = 13 },
        { x = 3596, y = 2715, z = 13 },
        { x = 3599, y = 2715, z = 13 },
        { x = 3613, y = 2705, z = 14 },
        { x = 3584, y = 2715, z = 14 },
        { x = 3584, y = 2718, z = 14 },
        { x = 3558, y = 2704, z = 14 },
        { x = 3549, y = 2681, z = 14 },
        { x = 3543, y = 2681, z = 14 },
        { x = 3546, y = 2685, z = 14 },
        { x = 3530, y = 2681, z = 14 },
        { x = 3524, y = 2681, z = 14 },
        { x = 3527, y = 2685, z = 14 },
        { x = 3536, y = 2664, z = 14 },
        { x = 3537, y = 2664, z = 14 },
        { x = 3512, y = 2690, z = 14 },
        { x = 3511, y = 2691, z = 14 },
        { x = 3511, y = 2720, z = 14 },
        { x = 3512, y = 2721, z = 14 },
        { x = 3547, y = 2729, z = 14 },
        { x = 3547, y = 2733, z = 14 },
        { x = 3528, y = 2696, z = 15 },
        { x = 3528, y = 2697, z = 15 },
        { x = 3528, y = 2765, z = 15 },
        { x = 3528, y = 2766, z = 15 },
        { x = 3497, y = 2706, z = 15 },
        { x = 3497, y = 2756, z = 15 },
        { x = 3479, y = 2717, z = 15 },
        { x = 3479, y = 2745, z = 15 },
        { x = 3453, y = 2731, z = 15 },
    }

    for _, pos in pairs(levers) do
        local item = getTileItemById(pos, MODIFIED_LEVER_ITEMID)
        if (isItem(item)) then
            doTransformItem(item.uid, LEVER_ITEMID)
        end
    end

    for i = 1, #levers do -- Random aids
        local r = getRandom(1, #levers)
        local item = getTileItemById(levers[r], LEVER_ITEMID)
        if (isItem(item)) then
            doItemSetAttribute(item.uid, "aid", LAST_LEVER_ACTIONID + i)
        end
        table.remove(levers, r)
    end

    -- Create Boss
    doCreateMonster("Guardian Kabutops", { x = 3578, y = 2754, z = 12 })

    -- Pull flames on
    local flames = {
        { x = 3556, y = 2728, z = 14 },
        { x = 3556, y = 2734, z = 14 },
        { x = 3553, y = 2727, z = 14 },
        { x = 3553, y = 2735, z = 14 },
        { x = 3550, y = 2728, z = 14 },
        { x = 3550, y = 2734, z = 14 },
    }

    for _, pos in pairs(flames) do
        if (not isItem(getTileItemById(pos, 18763))) then
            doCreateItem(18763, 1, pos)
        end
    end
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx) or itemEx.itemid ~= OIL_RECIPE_ITEMID or itemEx.actionid ~= OIL_RECIPE_ACTIONID or
            getCreatureStorage(cid, OLD_AMBER_STORAGE) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (hasPlayerNearbyQuest()) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "There are players at this room right now, please try again later.")
        return true
    end

    resetQuest()
    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(fromPosition, EFFECT_POISON_GAS)
    doTeleportThing(cid, DESTINATION)
    doSendMagicEffect(toPosition, EFFECT_POISON_GAS)
    doTransformItem(item.uid, EMPTY_FLASK_ITEMID)
    setPlayerBlockLogout(cid, true)
    return true
end
