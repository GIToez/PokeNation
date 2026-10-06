local CONDITION_TICKS = {
    [CREATURE_STATUS_BURN] = 16 * 1000,
    [CREATURE_STATUS_FREEZE] = 7 * 1000,
    [CREATURE_STATUS_PARALYSIS] = 10 * 1000,
    [CREATURE_STATUS_POISON] = 16 * 1000,
    [CREATURE_STATUS_SLEEP] = 4 * 1000,
    [CREATURE_STATUS_CONFUSION] = 5 * 1000,
    [CREATURE_STATUS_LOWACCURACY] = 5 * 1000,
    [CREATURE_STATUS_EXTRASPEED] = 20 * 1000,
    [CREATURE_STATUS_EXTRASPATK] = 20 * 1000,
    [CREATURE_STATUS_EXTRASPDEF] = 20 * 1000,
    [CREATURE_STATUS_INSOMNIA] = 15 * 1000,
    [CREATURE_STATUS_REFLECT] = 15 * 1000,
    [CREATURE_STATUS_PREVENTSTATUS] = 15 * 1000,
    [CREATURE_STATUS_FLINCH] = 3 * 1000,
    [CREATURE_STATUS_BADPOISON] = 16 * 1000,
    [CREATURE_STATUS_HIGHCRITICALCHANCE] = 10 * 1000,
    [CREATURE_STATUS_RECHARGE] = BATTLE_ROUND_INTERVAL * 2,
    [CREATURE_STATUS_INFATUATE] = BATTLE_ROUND_INTERVAL * 3,
    [CREATURE_STATUS_STORE_DAMAGE] = BATTLE_ROUND_INTERVAL,
    [CREATURE_STATUS_COUNTER] = 10 * 1000,
    [CREATURE_STATUS_SUBSTITUTE] = -1,
    [CREATURE_STATUS_CHARGE] = 10 * 1000,
    [CREATURE_STATUS_STOCKPILE_CHARGE1] = 90 * 1000,
    [CREATURE_STATUS_STOCKPILE_CHARGE2] = 90 * 1000,
    [CREATURE_STATUS_STOCKPILE_CHARGE3] = 90 * 1000,
    [CREATURE_STATUS_IGNORE_ACCURACY] = 30 * 1000,
    [CREATURE_STATUS_MIRACLE_EYE] = -1,
    [CREATURE_STATUS_ENCORE] = 6 * 1000,
    [CREATURE_STATUS_DESTINY_BOND] = 2 * 1000,
    [CREATURE_STATUS_ENDURE] = 2 * 1000,
    [CREATURE_STATUS_PREVENTSTATSCHANGE] = BATTLE_ROUND_INTERVAL * 5,
    [CREATURE_STATUS_HEALBLOCK] = BATTLE_ROUND_INTERVAL * 5,
    [CREATURE_STATUS_PROTECTION] = BATTLE_ROUND_INTERVAL * 5,
}

local CONDITION_DURATIONS = {}

-- CONDITIONS --
local freezeParalyzeCondition = createConditionObject(CONDITION_PARALYZE, CONDITION_TICKS[CREATURE_STATUS_FREEZE])
setConditionFormula(freezeParalyzeCondition, -0.5, 0, -0.5, 0)
CONDITION_DURATIONS[freezeParalyzeCondition] = CONDITION_TICKS[CREATURE_STATUS_FREEZE]

local paralyzeCondition = createConditionObject(CONDITION_PARALYZE, CONDITION_TICKS[CREATURE_STATUS_PARALYSIS])
setConditionFormula(paralyzeCondition, -0.8, 0, -0.8, 0)
CONDITION_DURATIONS[paralyzeCondition] = CONDITION_TICKS[CREATURE_STATUS_PARALYSIS]

local lowParalyzeCondition = createConditionObject(CONDITION_PARALYZE, CONDITION_TICKS[CREATURE_STATUS_PARALYSIS])
setConditionFormula(lowParalyzeCondition, -0.4, 0, -0.4, 0)
CONDITION_DURATIONS[lowParalyzeCondition] = CONDITION_TICKS[CREATURE_STATUS_PARALYSIS]

local mediumParalyzeCondition = createConditionObject(CONDITION_PARALYZE, CONDITION_TICKS[CREATURE_STATUS_PARALYSIS])
setConditionFormula(mediumParalyzeCondition, -0.6, 0, -0.6, 0)
CONDITION_DURATIONS[mediumParalyzeCondition] = CONDITION_TICKS[CREATURE_STATUS_PARALYSIS]

local confuseCondition = createConditionObject(CONDITION_DRUNK, CONDITION_TICKS[CREATURE_STATUS_CONFUSION])
CONDITION_DURATIONS[confuseCondition] = CONDITION_TICKS[CREATURE_STATUS_CONFUSION]

local agilityCondition = createConditionObject(CONDITION_HASTE, CONDITION_TICKS[CREATURE_STATUS_EXTRASPEED])
setConditionFormula(agilityCondition, 0.3, -24, 0.3, -24)
CONDITION_DURATIONS[agilityCondition] = CONDITION_TICKS[CREATURE_STATUS_EXTRASPEED]

delayCondition = createConditionObject(CONDITION_EXHAUST, BATTLE_ROUND_INTERVAL)

local poisonCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_POISON], false, CONDITION_SUBID.CUSTOM.POISON)
setConditionParam(poisonCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_POISON) -- Effect Type
CONDITION_DURATIONS[poisonCondition] = CONDITION_TICKS[CREATURE_STATUS_POISON]

local badPoisonCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_BADPOISON], false, CONDITION_SUBID.CUSTOM.BADPOISON)
setConditionParam(badPoisonCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_POISON) -- Effect Type
CONDITION_DURATIONS[badPoisonCondition] = CONDITION_TICKS[CREATURE_STATUS_BADPOISON]

local burnCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_BURN], false, CONDITION_SUBID.CUSTOM.BURN)
setConditionParam(burnCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_FIRE) -- Effect Type
CONDITION_DURATIONS[burnCondition] = CONDITION_TICKS[CREATURE_STATUS_BURN]

lightCondition = createConditionObject(CONDITION_LIGHT)
setConditionParam(lightCondition, CONDITION_PARAM_LIGHT_LEVEL, 6)
setConditionParam(lightCondition, CONDITION_PARAM_LIGHT_COLOR, 215)
setConditionParam(lightCondition, CONDITION_PARAM_TICKS, -1)

