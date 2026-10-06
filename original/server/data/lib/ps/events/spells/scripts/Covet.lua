local SKILL_NAME = "Covet"

function onTargetCreature_Covet(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)

    local hasHeld = false

    for slot = 1, 2 do
        if (getPokemonHeldMovePowerType(target, slot) ~= EMPTY_STORAGE) then
            hasHeld = true
            break
        end
    end

    if (hasHeld) then
        setPokemonHeldMovePowerModifier(cid, getPokemonHeldMovePowerModifier(target))
        setPokemonHeldMovePowerType(cid, getPokemonHeldMovePowerType(target))

        setPokemonHeldMovePowerModifier(target, EMPTY_STORAGE)
        setPokemonHeldMovePowerType(target, EMPTY_STORAGE)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Covet")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end