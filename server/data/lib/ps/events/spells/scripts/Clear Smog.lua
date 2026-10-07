local SKILL_NAME = "Clear Smog"

function onTargetCreature_ClearSmog(cid, target)
	doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil)) then
        doCreatureRemoveStatus(target, CREATURE_STATUS_LOWACCURACY)
        doCreatureRemoveStatus(target, CREATURE_STATUS_EXTRASPEED)
        doCreatureRemoveStatus(target, CREATURE_STATUS_EXTRASPATK)
        doCreatureRemoveStatus(target, CREATURE_STATUS_EXTRASPDEF)
        doCreatureRemoveStatus(target, CREATURE_STATUS_HIGHCRITICALCHANCE)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ClearSmog")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
