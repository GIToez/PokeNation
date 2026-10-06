local SKILL_NAME = "Lunge"

function onTargetCreature_Lunge(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_LOW, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Lunge")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
