local SKILL_NAME = "Power-Up Punch"

function onTargetCreature_PowerUpPunch(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_LOW, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_PowerUpPunch")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
