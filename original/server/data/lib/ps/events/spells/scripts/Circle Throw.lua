local SKILL_NAME = "Circle Throw"

function onTargetCreature_CircleThrow(cid, target)
	local cidPos, pos = getCreaturePosition(cid), getCreaturePosition(target)

	doSendMagicEffect(cidPos, EFFECT_JUMP)
	doTeleportThing(target, cidPos, false)
	doSendMagicEffect(pos, EFFECT_JUMP)
	if (isWalkable(cid, pos)) then
		doTeleportThing(cid, pos, false)
	end
	doSkillDamage(cid, target, SKILL_NAME, power)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_CircleThrow")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
