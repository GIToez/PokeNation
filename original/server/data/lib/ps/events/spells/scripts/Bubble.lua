local SKILL_NAME = "Bubble"

function onTargetCreature_Bubble(cid, target)
	doSkillMultipleDamages(cid, SKILL_NAME, 4)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 20 or 10)) then
        doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BAD, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Bubble")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
