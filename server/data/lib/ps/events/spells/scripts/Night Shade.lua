local SKILL_NAME = "Night Shade"

function onTargetCreature_NightShade(cid, target)
	local pos = getCreaturePosition(target)
	doSendMagicEffect({x = pos.x + 1, y = pos.y, z = pos.z}, EFFECT_NIGHT_SHADE_BALL)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_NightShade")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
