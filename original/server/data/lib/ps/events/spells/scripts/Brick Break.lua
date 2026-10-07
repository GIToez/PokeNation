local SKILL_NAME = "Brick Break"

function onTargetCreature_BrickBreak(cid, target)
	if (getCreatureStatus(target, CREATURE_STATUS_REFLECT)) then
        doCreatureRemoveStatus(target, CREATURE_STATUS_REFLECT)
    end
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_BrickBreak")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
