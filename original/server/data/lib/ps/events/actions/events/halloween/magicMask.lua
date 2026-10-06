local OUTFIT_CHARCULLA = createConditionObject(CONDITION_OUTFIT, 5 * 60 * 1000, nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_CHARCULLA, { lookType = 1724 })

local OUTFIT_CURSED_GENGAR_1 = createConditionObject(CONDITION_OUTFIT, 5 * 60 * 1000, nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_CURSED_GENGAR_1, { lookType = 1725 })

local OUTFIT_CURSED_GENGAR_2 = createConditionObject(CONDITION_OUTFIT, 5 * 60 * 1000, nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_CURSED_GENGAR_2, { lookType = 1726 })

local OUTFIT_CURSED_GENGAR_3 = createConditionObject(CONDITION_OUTFIT, 5 * 60 * 1000, nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_CURSED_GENGAR_3, { lookType = 1727 })

local OUTFIT_DARKEON = createConditionObject(CONDITION_OUTFIT, 5 * 60 * 1000, nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_DARKEON, { lookType = 1728 })

local OUTFIT_MASKMAR = createConditionObject(CONDITION_OUTFIT, 5 * 60 * 1000, nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_MASKMAR, { lookType = 1729 })

local OUTFIT_WHITE_GENGAR = createConditionObject(CONDITION_OUTFIT, 5 * 60 * 1000, nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_WHITE_GENGAR, { lookType = 1730 })

local CONDITIONS = { OUTFIT_CHARCULLA, OUTFIT_CURSED_GENGAR_1, OUTFIT_CURSED_GENGAR_2, OUTFIT_CURSED_GENGAR_3, OUTFIT_DARKEON, OUTFIT_MASKMAR, OUTFIT_WHITE_GENGAR }

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getPlayerMounted(cid) or isBiking(cid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    local currentDate = os.time()
    local machineInterval = getCreatureStorage(cid, playersStorages.lastMagicMaskUse) or currentDate
    local remaingTime = machineInterval - currentDate

    if (remaingTime > 0) then
        doPlayerSendCancel(cid, string.format(__L(cid, "You must wait %s to use the mask again."), table.concat(string.timediff(remaingTime, cid))))
        return true
    end

    if (getCreatureCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.HALLOWEEN)) then
        doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.HALLOWEEN)
    end

    doAddCondition(cid, table.random(CONDITIONS))
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_POISON_GAS_TWO)
    doCreatureSetStorage(cid, playersStorages.lastMagicMaskUse, os.time() + (10 * 60))

    return true
end
