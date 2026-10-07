if (PokemonHeldItem) then
    return
end

PokemonHeldItem = {}

-- Constants
HELD_IDS = {}
HELD_IDS.BLACK_BELT = 0
HELD_IDS.BLACK_GLASSES = 1
HELD_IDS.CHARCOAL = 2
HELD_IDS.DRAGON_FANG = 3
HELD_IDS.HARD_STONE = 4
HELD_IDS.MAGNET = 5
HELD_IDS.METAL_COAT = 6
HELD_IDS.MIRACLE_SEED = 7
HELD_IDS.MYSTIC_WATER = 8
HELD_IDS.NEVER_MELT_ICE = 9
HELD_IDS.PINK_BOW = 10
HELD_IDS.POISON_BARB = 11
HELD_IDS.POLKADOT_BOW = 12
HELD_IDS.SHARP_BEAK = 13
HELD_IDS.SILK_SCARF = 14
HELD_IDS.SILVER_POWDER = 15
HELD_IDS.SOFT_SAND = 16
HELD_IDS.SPELL_TAG = 17
HELD_IDS.TWISTED_SPOON = 18
HELD_IDS.ELEMENTAL_STONE = 19

local MAX_LEVEL = 7

local EXP_TABLE = {
    getExperienceForLevel(20), getExperienceForLevel(30), getExperienceForLevel(40), getExperienceForLevel(50),
    getExperienceForLevel(55), getExperienceForLevel(60), getExperienceForLevel(65)
}

local HELDS = {}
HELDS[HELD_IDS.BLACK_BELT] = {
    name = "Black Belt",
    itemId = 23513,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.BLACK_BELT].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_FIGHT)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.BLACK_BELT].name, " +",
            HELDS[HELD_IDS.BLACK_BELT].values[level], "%")
    end
}

HELDS[HELD_IDS.BLACK_GLASSES] = {
    name = "Black Glasses",
    itemId = 23514,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.BLACK_GLASSES].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_DARK)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.BLACK_GLASSES].name, " +",
            HELDS[HELD_IDS.BLACK_GLASSES].values[level], "%")
    end
}

HELDS[HELD_IDS.CHARCOAL] = {
    name = "Charcoal",
    itemId = 23515,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.CHARCOAL].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_FIRE)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.CHARCOAL].name, " +",
            HELDS[HELD_IDS.CHARCOAL].values[level], "%")
    end
}

HELDS[HELD_IDS.DRAGON_FANG] = {
    name = "Dragon Fang",
    itemId = 23516,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.DRAGON_FANG].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_FIRE)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.DRAGON_FANG].name, " +",
            HELDS[HELD_IDS.DRAGON_FANG].values[level], "%")
    end
}

HELDS[HELD_IDS.HARD_STONE] = {
    name = "Hard Stone",
    itemId = 23517,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.HARD_STONE].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_ROCK)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.HARD_STONE].name, " +",
            HELDS[HELD_IDS.HARD_STONE].values[level], "%")
    end
}

HELDS[HELD_IDS.MAGNET] = {
    name = "Magnet",
    itemId = 23518,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.MAGNET].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_ELECTRIC)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.MAGNET].name, " +",
            HELDS[HELD_IDS.MAGNET].values[level], "%")
    end
}

HELDS[HELD_IDS.METAL_COAT] = {
    name = "Metal Coat",
    itemId = 23519,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.METAL_COAT].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_STEEL)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.METAL_COAT].name, " +",
            HELDS[HELD_IDS.METAL_COAT].values[level], "%")
    end
}

HELDS[HELD_IDS.MIRACLE_SEED] = {
    name = "Miracle Seed",
    itemId = 23520,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.MIRACLE_SEED].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_GRASS)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.MIRACLE_SEED].name, " +",
            HELDS[HELD_IDS.MIRACLE_SEED].values[level], "%")
    end
}

HELDS[HELD_IDS.MYSTIC_WATER] = {
    name = "Mystic Water",
    itemId = 23521,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.MYSTIC_WATER].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_WATER)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.MYSTIC_WATER].name, " +",
            HELDS[HELD_IDS.MYSTIC_WATER].values[level], "%")
    end
}

HELDS[HELD_IDS.NEVER_MELT_ICE] = {
    name = "Never Melt Ice",
    itemId = 23522,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.NEVER_MELT_ICE].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_ICE)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.NEVER_MELT_ICE].name, " +",
            HELDS[HELD_IDS.NEVER_MELT_ICE].values[level], "%")
    end
}

