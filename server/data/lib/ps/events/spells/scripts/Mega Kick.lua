local SKILL_NAME = "Mega Kick"

function onTargetCreature_MegaKick(cid, target)
    doSendMagicEffect(getCreaturePosition(target), EFFECT_EARTH_EXPLOSION)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MegaKick")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