MEWTWO_FREEZE_OUTFIT = createConditionObject(CONDITION_OUTFIT, -1, nil, CONDITION_SUBID.OUTFITS.QUEST)
addOutfitCondition(MEWTWO_FREEZE_OUTFIT, { lookType = 1615 })

local sleepCondition = createConditionObject(CONDITION_SLEEP, CONDITION_TICKS[CREATURE_STATUS_SLEEP])
setConditionParam(sleepCondition, CONDITION_PARAM_EFFECTTICKS, 1000)
CONDITION_DURATIONS[sleepCondition] = CONDITION_TICKS[CREATURE_STATUS_SLEEP]

local halfSleepCondition = createConditionObject(CONDITION_SLEEP, CONDITION_TICKS[CREATURE_STATUS_SLEEP] / 2)
setConditionParam(halfSleepCondition, CONDITION_PARAM_EFFECTTICKS, 500)
CONDITION_DURATIONS[halfSleepCondition] = CONDITION_TICKS[CREATURE_STATUS_SLEEP] / 2

local lowAccuracyCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_LOWACCURACY], false, CONDITION_SUBID.CUSTOM.LOWACCURACY)
setConditionParam(lowAccuracyCondition, CONDITION_PARAM_EFFECTTICKS, 1000)
setConditionParam(lowAccuracyCondition, CONDITION_PARAM_LIGHT_LEVEL, 156) -- Effect Type
CONDITION_DURATIONS[lowAccuracyCondition] = CONDITION_TICKS[CREATURE_STATUS_LOWACCURACY]

local insomniaCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_INSOMNIA], false, CONDITION_SUBID.CUSTOM.INSONIA)
setConditionParam(insomniaCondition, CONDITION_PARAM_EFFECTTICKS, 1000)
setConditionParam(insomniaCondition, CONDITION_PARAM_LIGHT_LEVEL, 39) -- Effect Type
CONDITION_DURATIONS[insomniaCondition] = CONDITION_TICKS[CREATURE_STATUS_INSOMNIA]

local reflectCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_REFLECT], false, CONDITION_SUBID.CUSTOM.REFLECT)
setConditionParam(reflectCondition, CONDITION_PARAM_LIGHT_LEVEL, 136) -- Effect Type
CONDITION_DURATIONS[reflectCondition] = CONDITION_TICKS[CREATURE_STATUS_REFLECT]

local preventStatusCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_PREVENTSTATUS], false, CONDITION_SUBID.CUSTOM.PREVENTSTATUS)
setConditionParam(preventStatusCondition, CONDITION_PARAM_LIGHT_LEVEL, 137) -- Effect Type
CONDITION_DURATIONS[preventStatusCondition] = CONDITION_TICKS[CREATURE_STATUS_PREVENTSTATUS]

local lowExtraSpAtkCondition = createConditionObject(CONDITION_EXTRASPATK, CONDITION_TICKS[CREATURE_STATUS_EXTRASPATK])
setConditionParam(lowExtraSpAtkCondition, CONDITION_PARAM_LIGHT_LEVEL, 20)
CONDITION_DURATIONS[lowExtraSpAtkCondition] = CONDITION_TICKS[CREATURE_STATUS_EXTRASPATK]

local mediumExtraSpAtkCondition = createConditionObject(CONDITION_EXTRASPATK, CONDITION_TICKS[CREATURE_STATUS_EXTRASPATK])
setConditionParam(mediumExtraSpAtkCondition, CONDITION_PARAM_LIGHT_LEVEL, 50)
CONDITION_DURATIONS[mediumExtraSpAtkCondition] = CONDITION_TICKS[CREATURE_STATUS_EXTRASPATK]

local highExtraSpAtkCondition = createConditionObject(CONDITION_EXTRASPATK, CONDITION_TICKS[CREATURE_STATUS_EXTRASPATK])
setConditionParam(highExtraSpAtkCondition, CONDITION_PARAM_LIGHT_LEVEL, 70)
CONDITION_DURATIONS[highExtraSpAtkCondition] = CONDITION_TICKS[CREATURE_STATUS_EXTRASPATK]

local badExtraSpAtkCondition = createConditionObject(CONDITION_EXTRASPATK, CONDITION_TICKS[CREATURE_STATUS_EXTRASPATK])
setConditionParam(badExtraSpAtkCondition, CONDITION_PARAM_LIGHT_LEVEL, -30)
CONDITION_DURATIONS[badExtraSpAtkCondition] = CONDITION_TICKS[CREATURE_STATUS_EXTRASPATK]

local badMediumExtraSpAtkCondition = createConditionObject(CONDITION_EXTRASPATK, CONDITION_TICKS[CREATURE_STATUS_EXTRASPATK])
setConditionParam(badMediumExtraSpAtkCondition, CONDITION_PARAM_LIGHT_LEVEL, -60)
CONDITION_DURATIONS[badMediumExtraSpAtkCondition] = CONDITION_TICKS[CREATURE_STATUS_EXTRASPATK]

local lowExtraSpDefCondition = createConditionObject(CONDITION_EXTRASPDEF, CONDITION_TICKS[CREATURE_STATUS_EXTRASPDEF])
setConditionParam(lowExtraSpDefCondition, CONDITION_PARAM_LIGHT_LEVEL, 20)
CONDITION_DURATIONS[lowExtraSpDefCondition] = CONDITION_TICKS[CREATURE_STATUS_EXTRASPDEF]

local mediumExtraSpDefCondition = createConditionObject(CONDITION_EXTRASPDEF, CONDITION_TICKS[CREATURE_STATUS_EXTRASPDEF])
setConditionParam(mediumExtraSpDefCondition, CONDITION_PARAM_LIGHT_LEVEL, 50)
CONDITION_DURATIONS[mediumExtraSpDefCondition] = CONDITION_TICKS[CREATURE_STATUS_EXTRASPDEF]

local highExtraSpDefCondition = createConditionObject(CONDITION_EXTRASPDEF, CONDITION_TICKS[CREATURE_STATUS_EXTRASPDEF])
setConditionParam(highExtraSpDefCondition, CONDITION_PARAM_LIGHT_LEVEL, 70)
CONDITION_DURATIONS[highExtraSpDefCondition] = CONDITION_TICKS[CREATURE_STATUS_EXTRASPDEF]

