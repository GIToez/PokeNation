local SKILL_NAME = "Hypnosis"

function onTargetCreature_Hypnosis(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
	doCreatureAddStatus(target, CREATURE_STATUS_SLEEP, nil, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Hypnosis")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
