local SKILL_NAME = "Foul Play"

function onTargetCreature_FoulPlay(cid, target)
	local pos = getCreaturePosition(target)

    doSkillDamage(cid, target, SKILL_NAME)

    addEvent(doSendMagicEffect, 50, pos, EFFECT_BIG_PUNCH_LEFT)
    addEvent(doSendMagicEffect, 100, pos, EFFECT_BIG_PUNCH_UP_LEFT)
    addEvent(doSendMagicEffect, 150, pos, EFFECT_BIG_PUNCH)
    addEvent(doSendMagicEffect, 200, pos, EFFECT_BIG_PUNCH_UP_RIGHT)
    addEvent(doSendMagicEffect, 250, pos, EFFECT_BIG_PUNCH_RIGHT)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FoulPlay")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end