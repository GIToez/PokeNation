local SKILL_NAME = "Double Hit"

function onTargetCreature_DoubleHit(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DoubleHit")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
