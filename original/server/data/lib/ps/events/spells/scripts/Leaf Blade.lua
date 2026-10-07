local SKILL_NAME = "Leaf Blade"

function onTargetCreature_LeafBlade(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_LeafBlade")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
