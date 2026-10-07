local SKILL_NAME = "Roost"
local EFFECT = EFFECT_WHITE_WIND

function onTargetCreature_Roost(cid, target)
	doCreatureAddHealth(cid, math.ceil((getCreatureMaxHealth(cid) / 2)))
    setPokemonCustomType(cid, ELEMENT_NORMAL)

    local pos = getCreaturePosition(cid)
    executeInArea(pos, CLOCKWISE1, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, BATTLE_ROUND_INTERVAL / 7 * 1, pos, CLOCKWISE2, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, BATTLE_ROUND_INTERVAL / 7 * 2, pos, CLOCKWISE3, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, BATTLE_ROUND_INTERVAL / 7 * 3, pos, CLOCKWISE4, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, BATTLE_ROUND_INTERVAL / 7 * 4, pos, CLOCKWISE5, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, BATTLE_ROUND_INTERVAL / 7 * 5, pos, CLOCKWISE6, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, BATTLE_ROUND_INTERVAL / 7 * 6, pos, CLOCKWISE7, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, BATTLE_ROUND_INTERVAL / 7 * 7, pos, CLOCKWISE8, doSendMagicEffect, EFFECT)
    addEvent(function(cid)
        if (isCreature(cid)) then
            setPokemonCustomType(cid, nil) -- Reset
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_RED_BUFF)
        end
    end, BATTLE_ROUND_INTERVAL, cid)
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Roost")
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
