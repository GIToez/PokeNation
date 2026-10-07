local MAGIC_POTIONS = {}

-- Impetus Potion
local IMPETUS_SPEED_CONDITION = createConditionObject(CONDITION_HASTE, 120 * 60 * 1000, -1, CONDITION_SUBID.HASTE.MAGIC_POTION)
setConditionParam(IMPETUS_SPEED_CONDITION, CONDITION_PARAM_SPEED, 120)

MAGIC_POTIONS[27944] = {
    canUse = function(cid, itemEx)
        return itemEx == cid and not getCreatureCondition(cid, CONDITION_HASTE, CONDITION_SUBID.HASTE.MAGIC_POTION)
    end,
    onUse = function(cid, itemEx)
        doAddCondition(cid, IMPETUS_SPEED_CONDITION)
    end
}

-- Gallantry Potion
local GALLANTRY_EXTRA_ATK_CONDITION = createConditionObject(CONDITION_EXTRASPATK, 120 * 60 * 1000, -1, CONDITION_SUBID.EXTRA_SPATK.MAGIC_POTION)
setConditionParam(GALLANTRY_EXTRA_ATK_CONDITION, CONDITION_PARAM_LIGHT_LEVEL, 100)

MAGIC_POTIONS[27943] = {
    canUse = function(cid, itemEx)
        return isPokemon(itemEx) and not getCreatureCondition(itemEx, CONDITION_EXTRASPATK, CONDITION_SUBID.EXTRA_SPATK.MAGIC_POTION)
    end,
    onUse = function(cid, itemEx)
        doAddCondition(itemEx, GALLANTRY_EXTRA_ATK_CONDITION)
    end
}

-- Resistor Potion
local RESISTOR_EXTRA_DEF_CONDITION = createConditionObject(CONDITION_EXTRASPDEF, 120 * 60 * 1000, -1, CONDITION_SUBID.EXTRA_SPDEF.MAGIC_POTION)
setConditionParam(RESISTOR_EXTRA_DEF_CONDITION, CONDITION_PARAM_LIGHT_LEVEL, 100)

MAGIC_POTIONS[27948] = {
    canUse = function(cid, itemEx)
        return isPokemon(itemEx) and not getCreatureCondition(itemEx, CONDITION_EXTRASPDEF, CONDITION_SUBID.EXTRA_SPDEF.MAGIC_POTION)
    end,
    onUse = function(cid, itemEx)
        doAddCondition(itemEx, RESISTOR_EXTRA_DEF_CONDITION)
    end
}

-- Diablerie Potion
local DIABLERIE_EXTRA_ATK_CONDITION = createConditionObject(CONDITION_EXTRASPATK, 120 * 60 * 1000, -1, CONDITION_SUBID.EXTRA_SPATK.MAGIC_POTION)
setConditionParam(DIABLERIE_EXTRA_ATK_CONDITION, CONDITION_PARAM_LIGHT_LEVEL, 100)

MAGIC_POTIONS[27942] = {
    canUse = function(cid, itemEx)
        return isPokemon(itemEx) and not getCreatureCondition(itemEx, CONDITION_EXTRASPATK, CONDITION_SUBID.EXTRA_SPATK.MAGIC_POTION)
    end,
    onUse = function(cid, itemEx)
        doAddCondition(itemEx, DIABLERIE_EXTRA_ATK_CONDITION)
    end
}

-- Patronage Potion
local PATRONAGE_EXTRA_DEF_CONDITION = createConditionObject(CONDITION_EXTRASPDEF, 120 * 60 * 1000, -1, CONDITION_SUBID.EXTRA_SPDEF.MAGIC_POTION)
setConditionParam(PATRONAGE_EXTRA_DEF_CONDITION, CONDITION_PARAM_LIGHT_LEVEL, 100)

