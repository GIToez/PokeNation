if (Vitamin) then
    return
end

Vitamin = {}

-- Constants
VITAMIN_IDS = {}
VITAMIN_IDS.HP_UP = 0 -- HP
VITAMIN_IDS.PROTEIN = 1 -- Attack
VITAMIN_IDS.IRON = 2 -- Defense
VITAMIN_IDS.CALCIUM = 3 -- Special Attack
VITAMIN_IDS.ZINC = 4 -- Special Defense
VITAMIN_IDS.CARBOS = 5 -- Speed
VITAMIN_IDS.PP_UP = 6 -- Energy 1/3 3x
VITAMIN_IDS.PP_MAX = 7 -- Energy 1/5 1x

local MAX_TOTAL_APPLIES = 10
local MAX_SINGLE_APPLIES = 3
local VITAMIN_SLOT_PER_LEVEL = 10

local VITAMINS = {}
VITAMINS[VITAMIN_IDS.HP_UP] = {
    name = "HP Up",
    itemId = 23452,
    values = {0.05, 0.08, 0.10},
    getApplyCountFunction = getBallVitaminHpUp,
    setApplyCountFunction = setBallVitaminHpUp,
    onApply = function(cid, count)
        setMonsterVarPokeStat(cid, MONSTER_POKE_STATS.MAXHEALTH, VITAMINS[VITAMIN_IDS.HP_UP].values[count] or
                VITAMINS[VITAMIN_IDS.HP_UP].values[1])
    end,
    getDescription = function(count)
        return string.concat("+", (VITAMINS[VITAMIN_IDS.HP_UP].values[count] or VITAMINS[VITAMIN_IDS.HP_UP].values[1]) * 100,
            "% Max HP")
    end
}

VITAMINS[VITAMIN_IDS.PROTEIN] = {
    name = "Protein",
    itemId = 23456,
    values = {0.05, 0.08, 0.10},
    getApplyCountFunction = getBallVitaminProtein,
    setApplyCountFunction = setBallVitaminProtein,
    onApply = function(cid, count)
        setMonsterVarPokeStat(cid, MONSTER_POKE_STATS.ATTACK, VITAMINS[VITAMIN_IDS.PROTEIN].values[count] or
                VITAMINS[VITAMIN_IDS.PROTEIN].values[1])
    end,
    getDescription = function(count)
        return string.concat("+", (VITAMINS[VITAMIN_IDS.PROTEIN].values[count] or VITAMINS[VITAMIN_IDS.PROTEIN].values[1]) * 100,
            "% Attack")
    end
}

VITAMINS[VITAMIN_IDS.IRON] = {
    name = "Iron",
    itemId = 23453,
    values = {0.05, 0.08, 0.10},
    getApplyCountFunction = getBallVitaminIron,
    setApplyCountFunction = setBallVitaminIron,
    onApply = function(cid, count)
        setMonsterVarPokeStat(cid, MONSTER_POKE_STATS.DEFENSE, VITAMINS[VITAMIN_IDS.IRON].values[count] or
                VITAMINS[VITAMIN_IDS.IRON].values[1])
    end,
    getDescription = function(count)
        return string.concat("+", (VITAMINS[VITAMIN_IDS.IRON].values[count] or VITAMINS[VITAMIN_IDS.IRON].values[1]) * 100,
            "% Defense")
    end
}

VITAMINS[VITAMIN_IDS.CALCIUM] = {
    name = "Calcium",
    itemId = 23450,
    values = {0.05, 0.08, 0.10},
    getApplyCountFunction = getBallVitaminCalcium,
    setApplyCountFunction = setBallVitaminCalcium,
    onApply = function(cid, count)
        setMonsterVarPokeStat(cid, MONSTER_POKE_STATS.SPECIALATTACK, VITAMINS[VITAMIN_IDS.CALCIUM].values[count] or
                VITAMINS[VITAMIN_IDS.CALCIUM].values[1])
    end,
    getDescription = function(count)
        return string.concat("+", (VITAMINS[VITAMIN_IDS.CALCIUM].values[count] or VITAMINS[VITAMIN_IDS.CALCIUM].values[1]) * 100,
            "% Special Attack")
    end
}

