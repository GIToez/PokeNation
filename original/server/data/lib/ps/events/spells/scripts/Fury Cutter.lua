local SKILL_NAME = "Fury Cutter"

function onTargetCreature_FuryCutter(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FuryCutter")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
