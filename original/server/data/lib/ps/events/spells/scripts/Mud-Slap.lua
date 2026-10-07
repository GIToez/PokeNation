local SKILL_NAME = "Mud-Slap"

function onTargetCreature_MudSlap(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil)) then
        doCreatureAddStatus(target, CREATURE_STATUS_LOWACCURACY, nil, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MudSlap")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
