local SKILL_NAME = "Fell Stinger"

function onTargetCreature_FellStinger(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target) or getCreatureHealth(target) <= 0) then
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_MEDIUM, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FellStinger")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
