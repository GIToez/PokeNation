local SKILL_NAME = "Bubblebeam"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

function onTargetCreature_Bubblebeam(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
            (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 20 or 10)) then
        doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BAD, cid)
    end
end
function onTargetTile_Bubblebeam(cid, position)
    if (math.random(0, 1) == 1) then
        local pos = getCreaturePosition(cid)
        doSendDistanceShoot(pos, {x = position.x + math.random(-1, 1) , y = position.y + math.random(-1, 1), z = position.z}, SKILL_PROJECTILE)
        addEvent(doSendDistanceShoot, 250, pos, {x = position.x + math.random(-1, 1) , y = position.y + math.random(-1, 1), z = position.z}, SKILL_PROJECTILE)
        addEvent(doSendDistanceShoot, 500, pos, {x = position.x + math.random(-1, 1) , y = position.y + math.random(-1, 1), z = position.z}, SKILL_PROJECTILE)
    end
end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Bubblebeam")
setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile_Bubblebeam")
setCombatArea(combat, createCombatArea(AREA_WAVE7))

function onCastSpell(cid, var)
  return doCombat(cid, combat, var)
end