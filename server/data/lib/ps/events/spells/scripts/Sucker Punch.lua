local SKILL_NAME = "Sucker Punch"

function onTargetCreature_SuckerPunch(cid, target)
	local targetPos = getCreaturePosition(target)
    doSendDistanceShoot({x = targetPos.x + 7, y = targetPos.y, z = targetPos.z}, targetPos, PROJECTILE_SHADOW_PUNCH)
    doSendDistanceShoot({x = targetPos.x - 7, y = targetPos.y, z = targetPos.z}, targetPos, PROJECTILE_SHADOW_PUNCH)
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SuckerPunch")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