local badExtraSpDefCondition = createConditionObject(CONDITION_EXTRASPDEF, CONDITION_TICKS[CREATURE_STATUS_EXTRASPDEF])
setConditionParam(badExtraSpDefCondition, CONDITION_PARAM_LIGHT_LEVEL, -30)
CONDITION_DURATIONS[badExtraSpDefCondition] = CONDITION_TICKS[CREATURE_STATUS_EXTRASPDEF]

local badMediumExtraSpDefCondition = createConditionObject(CONDITION_EXTRASPDEF, CONDITION_TICKS[CREATURE_STATUS_EXTRASPDEF])
setConditionParam(badMediumExtraSpDefCondition, CONDITION_PARAM_LIGHT_LEVEL, -60)
CONDITION_DURATIONS[badMediumExtraSpDefCondition] = CONDITION_TICKS[CREATURE_STATUS_EXTRASPDEF]

pokemonCallDelayCondition = createConditionObject(CONDITION_EXHAUST, 5000, false, CONDITION_SUBID.EXHAUST.POKEMONCALL) -- only used in duels

local flinchCondition = createConditionObject(CONDITION_EXHAUST, CONDITION_TICKS[CREATURE_STATUS_FLINCH] / 2, false, CONDITION_SUBID.EXHAUST.FLINCH)
CONDITION_DURATIONS[flinchCondition] = CONDITION_TICKS[CREATURE_STATUS_FLINCH] / 2

local extendedFlinchCondition = createConditionObject(CONDITION_EXHAUST, CONDITION_TICKS[CREATURE_STATUS_FLINCH], false, CONDITION_SUBID.EXHAUST.FLINCH) -- Used when the user is already exhausted
CONDITION_DURATIONS[extendedFlinchCondition] = CONDITION_TICKS[CREATURE_STATUS_FLINCH]

local rechargeCondition = createConditionObject(CONDITION_EXHAUST, CONDITION_TICKS[CREATURE_STATUS_RECHARGE], false, CONDITION_SUBID.EXHAUST.RECHARGE)
CONDITION_DURATIONS[rechargeCondition] = CONDITION_TICKS[CREATURE_STATUS_RECHARGE]

local highCriticalChanceCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_HIGHCRITICALCHANCE], false, CONDITION_SUBID.CUSTOM.HIGHCRITICALCHANCE)
setConditionParam(highCriticalChanceCondition, CONDITION_PARAM_LIGHT_LEVEL, 199)
CONDITION_DURATIONS[highCriticalChanceCondition] = CONDITION_TICKS[CREATURE_STATUS_HIGHCRITICALCHANCE]

-- Mastery Extra Advantages Conditions
local voltagicParalyzeCondition = createConditionObject(CONDITION_PARALYZE, 13000)
setConditionFormula(voltagicParalyzeCondition, -0.9, 0, -0.9, 0)
CONDITION_DURATIONS[voltagicParalyzeCondition] = 13000

local heremitLowAccuracyCondition = createConditionObject(CONDITION_CUSTOM, 12000, false, CONDITION_SUBID.CUSTOM.LOWACCURACY)
setConditionParam(heremitLowAccuracyCondition, CONDITION_PARAM_EFFECTTICKS, 1000)
setConditionParam(heremitLowAccuracyCondition, CONDITION_PARAM_LIGHT_LEVEL, 156)
CONDITION_DURATIONS[heremitLowAccuracyCondition] = 12000

local vitalLowExtraSpAtkCondition = createConditionObject(CONDITION_EXTRASPATK, 13000)
setConditionParam(vitalLowExtraSpAtkCondition, CONDITION_PARAM_LIGHT_LEVEL, 20)
CONDITION_DURATIONS[vitalLowExtraSpAtkCondition] = 13000

local vitalMediumExtraSpAtkCondition = createConditionObject(CONDITION_EXTRASPATK, 13000)
setConditionParam(vitalMediumExtraSpAtkCondition, CONDITION_PARAM_LIGHT_LEVEL, 50)
CONDITION_DURATIONS[vitalMediumExtraSpAtkCondition] = 13000

local vitalHighExtraSpAtkCondition = createConditionObject(CONDITION_EXTRASPATK, 13000)
setConditionParam(vitalHighExtraSpAtkCondition, CONDITION_PARAM_LIGHT_LEVEL, 70)
CONDITION_DURATIONS[vitalHighExtraSpAtkCondition] = 13000

local vitalLowExtraSpDefCondition = createConditionObject(CONDITION_EXTRASPDEF, 13000)
setConditionParam(vitalLowExtraSpDefCondition, CONDITION_PARAM_LIGHT_LEVEL, 20)
CONDITION_DURATIONS[vitalLowExtraSpDefCondition] = 13000

local vitalMediumExtraSpDefCondition = createConditionObject(CONDITION_EXTRASPDEF, 13000)
setConditionParam(vitalMediumExtraSpDefCondition, CONDITION_PARAM_LIGHT_LEVEL, 50)
CONDITION_DURATIONS[vitalMediumExtraSpDefCondition] = 13000

local vitalHighExtraSpDefCondition = createConditionObject(CONDITION_EXTRASPDEF, 13000)
setConditionParam(vitalHighExtraSpDefCondition, CONDITION_PARAM_LIGHT_LEVEL, 70)
CONDITION_DURATIONS[vitalHighExtraSpDefCondition] = 13000

local infatuateCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_INFATUATE], false, CONDITION_SUBID.CUSTOM.INFATUATE)
setConditionParam(infatuateCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_LOVE_HEARTS_FOUR)
CONDITION_DURATIONS[infatuateCondition] = CONDITION_TICKS[CREATURE_STATUS_INFATUATE]

local storeDamageCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_STORE_DAMAGE], false, CONDITION_SUBID.CUSTOM.STORE_DAMAGE)
setConditionParam(storeDamageCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_BLACK_ENERGIZE)
CONDITION_DURATIONS[storeDamageCondition] = CONDITION_TICKS[CREATURE_STATUS_STORE_DAMAGE]

local counterCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_COUNTER], false, CONDITION_SUBID.CUSTOM.COUNTER)
setConditionParam(counterCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_BIG_MIRROR)
CONDITION_DURATIONS[counterCondition] = CONDITION_TICKS[CREATURE_STATUS_COUNTER]

local substituteCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_SUBSTITUTE], false, CONDITION_SUBID.CUSTOM.SUBSTITUTE)
setConditionParam(substituteCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_WHITE_CIRCLE)
CONDITION_DURATIONS[substituteCondition] = CONDITION_TICKS[CREATURE_STATUS_SUBSTITUTE]

local chargeCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_CHARGE], false, CONDITION_SUBID.CUSTOM.CHARGE)
setConditionParam(chargeCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_YELLOW_ENERGIZE)
CONDITION_DURATIONS[chargeCondition] = CONDITION_TICKS[CREATURE_STATUS_CHARGE]

local stockpileCharge1Condition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_STOCKPILE_CHARGE1], false, CONDITION_SUBID.CUSTOM.STOCKPILE_CHARGE1)
setConditionParam(stockpileCharge1Condition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_RED_ENERGIZE)
CONDITION_DURATIONS[stockpileCharge1Condition] = CONDITION_TICKS[CREATURE_STATUS_STOCKPILE_CHARGE1]

local stockpileCharge2Condition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_STOCKPILE_CHARGE2], false, CONDITION_SUBID.CUSTOM.STOCKPILE_CHARGE2)
setConditionParam(stockpileCharge2Condition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_RED_ENERGIZE)
CONDITION_DURATIONS[stockpileCharge2Condition] = CONDITION_TICKS[CREATURE_STATUS_STOCKPILE_CHARGE2]

local stockpileCharge3Condition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_STOCKPILE_CHARGE3], false, CONDITION_SUBID.CUSTOM.STOCKPILE_CHARGE3)
setConditionParam(stockpileCharge3Condition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_RED_ENERGIZE)
CONDITION_DURATIONS[stockpileCharge3Condition] = CONDITION_TICKS[CREATURE_STATUS_STOCKPILE_CHARGE3]

local ignoreAccuracyCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_IGNORE_ACCURACY], false, CONDITION_SUBID.CUSTOM.IGNORE_ACCURACY)
setConditionParam(ignoreAccuracyCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_WHITE_GLOWS)
CONDITION_DURATIONS[ignoreAccuracyCondition] = CONDITION_TICKS[CREATURE_STATUS_IGNORE_ACCURACY]

local miracleEyeCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_MIRACLE_EYE], false, CONDITION_SUBID.CUSTOM.IGNORE_ACCURACY)
setConditionParam(miracleEyeCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_RED_ENERGIZED_CIRCLE)
CONDITION_DURATIONS[miracleEyeCondition] = CONDITION_TICKS[CREATURE_STATUS_MIRACLE_EYE]

local encoreCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_ENCORE], false, CONDITION_SUBID.CUSTOM.ENCORE)
setConditionParam(encoreCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_BIG_PINK_CLOUD)
CONDITION_DURATIONS[encoreCondition] = CONDITION_TICKS[CREATURE_STATUS_ENCORE]

local destinyBondCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_DESTINY_BOND], false, CONDITION_SUBID.CUSTOM.DESTINY_BOND)
setConditionParam(destinyBondCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_SHADOW_HANDS)
CONDITION_DURATIONS[destinyBondCondition] = CONDITION_TICKS[CREATURE_STATUS_DESTINY_BOND]

local endureCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_ENDURE], false, CONDITION_SUBID.CUSTOM.ENDURE)
setConditionParam(endureCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_JENNYS_RADAR)
CONDITION_DURATIONS[endureCondition] = CONDITION_TICKS[CREATURE_STATUS_ENDURE]

local preventStatsChangeCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_PREVENTSTATSCHANGE], false, CONDITION_SUBID.CUSTOM.ENDURE)
setConditionParam(endureCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_JENNYS_RADAR)
CONDITION_DURATIONS[endureCondition] = CONDITION_TICKS[CREATURE_STATUS_PREVENTSTATSCHANGE]

local healBlockCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_HEALBLOCK], false, CONDITION_SUBID.CUSTOM.ENDURE)
setConditionParam(healBlockCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_DARK_BAT)
CONDITION_DURATIONS[healBlockCondition] = CONDITION_TICKS[CREATURE_STATUS_HEALBLOCK]

local protectionCondition = createConditionObject(CONDITION_CUSTOM, CONDITION_TICKS[CREATURE_STATUS_PROTECTION], false, CONDITION_SUBID.CUSTOM.ENDURE)
setConditionParam(protectionCondition, CONDITION_PARAM_LIGHT_LEVEL, EFFECT_GREEN_PROTECTION)
CONDITION_DURATIONS[protectionCondition] = CONDITION_TICKS[CREATURE_STATUS_PROTECTION]


local EXTRASPATKCONDITION_BY_VAR = {
    [CREATURE_STATUS_VAR_LOW] = lowExtraSpAtkCondition,
    [CREATURE_STATUS_VAR_MEDIUM] = mediumExtraSpAtkCondition,
    [CREATURE_STATUS_VAR_HIGH] = highExtraSpAtkCondition,
    [CREATURE_STATUS_VAR_BAD] = badExtraSpAtkCondition,
    [CREATURE_STATUS_VAR_BADMEDIUM] = badMediumExtraSpAtkCondition
}

local EXTRASPDEFCONDITION_BY_VAR = {
    [CREATURE_STATUS_VAR_LOW] = lowExtraSpDefCondition,
    [CREATURE_STATUS_VAR_MEDIUM] = mediumExtraSpDefCondition,
    [CREATURE_STATUS_VAR_HIGH] = highExtraSpDefCondition,
    [CREATURE_STATUS_VAR_BAD] = badExtraSpDefCondition,
    [CREATURE_STATUS_VAR_BADMEDIUM] = badMediumExtraSpDefCondition
}

local VITALEXTRASPATKCONDITION_BY_VAR = {
    [CREATURE_STATUS_VAR_LOW] = vitalLowExtraSpAtkCondition,
    [CREATURE_STATUS_VAR_MEDIUM] = vitalMediumExtraSpAtkCondition,
    [CREATURE_STATUS_VAR_HIGH] = vitalHighExtraSpAtkCondition
}

local VITALEXTRASPDEFCONDITION_BY_VAR = {
    [CREATURE_STATUS_VAR_LOW] = vitalLowExtraSpDefCondition,
    [CREATURE_STATUS_VAR_MEDIUM] = vitalMediumExtraSpDefCondition,
    [CREATURE_STATUS_VAR_HIGH] = vitalHighExtraSpDefCondition
}

--[[ Convert duration to seconds ]]
for k, v in pairs(CONDITION_DURATIONS) do
    CONDITION_DURATIONS[k] = math.ceil(v / 1000)
end

-- Functions --
-- Is --
function isPoisoned(cid)
    return getPokemonPoison(cid)
end

