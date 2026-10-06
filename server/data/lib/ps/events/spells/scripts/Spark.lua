local SKILL_NAME = "Spark"
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_Spark(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
        doCreatureAddStatus(target, CREATURE_STATUS_PARALYSIS, nil, cid)
    end
end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Spark")

local function doSpell(cid)
    if (isCreature(cid) and hasTarget(cid)) then
        doCombat(cid, combat, numberToVariant(getCreatureTarget(cid)))
    end
end

function onCastSpell(cid, var)
    local pos = getCreaturePosition(cid)
    executeInArea(pos, CLOCKWISE1, doSendMagicEffect, EFFECT)

    addEvent(executeInArea, 100, pos, CLOCKWISE2, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 100, pos, CLOCKWISE8, doSendMagicEffect, EFFECT)

    addEvent(executeInArea, 200, pos, CLOCKWISE3, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 200, pos, CLOCKWISE7, doSendMagicEffect, EFFECT)

    addEvent(executeInArea, 300, pos, CLOCKWISE4, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 300, pos, CLOCKWISE6, doSendMagicEffect, EFFECT)

    addEvent(executeInArea, 400, pos, CLOCKWISE5, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 400, pos, CLOCKWISE5, doSendMagicEffect, EFFECT)

    addEvent(executeInArea, 500, pos, CLOCKWISE6, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 500, pos, CLOCKWISE4, doSendMagicEffect, EFFECT)

    addEvent(executeInArea, 600, pos, CLOCKWISE7, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 600, pos, CLOCKWISE3, doSendMagicEffect, EFFECT)

    addEvent(executeInArea, 700, pos, CLOCKWISE8, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 700, pos, CLOCKWISE2, doSendMagicEffect, EFFECT)

    addEvent(doSpell, 750, cid)
	return true
end
