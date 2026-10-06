local SKILL_NAME = "Smelling Salts"

function onTargetCreature_SmellingSalts(cid, target)
    local power = getPokemonSkillDamage(SKILL_NAME)

    if (getCreatureStatus(target, CREATURE_STATUS_PARALYSIS)) then
        power = power * 2
        doCreatureRemoveStatus(target, CREATURE_STATUS_PARALYSIS)
    end

    doSkillDamage(cid, target, SKILL_NAME, power)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SmellingSalts")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
