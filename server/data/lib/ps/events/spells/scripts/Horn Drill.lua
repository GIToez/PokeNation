local SKILL_NAME = "Horn Drill"

function onTargetCreature_HornDrill(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_HornDrill")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
