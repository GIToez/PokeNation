local SKILL_NAME = "Poison Sting"

function onTargetCreature_PoisonSting(cid, target)
	local cidPos, targetPos, i = getCreaturePosition(cid), getCreaturePosition(target), 0
    for i = 0, 5 do
        addEvent(doSendDistanceShoot, i * 100, cidPos, targetPos, PROJECTILE_EARTH_SHOT)
    end
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
	if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 60 or 30)) then
        doCreatureAddStatus(target, CREATURE_STATUS_POISON, getMonsterLevel(cid), cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_PoisonSting")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
