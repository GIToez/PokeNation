local SKILL_NAME = "Submission"

function onTargetCreature_Submission(cid, target)
	local cidPos, pos = getCreaturePosition(cid), getCreaturePosition(target)
	doTeleportThing(target, cidPos, false)
	doTeleportThing(cid, pos, false)
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Submission")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
