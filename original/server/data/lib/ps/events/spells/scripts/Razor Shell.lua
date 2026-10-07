local SKILL_NAME = "Razor Shell"

function onTargetCreature_RazorShell(cid, target)
	doSendMagicEffect(getCreaturePosition(cid), EFFECT_YELLOW_SLASH)
    local pos = getCreaturePosition(target)
	doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 100 or 50)) then
        doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_BAD, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_RazorShell")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
