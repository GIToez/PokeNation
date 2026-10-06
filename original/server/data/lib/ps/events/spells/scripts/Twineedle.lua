local SKILL_NAME = "Twineedle"

function onTargetCreature_Twineedle(cid, target)
	doSkillMultipleDamages(cid, SKILL_NAME, 2)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 40 or 20)) then
        doCreatureAddStatus(target, CREATURE_STATUS_POISON, getMonsterLevel(cid), cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Twineedle")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end