local SKILL_NAME = "Psycho Boost"

function onTargetCreature_PsychoBoost(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BADMEDIUM, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_PsychoBoost")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