MAGIC_POTIONS[27946] = {
    canUse = function(cid, itemEx)
        return isPokemon(itemEx) and not getCreatureCondition(itemEx, CONDITION_EXTRASPDEF, CONDITION_SUBID.EXTRA_SPDEF.MAGIC_POTION)
    end,
    onUse = function(cid, itemEx)
        doAddCondition(itemEx, PATRONAGE_EXTRA_DEF_CONDITION)
    end
}

-- Momentum Potion
local MOMENTUM_REGEN_CONDITION = createConditionObject(CONDITION_REGENERATION, 180 * 60 * 1000, false, CONDITION_SUBID.REGENERATION.ENERGY)
setConditionParam(MOMENTUM_REGEN_CONDITION, CONDITION_PARAM_MANAGAIN, 30)
setConditionParam(MOMENTUM_REGEN_CONDITION, CONDITION_PARAM_MANATICKS, 2000)

MAGIC_POTIONS[27945] = {
    canUse = function(cid, itemEx)
        return isPokemon(itemEx) and not getCreatureCondition(itemEx, CONDITION_REGENERATION, CONDITION_SUBID.REGENERATION.ENERGY)
    end,
    onUse = function(cid, itemEx)
        doAddCondition(itemEx, MOMENTUM_REGEN_CONDITION)
    end
}

-- Pulse Potion
local PULSE_REGEN_CONDITION = createConditionObject(CONDITION_REGENERATION, 180 * 60 * 1000)
setConditionParam(PULSE_REGEN_CONDITION, CONDITION_PARAM_HEALTHGAIN, 30)
setConditionParam(PULSE_REGEN_CONDITION, CONDITION_PARAM_HEALTHTICKS, 2000)

MAGIC_POTIONS[27947] = {
    canUse = function(cid, itemEx)
        return isPokemon(itemEx) and not getCreatureCondition(itemEx, CONDITION_REGENERATION)
    end,
    onUse = function(cid, itemEx)
        doAddCondition(itemEx, PULSE_REGEN_CONDITION)
    end
}

-- Sense
MAGIC_POTIONS[27949] = {
    canUse = function(cid, itemEx)
        return itemEx == cid and getPlayerExtraExpRate(cid) <= 0
    end,
    onUse = function(cid, itemEx)
        doExtraExpRateStart(cid, 180 * 60, 0.35)
    end
}

-- Vigilance Potion
local VIGILANCE_INSOMNIA_CONDITION = createConditionObject(CONDITION_CUSTOM, 180 * 60 * 1000, false, CONDITION_SUBID.CUSTOM.INSONIA)
setConditionParam(VIGILANCE_INSOMNIA_CONDITION, CONDITION_PARAM_EFFECTTICKS, 5000)
setConditionParam(VIGILANCE_INSOMNIA_CONDITION, CONDITION_PARAM_LIGHT_LEVEL, 39) -- Effect Type

MAGIC_POTIONS[27950] = {
    canUse = function(cid, itemEx)
        return isPokemon(itemEx) and not getCreatureCondition(itemEx, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.INSONIA)
    end,
    onUse = function(cid, itemEx)
        doAddCondition(itemEx, VIGILANCE_INSOMNIA_CONDITION)
    end
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local magicPotion = MAGIC_POTIONS[item.itemid]
    if (not magicPotion) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local playerPosition = getCreaturePosition(cid)
    if (getDistanceBetween(playerPosition, toPosition) > 4) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
        return true
    end

    if (itemEx.uid ~= cid and getCreatureMaster(itemEx.uid) ~= cid) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (not magicPotion.canUse(cid, itemEx.uid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    magicPotion.onUse(cid, itemEx.uid)
    doSendMagicEffect(toPosition, table.random({ EFFECT_POISON_EXPLODE, EFFECT_ENERGY_EXPLODE, EFFECT_BLUE_BUFF, EFFECT_RED_BUFF, EFFECT_GREEN_BUFF }))
    doSendDistanceShoot(playerPosition, toPosition, PROJECTILE_GRAVEL)
    doRemoveItem(item.uid, 1)
    return true
end
