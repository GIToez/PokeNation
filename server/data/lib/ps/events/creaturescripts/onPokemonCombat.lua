local OUTFIT_CYNDAQUIL = createConditionObject(CONDITION_OUTFIT, 60000)
addOutfitCondition(OUTFIT_CYNDAQUIL, {lookType = 956})

local OUTFIT_QUILAVA = createConditionObject(CONDITION_OUTFIT, 60000)
addOutfitCondition(OUTFIT_QUILAVA, {lookType = 957})

local OUTFIT_TYPHLOSION = createConditionObject(CONDITION_OUTFIT, 60000)
addOutfitCondition(OUTFIT_TYPHLOSION, {lookType = 958})

local OUTFIT_SHINYCYNDAQUIL = createConditionObject(CONDITION_OUTFIT, 60000)
addOutfitCondition(OUTFIT_SHINYCYNDAQUIL, {lookType = 1260})

local OUTFIT_SHINYQUILAVA = createConditionObject(CONDITION_OUTFIT, 60000)
addOutfitCondition(OUTFIT_SHINYQUILAVA, {lookType = 1262})

local OUTFIT_SHINYTYPHLOSION = createConditionObject(CONDITION_OUTFIT, 60000)
addOutfitCondition(OUTFIT_SHINYTYPHLOSION, {lookType = 1264})

local OUTFITS = {
    ["Cyndaquil"] = OUTFIT_CYNDAQUIL,
    ["Quilava"] = OUTFIT_QUILAVA,
    ["Typhlosion"] = OUTFIT_TYPHLOSION,
    ["Shiny Cyndaquil"] = OUTFIT_SHINYCYNDAQUIL,
    ["Shiny Quilava"] = OUTFIT_SHINYQUILAVA,
    ["Shiny Typhlosion"] = OUTFIT_SHINYTYPHLOSION,
}

function onCombat(cid, target)
    local name = getPokemonReferenceName(cid)
    if (OUTFITS[name] and not hasCondition(cid, CONDITION_OUTFIT)) then
        doAddCondition(cid, OUTFITS[name])
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_EXPLOSION)
    end
    return true
end