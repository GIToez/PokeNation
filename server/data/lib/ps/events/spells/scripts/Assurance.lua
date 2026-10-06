local SKILL_NAME = "Assurance"

function onTargetCreature_Assurance(cid, target)
	local cidPos, pos = getCreaturePosition(cid), getPositionAdjacent(cid, getCreaturePosition(target), false)
	if (pos) then
		doSendDistanceShoot(cidPos, pos, PROJECTILE_GRAVEL)
		doSendMagicEffect(cidPos, EFFECT_TELEPORT_FRAME)
		doTeleportThing(cid, pos, false)
		doSendMagicEffect(getCreaturePosition(target), EFFECT_TELEPORT_FRAME)
	end
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Assurance")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