HELDS[HELD_IDS.PINK_BOW] = {
    name = "Pink Bow",
    itemId = 23523,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.PINK_BOW].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_FAIRY)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.PINK_BOW].name, " +",
            HELDS[HELD_IDS.PINK_BOW].values[level], "%")
    end
}

HELDS[HELD_IDS.POISON_BARB] = {
    name = "Poison Barb",
    itemId = 23524,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.POISON_BARB].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_POISON)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.POISON_BARB].name, " +",
            HELDS[HELD_IDS.POISON_BARB].values[level], "%")
    end
}

HELDS[HELD_IDS.POLKADOT_BOW] = {
    name = "Polkadot Bow",
    itemId = 23525,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        -- Unused Held
        --setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.POLKADOT_BOW].values[level])
        --setPokemonHeldMovePowerType(cid, ELEMENT_NORMAL)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.POLKADOT_BOW].name, " +",
            HELDS[HELD_IDS.POLKADOT_BOW].values[level], "%")
    end
}

HELDS[HELD_IDS.SHARP_BEAK] = {
    name = "Sharp Beak",
    itemId = 23526,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.SHARP_BEAK].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_FLYING)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.SHARP_BEAK].name, " +",
            HELDS[HELD_IDS.SHARP_BEAK].values[level], "%")
    end
}

HELDS[HELD_IDS.SILK_SCARF] = {
    name = "Silk Scarf",
    itemId = 23527,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.SILK_SCARF].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_NORMAL)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.SILK_SCARF].name, " +",
            HELDS[HELD_IDS.SILK_SCARF].values[level], "%")
    end
}

HELDS[HELD_IDS.SILVER_POWDER] = {
    name = "Silver Powder",
    itemId = 23528,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.SILVER_POWDER].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_BUG)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.SILVER_POWDER].name, " +",
            HELDS[HELD_IDS.SILVER_POWDER].values[level], "%")
    end
}

HELDS[HELD_IDS.SOFT_SAND] = {
    name = "Soft Sand",
    itemId = 23529,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.SOFT_SAND].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_GROUND)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.SOFT_SAND].name, " +",
            HELDS[HELD_IDS.SOFT_SAND].values[level], "%")
    end
}

HELDS[HELD_IDS.SPELL_TAG] = {
    name = "Spell Tag",
    itemId = 23530,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.SPELL_TAG].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_GHOST)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.SPELL_TAG].name, " +",
            HELDS[HELD_IDS.SPELL_TAG].values[level], "%")
    end
}

HELDS[HELD_IDS.TWISTED_SPOON] = {
    name = "Twisted Spoon",
    itemId = 23531,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.TWISTED_SPOON].values[level])
        setPokemonHeldMovePowerType(cid, ELEMENT_PSYCHIC)
    end,
    getDescription = function(uid)
        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.TWISTED_SPOON].name, " +",
            HELDS[HELD_IDS.TWISTED_SPOON].values[level], "%")
    end
}

