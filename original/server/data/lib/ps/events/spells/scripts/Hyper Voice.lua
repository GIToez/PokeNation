local SKILL_NAME = "Hyper Voice"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

function onTargetCreature_HyperVoice(cid, target)
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SOUNDPROOF, nil)) then
        doSkillDamage(cid, target, SKILL_NAME)
    end
end

function onTargetTile_HyperVoice(cid, position)
    if (math.random(0, 1) == 1) then
        local pos = getCreaturePosition(cid)
        doSendDistanceShoot(pos, {x = position.x + math.random(-1, 1) , y = position.y + math.random(-1, 1), z = position.z}, SKILL_PROJECTILE)
        addEvent(doSendDistanceShoot, 250, pos, {x = position.x + math.random(-1, 1) , y = position.y + math.random(-1, 1), z = position.z}, SKILL_PROJECTILE)
        addEvent(doSendDistanceShoot, 500, pos, {x = position.x + math.random(-1, 1) , y = position.y + math.random(-1, 1), z = position.z}, SKILL_PROJECTILE)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_HyperVoice")
setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile_HyperVoice")
setCombatArea(combat, createCombatArea(AREA_WAVE7))

function onCastSpell(cid, var)
  return doCombat(cid, combat, var)
end