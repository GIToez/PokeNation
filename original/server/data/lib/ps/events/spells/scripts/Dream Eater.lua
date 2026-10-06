local SKILL_NAME = "Dream Eater"

function onTargetCreature_DreamEater(cid, target)
    doSendMagicEffect(getCreaturePosition(target), EFFECT_BIG_SCARY_FACE)
	doSkillHealthDrain(cid, target, SKILL_NAME, 2)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DreamEater")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
