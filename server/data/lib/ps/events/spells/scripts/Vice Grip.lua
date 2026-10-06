local SKILL_NAME = "Vice Grip"

function onTargetCreature_ViceGrip(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ViceGrip")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
