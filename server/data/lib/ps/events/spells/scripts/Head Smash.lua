local SKILL_NAME = "Head Smash"

function onTargetCreature_HeadSmash(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_HeadSmash")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