function isBurning(cid)
    return getPokemonBurn(cid)
end

-- Burn
local function doBurn(cid, damage, ticks, caster)
    if (isCreature(cid)) then
        if (isCreature(caster) and getPokemonBurn(cid) and getCreatureStatus(cid, CREATURE_STATUS_BURN)) then
            doTargetCombatHealth(caster, cid, COMBAT_FIREDAMAGE, damage, damage, EFFECT_FIRE)
            if (not isCreature(cid)) then return end
            ticks = ticks - 1
            if (ticks > 0) then
                addEvent(doBurn, 2000, cid, damage, ticks, caster)
            else
                setPokemonBurn(cid, false)
            end

        else
            doCreatureRemoveStatus(cid, CREATURE_STATUS_BURN)
        end
    end
end

function doCreatureBurn(cid, level, caster)
    if (isMonster(cid) and isInArray(getPokemonTypes(cid), ELEMENT_FIRE)) then
        return false
    end

    if (not isBurning(cid) and not getCreatureStatus(cid, CREATURE_STATUS_PREVENTSTATUS)) then
        if (caster and doMasteryAdvantageCheck(getCreatureMaster(caster), MASTERY_ADVANTAGES.BURN_DAMAGE)) then -- Mastery Benefit
            level = level * 2
        end

        if (isPlayer(cid)) then
            level = level / 2
        end
        setPokemonBurn(cid, true)
        setPokemonBurnDamage(cid, level)
        doAddCondition(cid, burnCondition)
        doSendAnimatedText(getCreaturePosition(cid), "BURN", COLOR_RED)
        doSendCreatureEffect(cid, CREATURE_EFFECTS.BURN, CONDITION_TICKS[CREATURE_STATUS_BURN])
        doBurn(cid, -(level * 2), 8, caster)
    end
    return true
end

-- Poison
local function doPoison(cid, damage, ticks, caster)
    if (isCreature(cid)) then
        if (isCreature(caster) and getPokemonPoison(cid) and getCreatureStatus(cid, CREATURE_STATUS_POISON)) then
            if (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.POISON_HEAL, nil)) then
                doTargetCombatHealth(caster, cid, COMBAT_POISONDAMAGE, -damage, -damage, EFFECT_GREEN_CIRCLE)
            else
                doTargetCombatHealth(caster, cid, COMBAT_POISONDAMAGE, damage, damage, EFFECT_POISON)
            end
            if (not isCreature(cid)) then return end
            ticks = ticks - 1
            if (ticks > 0) then
                addEvent(doPoison, 2000, cid, damage, ticks, caster)
            else
                setPokemonPoison(cid, false)
            end

        else
            doCreatureRemoveStatus(cid, CREATURE_STATUS_POISON)
        end
    end
end

function doCreaturePoison(cid, level, caster)
    if (isMonster(cid)) then
        local types = getPokemonTypes(cid)
        if (isInArray(types, ELEMENT_POISON) or isInArray(types, ELEMENT_STEEL)) then
            return false
        end
    end
    if (not isPoisoned(cid) and not getCreatureStatus(cid, CREATURE_STATUS_PREVENTSTATUS) and not getCreatureStatus(cid, CREATURE_STATUS_BADPOISON)) then
        if (caster and doMasteryAdvantageCheck(getCreatureMaster(caster), MASTERY_ADVANTAGES.POISON_DAMAGE)) then -- Mastery Benefit
            level = level * 2
        end

        if (isPlayer(cid)) then
            level = level / 2
        end
        setPokemonPoison(cid, true)
        setPokemonPoisonDamage(cid, level)
        doAddCondition(cid, poisonCondition)
        doSendAnimatedText(getCreaturePosition(cid), "POISON", COLOR_GREEN)
        doSendCreatureEffect(cid, CREATURE_EFFECTS.POISON, CONDITION_TICKS[CREATURE_STATUS_POISON])
        doPoison(cid, -(level * 2), 8, caster)
    end
    return true
end

-- Bad Poison
local function doBadPoison(cid, damage, ticks, caster)
    if (isCreature(cid)) then
        if (isCreature(caster) and getPokemonBadPoison(cid) and getCreatureStatus(cid, CREATURE_STATUS_BADPOISON)) then
            doTargetCombatHealth(caster, cid, COMBAT_POISONDAMAGE, damage, damage, EFFECT_POISON)
            if (not isCreature(cid)) then return end
            ticks = ticks - 1
            if (ticks > 0) then
                addEvent(doBadPoison, 2000, cid, damage, ticks, caster)
            else
                setPokemonBadPoison(cid, false)
            end

        else
            doCreatureRemoveStatus(cid, CREATURE_STATUS_BADPOISON)
        end
    end
end

function doCreatureBadPoison(cid, level, caster)
    if (isMonster(cid)) then
        local types = getPokemonTypes(cid)
        if (isInArray(types, ELEMENT_POISON) or isInArray(types, ELEMENT_STEEL)) then
            return false
        end
    end
    if (not getCreatureStatus(cid, CREATURE_STATUS_BADPOISON) and not getCreatureStatus(cid, CREATURE_STATUS_PREVENTSTATUS)) then
        if (caster and doMasteryAdvantageCheck(getCreatureMaster(caster), MASTERY_ADVANTAGES.POISON_DAMAGE)) then -- Mastery Benefit
            level = level * 2
        end

        if (getCreatureStatus(cid, CREATURE_STATUS_POISON)) then
            doCreatureRemoveStatus(cid, CREATURE_STATUS_POISON)
        end

        if (isPlayer(cid)) then
            level = level / 2
        end
        setPokemonBadPoison(cid, true)
        setPokemonBadPoisonDamage(cid, level)
        doAddCondition(cid, badPoisonCondition)
        doSendAnimatedText(getCreaturePosition(cid), "BADPOISON", COLOR_DARKPURPLE)
        doSendCreatureEffect(cid, CREATURE_EFFECTS.BADPOISON, CONDITION_TICKS[CREATURE_STATUS_BADPOISON])
        doBadPoison(cid, -(level * 4), 8, caster)
    end
    return true
end

