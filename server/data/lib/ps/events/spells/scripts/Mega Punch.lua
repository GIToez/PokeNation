local SKILL_NAME = "Mega Punch"

function onTargetCreature_MegaPunch(cid, target)
    doSendMagicEffect(getCreaturePosition(target), EFFECT_EARTH_EXPLOSION)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MegaPunch")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
