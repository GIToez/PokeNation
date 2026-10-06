local SKILL_NAME = "Tri Attack"

function onTargetCreature_TriAttack(cid, target)
	local cidPos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    doSendMagicEffect(cidPos, EFFECT_COLORED_TRIANGLE)
    addEvent(doSendDistanceShoot, 100 , cidPos, targetPos, PROJECTILE_FIRE)
    addEvent(doSendDistanceShoot, 200 , cidPos, targetPos, PROJECTILE_ICE)
    addEvent(doSendDistanceShoot, 300 , cidPos, targetPos, PROJECTILE_THUNDER)

    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 40 or 20)) then
        local condition = table.random({CREATURE_STATUS_PARALYSIS, CREATURE_STATUS_BURN, CREATURE_STATUS_FREEZE})
        doCreatureAddStatus(target, condition, (condition == CREATURE_STATUS_BURN and getMonsterLevel(cid) or nil), cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_TriAttack")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end