HELDS[HELD_IDS.ELEMENTAL_STONE] = {
    name = "Elemental Stone",
    itemId = 25048,
    values = {5, 7, 10, 13, 15, 18, 20},
    onApply = function(cid, level, ballUid)
        setPokemonHeldMovePowerModifier(cid, HELDS[HELD_IDS.ELEMENTAL_STONE].values[level])

        local heldVariables = getBallHeldVariables(ballUid)
        if (not heldVariables or not isString(heldVariables)) then
            return
        end

        local elements = string.explode(heldVariables, ";")
        for slot, v in pairs(elements) do
            setPokemonHeldMovePowerType(cid, tonumber(v), slot) -- todo
        end
    end,
    getDescription = function(uid)
        local str = {}
        local heldVariables = getBallHeldVariables(uid)
        if (heldVariables and isString(heldVariables)) then
            for slot, type in pairs(string.explode(heldVariables, ";")) do
                type = tonumber(type)
                str[#str + 1] = ELEMENT_NAMES[type]
                str[#str + 1] = " / "
            end
            str[#str] = nil
        end

        local level = getBallHeldLevel(uid)
        return string.concat("Level ", level, " ", HELDS[HELD_IDS.ELEMENTAL_STONE].name, " +",
            HELDS[HELD_IDS.ELEMENTAL_STONE].values[level], "% ", table.concat(str))
    end,
    onInstall = function(ballUid, heldUid)
        local vars = {}
        local slot1 = getItemAttribute(heldUid, ITEM_ATTRIBUTES.ELEMENTAL_STONE_SLOT1)
        if (slot1) then
            vars[#vars + 1] = slot1
            vars[#vars + 1] = ";"
        end
        
        local slot2 = getItemAttribute(heldUid, ITEM_ATTRIBUTES.ELEMENTAL_STONE_SLOT2)
        if (slot2) then
            vars[#vars + 1] = slot2
            vars[#vars + 1] = ";"
        end
        
        vars[#vars] = nil
        setBallHeldVariables(ballUid, tostring(table.concat(vars)))
    end,
    getName = function(ballUid)
        local str = {"Elemental Stone (" }
        local heldVariables = getBallHeldVariables(ballUid)
        if (heldVariables and isString(heldVariables)) then
            for slot, type in pairs(string.explode(heldVariables, ";")) do
                type = tonumber(type)
                str[#str + 1] = ELEMENT_NAMES[type]
                str[#str + 1] = " / "
            end
            str[#str] = ")"
        end
        return table.concat(str)
    end,
    canInstall = function(ballUid, heldUid)
        return getItemAttribute(heldUid, ITEM_ATTRIBUTES.ELEMENTAL_STONE_SLOT1)
    end
}

local HELD_BY_ITEMID = {}
for id, held in pairs(HELDS) do
    HELD_BY_ITEMID[held.itemId] = id
end

local FIRST_ELEMENTAL_STONE = 24724
local LAST_ELEMENTAL_STONE = 25047
for i = FIRST_ELEMENTAL_STONE, LAST_ELEMENTAL_STONE do -- Ugly hack
    HELD_BY_ITEMID[i] = HELD_IDS.ELEMENTAL_STONE
end

-- Vars

-- Local

-- Global
PokemonHeldItem.getHeldItemId = function(heldId)
    return HELDS[heldId] and HELDS[heldId].itemId or nil
end

PokemonHeldItem.getHeldName = function(heldId, ballUid)
    if (not HELDS[heldId]) then
        return nil
    end

    if (ballUid and HELDS[heldId].getName) then
        return HELDS[heldId].getName(ballUid)
    end

    return HELDS[heldId].name
end

PokemonHeldItem.onGainExperience = function(player, pokemon, ball, expAmount)
    if (expAmount < 1) then
        return
    end

    local heldId = getBallHeld(ball.uid)
    if (not heldId) then
        return
    end

    local currentLevel = getBallHeldLevel(ball.uid)
    if (currentLevel >= MAX_LEVEL) then
        return
    end

    local oldExperience = getBallHeldExperience(ball.uid)
    local newExperience = oldExperience + expAmount
    local nextLevelExp = EXP_TABLE[currentLevel]--((50 * (currentLevel) * (currentLevel) * (currentLevel)) - (150 * (currentLevel) * (currentLevel)) + (400 * (currentLevel))) / 3
    local gainLevel = 0

    setBallHeldExperience(ball.uid, newExperience)

    while (newExperience >= nextLevelExp) do
        gainLevel = gainLevel + 1
        nextLevelExp = EXP_TABLE[currentLevel + gainLevel]--((50 * (currentLevel + gainLevel) * (currentLevel + gainLevel) * (currentLevel + gainLevel)) - (150 * (currentLevel + gainLevel) * (currentLevel + gainLevel)) + (400 * (currentLevel + gainLevel))) / 3
    end

    if ((gainLevel + currentLevel) > MAX_LEVEL) then
        gainLevel = MAX_LEVEL - currentLevel
    end

    if (gainLevel > 0) then
        local pokemonPosition = getCreaturePosition(pokemon and pokemon or player)
        local pokemonNickname = getBallPokemonNickname(ball.uid)
        local newLevel = currentLevel + gainLevel

        if (pokemonNickname ~= nil and pokemonNickname ~= -1) then
            doPlayerSendTextMessage(player, MESSAGE_EVENT_ADVANCE,
                string.format(__L(player, "Congratulations! Your %s held item advanced from level %s to level %s."), pokemonNickname, currentLevel, newLevel))
        else
            doPlayerSendTextMessage(player, MESSAGE_EVENT_ADVANCE,
                string.format(__L(player, "Congratulations! Your %s held item advanced from level %s to level %s."), getBallPokemonName(ball.uid), currentLevel, newLevel))
        end

        doSendMagicEffect(pokemonPosition, EFFECT_GREEN_BUFF)
        doSendMagicEffect(pokemonPosition, EFFECT_LEVEL_UP)

        setBallHeldLevel(ball.uid, newLevel)
        if (pokemon) then
            HELDS[heldId].onApply(pokemon, newLevel, ball.uid)
        end
    end
end

PokemonHeldItem.onUse = function(cid, item, fromPosition, itemEx, toPosition)
    local heldId = HELD_BY_ITEMID[item.itemid]
    if (not heldId or not isItem(itemEx) or not isBallWithPokemon(itemEx.uid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true

    elseif (isPokemonOnline(cid)) then
        doPlayerSendCancel(cid, "You can not do it while you have a Pokemon out of the ball.")
        return true

    elseif (fromPosition.x ~= CONTAINER_POSITION or toPosition.x ~= CONTAINER_POSITION) then -- TODO: This doesnt mean that the player is carring the item or no
        doPlayerSendCancel(cid, "You must pick up this item first.")
        return true

    elseif (getBallHeld(itemEx.uid)) then
        doPlayerSendCancel(cid, "Your Pokemon already have got a Held Item.")
        return true
    end

    local held = HELDS[heldId]
    if (not held) then
        log(LOG_TYPES.ERROR, "PokemonHeldItem.onUse - Unknown heldId", getCreatureName(cid), item, fromPosition,
            itemEx, toPosition, heldId)
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (held.canInstall and not held.canInstall(itemEx.uid, item.uid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    setBallHeld(itemEx.uid, heldId)
    setBallHeldExperience(itemEx.uid, 0)
    setBallHeldLevel(itemEx.uid, 1)
    
    if (held.onInstall) then
        held.onInstall(itemEx.uid, item.uid)
    end
    
    doBallUpdateDescription(itemEx.uid)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_BLUE)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Your Pokemon received the %s held item!"), held.name))
    doRemoveItem(item.uid, 1)
    return true
end

PokemonHeldItem.getMovePowerModifier = function(cid, moveType)
    local continue = nil
    for slot = 1, 2 do
        local type = getPokemonHeldMovePowerType(cid, slot)
        if (type ~= EMPTY_STORAGE and type == moveType) then
            continue = true
        end
    end

    if (continue) then
        return 1 + (getPokemonHeldMovePowerModifier(cid) / 100)
    end

    return 1
end

PokemonHeldItem.onPokemonCall = function(pokemon, ball)
    local heldId = getBallHeld(ball.uid)
    if (not heldId) then
        return
    end

    if (not HELDS[heldId]) then
        log(LOG_TYPES.ERROR, "PokemonHeldItem.onPokemonCall - Unknown heldId", heldId,
            getCreatureName(getCreatureMaster(pokemon)))
        return
    end

    HELDS[heldId].onApply(pokemon, getBallHeldLevel(ball.uid), ball.uid)
end

PokemonHeldItem.getBallDescription = function(uid)
    local heldId = getBallHeld(uid)
    if (not heldId) then
        return "None."
    end

    if (not HELDS[heldId]) then
        log(LOG_TYPES.ERROR, "PokemonHeldItem.getBallDescription - Unknown heldId", heldId)
        return "None."
    end

    return HELDS[heldId].getDescription(uid)
end

PokemonHeldItem.doResetBall = function(ball, cid)
    local heldId = getBallHeld(ball.uid)
    if (heldId and heldId == HELD_IDS.ELEMENTAL_STONE) then
        local heldVariables = getBallHeldVariables(ball.uid)
        if (heldVariables and isString(heldVariables)) then
            for slot, type in pairs(string.explode(heldVariables, ";")) do
                type = tonumber(type)
                doPlayerSafeAddItem(cid, PLATE_ITEMID_BY_TYPE[type], 1, true)
            end
        end
    end

    setBallHeld(ball.uid, nil, true)
    setBallHeldLevel(ball.uid, 0)
    setBallHeldExperience(ball.uid, 0)
    setBallHeldVariables(ball.uid, "")
    doBallUpdateDescription(ball.uid)
end

PokemonHeldItem.doSendPlayerExpMessage = function(cid)
    local ball = getPlayerBall(cid)

    if (not isItem(ball)) then
        doPlayerSendCancel(cid, "First get your Pokemon ball at the right slot.")

    elseif (not getBallHeld(ball.uid)) then
        doPlayerSendCancel(cid, "Your Pokemon doesn't have a Held item.")

    else
        local heldLevel = getBallHeldLevel(ball.uid)
        local heldExperience = getBallHeldExperience(ball.uid)
        local totalExpToNextLevel = EXP_TABLE[heldLevel] and EXP_TABLE[heldLevel] or 0
        local totalExpToCurrentLevel = EXP_TABLE[heldLevel - 1] and EXP_TABLE[heldLevel - 1] or 0

        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Your Pokemon Held item is at level %s and has %s experience points, he needs more %s(%s%%) experience points to advance to level %s."), heldLevel, heldExperience, (totalExpToNextLevel - heldExperience), 100 - math.ceil((heldExperience - totalExpToCurrentLevel) / ((totalExpToNextLevel - totalExpToCurrentLevel) / 100)), heldLevel + 1))
    end
end