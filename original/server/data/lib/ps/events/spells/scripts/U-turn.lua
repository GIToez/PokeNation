local SKILL_NAME = "U-turn"

function onTargetCreature_Uturn(cid, target)
	local cidPos, pos = getCreaturePosition(cid), getCreaturePosition(target)

	doSendMagicEffect(cidPos, EFFECT_BLUE_CIRCLE_TWO)
	doTeleportThing(target, cidPos, false)
	doSendMagicEffect(pos, EFFECT_BLUE_CIRCLE_TWO)
	if (isWalkable(cid, pos)) then
		doTeleportThing(cid, pos, false)
	end
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Uturn")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
