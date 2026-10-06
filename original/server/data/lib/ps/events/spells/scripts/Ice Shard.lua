local SKILL_NAME = "Ice Shard"

function onTargetCreature_IceShard(cid, target)
	doSkillMultipleDamages(cid, SKILL_NAME, 4)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_IceShard")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end