VITAMINS[VITAMIN_IDS.ZINC] = {
    name = "Zinc",
    itemId = 23457,
    values = {0.05, 0.08, 0.10},
    getApplyCountFunction = getBallVitaminZinc,
    setApplyCountFunction = setBallVitaminZinc,
    onApply = function(cid, count)
        setMonsterVarPokeStat(cid, MONSTER_POKE_STATS.SPECIALDEFENSE, VITAMINS[VITAMIN_IDS.ZINC].values[count] or
                VITAMINS[VITAMIN_IDS.ZINC].values[1])
    end,
    getDescription = function(count)
        return string.concat("+", (VITAMINS[VITAMIN_IDS.CALCIUM].values[count] or VITAMINS[VITAMIN_IDS.CALCIUM].values[1]) * 100,
            "% Special Defense")
    end
}

VITAMINS[VITAMIN_IDS.CARBOS] = {
    name = "Carbos",
    itemId = 23451,
    values = {0.10, 0.16, 0.20},
    getApplyCountFunction = getBallVitaminCarbos,
    setApplyCountFunction = setBallVitaminCarbos,
    onApply = function(cid, count)
        setMonsterVarPokeStat(cid, MONSTER_POKE_STATS.SPEED, VITAMINS[VITAMIN_IDS.CARBOS].values[count] or
                VITAMINS[VITAMIN_IDS.CARBOS].values[1])
    end,
    getDescription = function(count)
        return string.concat("+", (VITAMINS[VITAMIN_IDS.CARBOS].values[count] or VITAMINS[VITAMIN_IDS.CARBOS].values[1]) * 100,
            "% Speed")
    end
}

VITAMINS[VITAMIN_IDS.PP_UP] = {
    name = "PP Up",
    itemId = 23455,
    values = {0.05, 0.08, 0.10},
    getApplyCountFunction = getBallVitaminPPUp,
    setApplyCountFunction = setBallVitaminPPUp,
    onApply = function(cid, count)
        setMonsterVarPokeStat(cid, MONSTER_POKE_STATS.MAXENERGY, VITAMINS[VITAMIN_IDS.PP_UP].values[count] or
                VITAMINS[VITAMIN_IDS.PP_UP].values[1])
    end,
    getDescription = function(count)
        return string.concat("+", (VITAMINS[VITAMIN_IDS.PP_UP].values[count] or VITAMINS[VITAMIN_IDS.PP_UP].values[1]) * 100,
            "% Max Energy")
    end
}

VITAMINS[VITAMIN_IDS.PP_MAX] = {
    name = "PP Max",
    itemId = 23454,
    maxApplies = 1,
    values = {0.10},
    getApplyCountFunction = getBallVitaminPPMax,
    setApplyCountFunction = setBallVitaminPPMax,
    onApply = function(cid, count)
        setMonsterVarPokeStat(cid, MONSTER_POKE_STATS.MAXENERGY, VITAMINS[VITAMIN_IDS.PP_MAX].values[1])
    end,
    getDescription = function(count)
        return string.concat("+", (VITAMINS[VITAMIN_IDS.PP_MAX].values[count] or VITAMINS[VITAMIN_IDS.PP_MAX].values[1]) * 100,
            "% Max Energy")
    end
}

local VITAMIN_BY_ITEMID = {}
for id, vitamin in pairs(VITAMINS) do
    VITAMIN_BY_ITEMID[vitamin.itemId] = id
end

-- Vars

-- Methods Local

-- Methods Global
Vitamin.getItemId = function(id)
    return VITAMINS[id] and VITAMINS[id].itemId or nil
end

Vitamin.getName = function(id)
    return VITAMINS[id] and VITAMINS[id].name or nil