--[[ ]]
local CONDITIONS = {
    [CREATURE_STATUS_BURN] = {
        volatile = false,
        icon = 16715,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.BURN)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.BURN)
            setPokemonBurn(cid, false)
        end,
        onAdd = function(cid, var, caster, badStatus)
            if (doCreatureBurn(cid, var, caster)) then
                return burnCondition
            end
            return nil
        end
    },
    [CREATURE_STATUS_FREEZE] = {
        volatile = false,
        icon = 16716,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_PARALYZE)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_PARALYZE)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, freezeParalyzeCondition)
            doSendAnimatedText(getCreaturePosition(cid), "FROZEN", COLOR_LIGHTBLUE)
            doSendCreatureEffect(cid, CREATURE_EFFECTS.FREEZE, CONDITION_TICKS[CREATURE_STATUS_FREEZE])
            return freezeParalyzeCondition
        end
    },
    [CREATURE_STATUS_PARALYSIS] = {
        volatile = false,
        icon = 16717,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_PARALYZE)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_PARALYZE)
        end,
        onAdd = function(cid, var --[[ from_non_electric_source? ]], caster, badStatus)
            if (not var and isPokemon(cid) and table.find(getPokemonTypes(cid), ELEMENT_GROUND)) then
                doSendAnimatedText(getCreaturePosition(cid), "FAIL", TEXTCOLOR_WHITE)
                return
            end

            doSendAnimatedText(getCreaturePosition(cid), "PARALYSIS", COLOR_YELLOW)
            if (caster and doMasteryAdvantageCheck(getCreatureMaster(caster), MASTERY_ADVANTAGES.PARALYZE_DURATION)) then -- Caster will be null when called from load ball stats
                doAddCondition(cid, voltagicParalyzeCondition)
                return voltagicParalyzeCondition
            else
                doAddCondition(cid, paralyzeCondition)
                return paralyzeCondition
            end
        end
    },
    [CREATURE_STATUS_POISON] = {
        volatile = true,
        icon = 16718,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.POISON)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.POISON)
            setPokemonPoison(cid, false)
        end,
        onAdd = function(cid, var, caster, badStatus)
            if (doCreaturePoison(cid, var, caster)) then
                return poisonCondition
            end
            return nil
        end
    },
    [CREATURE_STATUS_SLEEP] = {
        volatile = false,
        icon = 16719,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_SLEEP)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_SLEEP)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doSendAnimatedText(getCreaturePosition(cid), "SLEEP", COLOR_PINK)
            if (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.EARLY_BIRD, nil)) then
                doAddCondition(cid, halfSleepCondition)
                return halfSleepCondition
            else
                doAddCondition(cid, sleepCondition)
                return sleepCondition
            end
        end
    },
    [CREATURE_STATUS_CONFUSION] = {
        volatile = true,
        icon = 16720,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_DRUNK)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_DRUNK)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, confuseCondition)
            doSendAnimatedText(getCreaturePosition(cid), "CONFUSE", COLOR_YELLOW)
            return confuseCondition
        end
    },
    [CREATURE_STATUS_LOWACCURACY] = {
        volatile = true,
        icon = 16721,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.LOWACCURACY)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.LOWACCURACY)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doSendAnimatedText(getCreaturePosition(cid), "LOW ACCURACY", COLOR_GRAY)
            if (caster and doMasteryAdvantageCheck(getCreatureMaster(caster), MASTERY_ADVANTAGES.LOW_ACCURACY_DURATION)) then -- Caster will be null when called from load ball
                doAddCondition(cid, heremitLowAccuracyCondition)
                return heremitLowAccuracyCondition
            else
                doAddCondition(cid, lowAccuracyCondition)
                return lowAccuracyCondition
            end
        end
    },
    [CREATURE_STATUS_EXTRASPEED] = {
        volatile = true,
        icon = 16722,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_HASTE)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_HASTE)
        end,
        onAdd = function(cid, var, caster, badStatus)
            if (var == CREATURE_STATUS_VAR_BAD) then
                if (getCreatureCondition(cid, CONDITION_PARALYZE)) then -- ugly hack to prevent double bad conditions
                    return
                end
                doAddCondition(cid, lowParalyzeCondition)
                doSendAnimatedText(getCreaturePosition(cid), "-SPEED", COLOR_ORANGE)
                return lowParalyzeCondition
            elseif (var == CREATURE_STATUS_VAR_BADMEDIUM) then
                if (getCreatureCondition(cid, CONDITION_PARALYZE)) then -- ugly hack to prevent double bad conditions
                    return
                end
                doAddCondition(cid, mediumParalyzeCondition)
                doSendAnimatedText(getCreaturePosition(cid), "-SPEED", COLOR_ORANGE)
                return mediumParalyzeCondition
            else
                doAddCondition(cid, agilityCondition)
                doSendAnimatedText(getCreaturePosition(cid), "+SPEED", COLOR_ORANGE)
                return agilityCondition
            end
        end
    },
    [CREATURE_STATUS_EXTRASPATK] = {
        volatile = true,
        icon = 16724,
        badIcon = 16723,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_EXTRASPATK)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_EXTRASPATK)
        end,
        onAdd = function(cid, var, caster, badStatus)
            if (not badStatus and doMasteryAdvantageCheck(getCreatureMaster(cid), MASTERY_ADVANTAGES.BUFF_DURATION)) then
                doAddCondition(cid, VITALEXTRASPATKCONDITION_BY_VAR[var])
                return VITALEXTRASPATKCONDITION_BY_VAR[var]
            else
                doAddCondition(cid, EXTRASPATKCONDITION_BY_VAR[var])
                return EXTRASPATKCONDITION_BY_VAR[var]
            end
        end
    },
    [CREATURE_STATUS_EXTRASPDEF] = {
        volatile = true,
        icon = 16726,
        badIcon = 16725,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_EXTRASPDEF)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_EXTRASPDEF)
        end,
        onAdd = function(cid, var, caster, badStatus)
            if (not badStatus and doMasteryAdvantageCheck(getCreatureMaster(cid), MASTERY_ADVANTAGES.BUFF_DURATION)) then
                doAddCondition(cid, VITALEXTRASPDEFCONDITION_BY_VAR[var])
                return VITALEXTRASPDEFCONDITION_BY_VAR[var]
            else
                doAddCondition(cid, EXTRASPDEFCONDITION_BY_VAR[var])
                return EXTRASPDEFCONDITION_BY_VAR[var]
            end
        end
    },
    [CREATURE_STATUS_INSOMNIA] = {
        volatile = true,
        icon = 16727,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.INSONIA)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.INSONIA)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, insomniaCondition)
            doSendAnimatedText(getCreaturePosition(cid), "INSOMNIA", COLOR_DARKORANGE)
            return insomniaCondition
        end
    },
    [CREATURE_STATUS_REFLECT] = {
        volatile = true,
        icon = 16728,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.REFLECT)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.REFLECT)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, reflectCondition)
            doSendAnimatedText(getCreaturePosition(cid), "REFLECT", COLOR_WHITE)
            return reflectCondition
        end
    },
    [CREATURE_STATUS_PREVENTSTATUS] = {
        volatile = true,
        icon = 16729,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.PREVENTSTATUS)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.PREVENTSTATUS)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, preventStatusCondition)
            doSendAnimatedText(getCreaturePosition(cid), "PREVENT", COLOR_PINK)
            return preventStatusCondition
        end
    },
    [CREATURE_STATUS_FLINCH] = {
        volatile = true,
        icon = 16730,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_EXHAUST, CONDITION_SUBID.EXHAUST.FLINCH)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_EXHAUST, CONDITION_SUBID.EXHAUST.FLINCH)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doSendAnimatedText(getCreaturePosition(cid), "FLINCH", COLOR_DARKPINK)
            if (isExhaust(cid)) then
                doAddCondition(cid, extendedFlinchCondition)
                return extendedFlinchCondition
            else
                doAddCondition(cid, flinchCondition)
                return flinchCondition
            end
        end
    },
    [CREATURE_STATUS_BADPOISON] = {
        volatile = false,
        icon = 16731,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.BADPOISON)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.BADPOISON)
            setPokemonBadPoison(cid, false)
        end,
        onAdd = function(cid, var, caster, badStatus)
            if (doCreatureBadPoison(cid, var, caster)) then
                return badPoisonCondition
            end
            return nil
        end
    },
    [CREATURE_STATUS_HIGHCRITICALCHANCE] = {
        volatile = true,
        icon = 16732,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.HIGHCRITICALCHANCE)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.HIGHCRITICALCHANCE)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, highCriticalChanceCondition)
            doSendCreatureEffect(cid, CREATURE_EFFECTS.HIGHCRITICALCHANCE,
                CONDITION_TICKS[CREATURE_STATUS_HIGHCRITICALCHANCE])
            return highCriticalChanceCondition
        end
    },
    [CREATURE_STATUS_RECHARGE] = {
        volatile = true,
        icon = 16733,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_EXHAUST, CONDITION_SUBID.EXHAUST.RECHARGE)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_EXHAUST, CONDITION_SUBID.EXHAUST.RECHARGE)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, rechargeCondition)
            return rechargeCondition
        end
    },
    [CREATURE_STATUS_INFATUATE] = {
        volatile = true,
        icon = 16734,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.INFATUATE)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.INFATUATE)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, infatuateCondition)
            return infatuateCondition
        end
    },
    [CREATURE_STATUS_STORE_DAMAGE] = {
        volatile = true,
        icon = 16735,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.STORE_DAMAGE)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.STORE_DAMAGE)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, storeDamageCondition)
            return storeDamageCondition
        end
    },
    [CREATURE_STATUS_COUNTER] = {
        volatile = true,
        icon = 16736,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.COUNTER)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.COUNTER)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, counterCondition)
            return counterCondition
        end
    },
    [CREATURE_STATUS_SUBSTITUTE] = {
        volatile = true,
        -- icon = 16737, Deactived cuz we can't handle the cooldown
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.SUBSTITUTE)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.SUBSTITUTE)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, substituteCondition)
            return substituteCondition
        end
    },
    [CREATURE_STATUS_CHARGE] = {
        volatile = true,
        icon = 16738,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.CHARGE)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.CHARGE)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, chargeCondition)
            doSendCreatureEffect(cid, CREATURE_EFFECTS.CHARGE, CONDITION_TICKS[CREATURE_STATUS_CHARGE])
            return chargeCondition
        end
    },
    [CREATURE_STATUS_STOCKPILE_CHARGE1] = {
        volatile = true,
        icon = 17587,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.STOCKPILE_CHARGE1)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.STOCKPILE_CHARGE1)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, stockpileCharge1Condition)
            return stockpileCharge1Condition
        end
    },
    [CREATURE_STATUS_STOCKPILE_CHARGE2] = {
        volatile = true,
        icon = 17588,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.STOCKPILE_CHARGE2)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.STOCKPILE_CHARGE2)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, stockpileCharge2Condition)
            return stockpileCharge2Condition
        end
    },
    [CREATURE_STATUS_STOCKPILE_CHARGE3] = {
        volatile = true,
        icon = 17589,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.STOCKPILE_CHARGE3)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.STOCKPILE_CHARGE3)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, stockpileCharge3Condition)
            return stockpileCharge3Condition
        end
    },
    [CREATURE_STATUS_IGNORE_ACCURACY] = {
        volatile = true,
        --        icon = 16738,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.IGNORE_ACCURACY)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.IGNORE_ACCURACY)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, ignoreAccuracyCondition)
            doSendCreatureEffect(cid, CREATURE_EFFECTS.HIGHCRITICALCHANCE, CONDITION_TICKS[CREATURE_STATUS_IGNORE_ACCURACY])
            return ignoreAccuracyCondition
        end
    },
    [CREATURE_STATUS_MIRACLE_EYE] = {
        volatile = true,
        --        icon = 16738,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.MIRACLE_EYE)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.MIRACLE_EYE)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, miracleEyeCondition)
            --            doSendCreatureEffect(cid, CREATURE_EFFECTS.HIGHCRITICALCHANCE, CONDITION_TICKS[CREATURE_STATUS_MIRACLE_EYE])
            return miracleEyeCondition
        end
    },
    [CREATURE_STATUS_ENCORE] = {
        volatile = true,
        --        icon = 16738,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.ENCORE)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.ENCORE)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, encoreCondition)
            --            doSendCreatureEffect(cid, CREATURE_EFFECTS.HIGHCRITICALCHANCE, CONDITION_TICKS[CREATURE_STATUS_ENCORE])
            return encoreCondition
        end
    },
    [CREATURE_STATUS_DESTINY_BOND] = {
        volatile = true,
        --        icon = 16738,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.DESTINY_BOND)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.DESTINY_BOND)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, destinyBondCondition)
            --            doSendCreatureEffect(cid, CREATURE_EFFECTS.HIGHCRITICALCHANCE, CONDITION_TICKS[CREATURE_STATUS_DESTINY_BOND])
            return destinyBondCondition
        end
    },
    [CREATURE_STATUS_ENDURE] = {
        volatile = true,
        --        icon = 16738,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.ENDURE)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.ENDURE)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, endureCondition)
            --            doSendCreatureEffect(cid, CREATURE_EFFECTS.HIGHCRITICALCHANCE, CONDITION_TICKS[CREATURE_STATUS_ENDURE])
            return endureCondition
        end
    },
    [CREATURE_STATUS_PREVENTSTATSCHANGE] = {
        volatile = true,
        --        icon = 16738,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.PREVENTSTATSCHANGE)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.PREVENTSTATSCHANGE)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, preventStatsChangeCondition)
            return preventStatsChangeCondition
        end
    },
    [CREATURE_STATUS_HEALBLOCK] = {
        volatile = true,
        --        icon = 16738,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.HEALBLOCK)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.HEALBLOCK)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, healBlockCondition)
            return healBlockCondition
        end
    },
    [CREATURE_STATUS_PROTECTION] = {
        volatile = true,
        --        icon = 16738,
        onGet = function(cid)
            return getCreatureCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.PROTECTION)
        end,
        onRemove = function(cid)
            doRemoveCondition(cid, CONDITION_CUSTOM, CONDITION_SUBID.CUSTOM.PROTECTION)
        end,
        onAdd = function(cid, var, caster, badStatus)
            doAddCondition(cid, protectionCondition)
            return protectionCondition
        end
    }
}

