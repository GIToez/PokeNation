local SKILL_NAME = "Aqua Jet"

function onTargetCreature_AquaJet(cid, target)
	local cidPos, pos = getCreaturePosition(cid), getPositionAdjacent(cid, getCreaturePosition(target), false)
	doSendMagicEffect(cidPos, EFFECT_WATER_EMERGE)
	if (pos) then
		doSendDistanceShoot(cidPos, pos, PROJECTILE_WATER_BALL)
		doSendMagicEffect(cidPos, EFFECT_WATER_SPLASH)
		doTeleportThing(cid, pos, false)
		doSendMagicEffect(pos, EFFECT_WATER_SPLASH)
		doSendMagicEffect(getCreaturePos(target), EFFECT_WATER_EMERGE)
	end
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_AquaJet")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
