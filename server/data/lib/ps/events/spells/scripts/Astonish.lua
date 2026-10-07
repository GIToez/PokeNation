local SKILL_NAME = "Astonish"
local SKILL_DISTANCE = getPokemonSkillMaxDistance(SKILL_NAME)

function onTargetCreature_Astonish(cid, target)
    local cidPos, targetPos, i = getCreaturePosition(cid), getCreaturePosition(target), 0
    for i = 0, SKILL_DISTANCE do
        addEvent(doSendDistanceShoot, 100 * (i - 1), cidPos, targetPos, PROJECTILE_TONGUE)
    end

	doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
        doCreatureAddStatus(target, CREATURE_STATUS_FLINCH, true, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Astonish")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
