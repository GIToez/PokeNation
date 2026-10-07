local SKILL_NAME = "Superpower"

function onTargetCreature_Superpower(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BAD, cid)
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_BAD, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Superpower")
function onCastSpell(cid, var)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_POWER_UP)
    return doCombat(cid, combat, var)
end