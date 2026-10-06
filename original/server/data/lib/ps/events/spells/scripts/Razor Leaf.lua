local SKILL_NAME = "Razor Leaf"

function onTargetCreature_RazorLeaf(cid, target)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_LEAVES)
    doSkillMultipleDamages(cid, SKILL_NAME, 3)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_RazorLeaf")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