function getCreatureStatus(cid, status)
    if (CONDITIONS[status]) then
        return CONDITIONS[status].onGet(cid)
    else
        log(LOG_TYPES.ERROR, "getCreatureStatus(cid, status) - Unknown Status", cid, status)
    end
end

function doCreatureRemoveStatus(cid, status)
    if (CONDITIONS[status]) then
        CONDITIONS[status].onRemove(cid)
        if (CONDITIONS[status].icon) then
            local master = getCreatureMaster(cid)
            if (isPlayer(master)) then
                doPlayerSendPokemonStatusRemove(master, CONDITIONS[status].icon)
            end
        end
    else
        log(LOG_TYPES.ERROR, "doCreatureRemoveStatus(cid, status) - Unknown Status", cid, status)
    end
end

function doCreatureAddStatus(cid, status, var, caster)
    if (not isCreature(cid)) then -- This can be true if the status is added after a damage and this damage kill the monster
        return
    end

    local badStatus = (not table.find({
        CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_EXTRASPDEF,
        CREATURE_STATUS_REFLECT, CREATURE_STATUS_PREVENTSTATUS, CREATURE_STATUS_HIGHCRITICALCHANCE,
        CREATURE_STATUS_STORE_DAMAGE, CREATURE_STATUS_COUNTER, CREATURE_STATUS_SUBSTITUTE, CREATURE_STATUS_CHARGE
    },
        status) or
            (var == CREATURE_STATUS_VAR_BAD or var == CREATURE_STATUS_VAR_BADMEDIUM))

    if (badStatus) then
        if (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.RUN_AWAY, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.COMPOUNDEYES, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.KEEN_EYE, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.LIMBER, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.VITAL_SPIRIT, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.OWN_TEMPO, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.INSOMNIA, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.LIMBER, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.WATER_VEIL, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.IMMUNITY, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.CLOUD_NINE, nil, status, caster) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.CLEAR_BODY, nil, status, caster) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.HYPER_CUTTER, nil, status, caster) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.INNER_FOCUS, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SHADOW_TAG, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SUCTION_CUPS, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.MAGMA_ARMOR, nil, status) or
                doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SUMMI, nil) or
                (table.find({ CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_EXTRASPDEF }, status) and getCreatureStatus(cid, CREATURE_STATUS_PREVENTSTATSCHANGE))) then
            doSendAnimatedText(getCreaturePosition(cid), "FAIL", TEXTCOLOR_WHITE)
            return
        end

        if (status == CREATURE_STATUS_SLEEP and getCreatureStatus(cid, CREATURE_STATUS_INSOMNIA)) then
            doSendAnimatedText(getCreaturePosition(cid), "INSOMNIA", TEXTCOLOR_PINK)
            return
        end

        if (caster ~= cid) then -- Ex: Use Reflect and then use Rest, the Sleep condition is not really bad
            if (getCreatureStatus(cid, CREATURE_STATUS_REFLECT)) then
                doCreatureRemoveStatus(cid, CREATURE_STATUS_REFLECT)
                doCreatureAddStatus(caster, status, var, cid)
                return

            elseif (getCreatureStatus(cid, CREATURE_STATUS_PREVENTSTATUS)) then
                doCreatureRemoveStatus(cid, CREATURE_STATUS_PREVENTSTATUS)
                return

            elseif (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.QUICK_FEET, nil)) then
                doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPEED, nil, cid)
                if (status == CREATURE_STATUS_PARALYSIS) then
                    return
                end

            elseif (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.STEADFAST, nil, status)) then
                doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPEED, nil, cid)

            elseif (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.COMPETITIVE, nil, status)) then
                doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_LOW, cid)
            end
        end

    elseif (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SIMPLE, nil) and table.find({ CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_EXTRASPDEF }, status)) then
        var = CREATURE_STATUS_VAR_MEDIUM
    end

    if (cid ~= caster and isPokemonWild(cid) and not hasTarget(cid)) then
        doMonsterSetTarget(cid, caster)
    end

    if (getCreatureStatus(cid, status)) then -- prevent bug(when 2 same conditions are running, only one will be stopped) and block sychronize ability infinite loop
        return
    end

    if (CONDITIONS[status]) then
        local condition = CONDITIONS[status].onAdd(cid, var, caster, badStatus)
        if (condition and CONDITIONS[status].icon) then
            local master = getCreatureMaster(cid)
            if (isPlayer(master)) then
                doPlayerSendPokemonStatusAdd(master,
                    ((status == CREATURE_STATUS_EXTRASPATK or status == CREATURE_STATUS_EXTRASPDEF) and badStatus)
                            and CONDITIONS[status].badIcon or CONDITIONS[status].icon,
                    CONDITION_DURATIONS[condition])
            end
        end
    else
        log(LOG_TYPES.ERROR, "doCreatureAddStatus(cid, status, var, caster) - Unknown Status", getCreatureName(cid), status, var, caster)
        return
    end

    if (badStatus and doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SYNCHRONIZE, nil, status, caster)) then
        doCreatureAddStatus(caster, status, var, cid)
    end

    return true
end

function getStatusAilmentVolatile(status)
    return CONDITIONS[status].volatile
end

