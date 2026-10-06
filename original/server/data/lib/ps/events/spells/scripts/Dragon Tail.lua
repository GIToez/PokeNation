local SKILL_NAME = "Dragon Tail"

function onTargetCreature_DragonTail(cid, target)
	doSendMagicEffect(getCreaturePosition(target), EFFECT_EARTH_EXPLOSION)
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DragonTail")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