end

Vitamin.onUse = function(cid, item, fromPosition, itemEx, toPosition)
    local vitaminId = VITAMIN_BY_ITEMID[item.itemid]
    if (not vitaminId or not isItem(itemEx) or not isBallWithPokemon(itemEx.uid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (isPokemonOnline(cid)) then
        doPlayerSendCancel(cid, "You can not do it while you have a Pokemon out of the ball.")
        return true

    elseif (fromPosition.x ~= CONTAINER_POSITION or toPosition.x ~= CONTAINER_POSITION) then -- TODO: This doesnt mean that the player is carring the item or no
        doPlayerSendCancel(cid, "You must pick up this item first.")
        return true

    elseif (getBallTotalVitamins(itemEx.uid) >= MAX_TOTAL_APPLIES) then
        doPlayerSendCancel(cid, string.format(__L(cid, "Your Pokemon has already received the maximum of %s total vitamins."), MAX_TOTAL_APPLIES))
        return true
    end

    local reqLevel = getBallTotalVitamins(itemEx.uid) * VITAMIN_SLOT_PER_LEVEL
    if (getBallPokemonLevel(itemEx.uid) < reqLevel) then
        doPlayerSendCancel(cid, string.format(__L(cid, "Your Pokemon need at least level %s to receive another vitamin."), reqLevel))
        return true
    end

    local vitamin = VITAMINS[vitaminId]
    if (not vitamin) then
        log(LOG_TYPES.ERROR, "Vitamin.onUse - Unknown vitaminId", getCreatureName(cid), item, fromPosition, itemEx,
            toPosition, vitaminId)
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local maxApplies = vitamin.maxApplies or MAX_SINGLE_APPLIES
    local currentApplies = vitamin.getApplyCountFunction(itemEx.uid)
    if (currentApplies >= maxApplies) then
        doPlayerSendCancel(cid, string.format(__L(cid, "Your Pokemon has already received the maximum of %s %s vitamin%s"), maxApplies, vitamin.name, (maxApplies > 1 and "s." or ".")))
        return true
    end

    currentApplies = currentApplies + 1
    vitamin.setApplyCountFunction(itemEx.uid, currentApplies)

    local total = getBallTotalVitamins(itemEx.uid) + 1
    setBallTotalVitamins(itemEx.uid, total)

    doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_BLUE)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Your Pokemon received the %s vitamin! Now he have got %s %s's (%s) and a total of %s vitamin%s"), vitamin.name, currentApplies, vitamin.name, vitamin.getDescription(currentApplies), total, (total > 1 and "s." or ".")))
    doRemoveItem(item.uid, 1)
    doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.USE_VITAMIN, 1)
    return true
end

Vitamin.onPokemonCall = function(pokemon, ball)
    for _, vitamin in pairs(VITAMINS) do
        local count = vitamin.getApplyCountFunction(ball.uid)
        if (count > 0) then
            vitamin.onApply(pokemon, count)
        end
    end
end

Vitamin.getBallDescription = function(uid)
    local r = {}

    for _, vitamin in pairs(VITAMINS) do
        local count = vitamin.getApplyCountFunction(uid)
        if (count > 0) then
            r[#r + 1] = count
            r[#r + 1] = "x "
            r[#r + 1] = vitamin.name
            r[#r + 1] = " ("
            r[#r + 1] = vitamin.getDescription(count)
            r[#r + 1] = ")"
            r[#r + 1] = ", "
        end
    end

    if (#r > 7) then
        r[#r - 7] = " and "
        r[#r] = "."
    elseif (#r == 0) then
        r[1] = "None."
    else
        r[#r] = "."
    end

    return table.concat(r)
end

Vitamin.doResetBall = function(ball)
    for _, vitamin in pairs(VITAMINS) do
        vitamin.setApplyCountFunction(ball.uid, nil, true)
    end
    setBallTotalVitamins(ball.uid, nil, true)
end