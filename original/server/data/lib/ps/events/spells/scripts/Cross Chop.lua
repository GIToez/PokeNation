local SKILL_NAME = "Cross Chop"

function onTargetCreature_CrossChop(cid, target)
    doSendMagicEffect(getCreaturePosition(target), EFFECT_BIG_CROSS_UP)
	doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_CrossChop")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
