local SKILL_NAME = "Stealth Rock"

function onTargetCreature_StealthRock(cid, target)
    local targetPos, i = getCreaturePosition(target)
    for i = 0, 10 do
        local tmpPos = {x = targetPos.x + getRandom(-7, 7), y = targetPos.y + getRandom(-7, 7), z = targetPos.z}
        doSendDistanceShoot(targetPos, tmpPos, PROJECTILE_ROCK)
        addEvent(doSendDistanceShoot, 400, tmpPos, targetPos, PROJECTILE_ROCK)
    end
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil)) then
        doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BADMEDIUM, cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_StealthRock")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end