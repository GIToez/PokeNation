local SKILL_NAME = "Wrap"

function onTargetCreature_Wrap(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil)) then
        doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BADMEDIUM, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Wrap")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
