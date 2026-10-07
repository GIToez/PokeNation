local SKILL_NAME = "Ice Fang"

function onTargetCreature_IceFang(cid, target)
	doSendMagicEffect(getCreaturePosition(target), EFFECT_FREEZE)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
	if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil)) then
        local rand = (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 20 or 10)
        if (getRandom(0, 100) <= rand) then
            doCreatureAddStatus(target, CREATURE_STATUS_FREEZE, nil, cid)
        end
        if (getRandom(0, 100) <= rand) then
            doCreatureAddStatus(target, CREATURE_STATUS_FLINCH, nil, cid)
        end
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_IceFang")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
