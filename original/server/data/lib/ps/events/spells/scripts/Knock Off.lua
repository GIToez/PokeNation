local SKILL_NAME = "Knock Off"

function onTargetCreature_KnockOff(cid, target)
    local power = getPokemonSkillDamage(SKILL_NAME)
    local hasHeld = false

    for slot = 1, 2 do
        if (getPokemonHeldMovePowerType(target, slot) ~= EMPTY_STORAGE) then
            hasHeld = true
            break
        end
    end

    if (hasHeld) then
        power = power * 2
    end

    doSkillDamage(cid, target, SKILL_NAME, power)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_KnockOff")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end