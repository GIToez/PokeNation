local SKILL_NAME = "Disarming Voice"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

function onTargetCreature_DisarmingVoice(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
end

function onTargetTile_DisarmingVoice(cid, position)
    if (math.random(0, 1) == 1) then
        local pos = getCreaturePosition(cid)
        doSendDistanceShoot(pos, { x = position.x + math.random(-1, 1), y = position.y + math.random(-1, 1), z = position.z }, SKILL_PROJECTILE)
        addEvent(doSendDistanceShoot, 250, pos, { x = position.x + math.random(-1, 1), y = position.y + math.random(-1, 1), z = position.z }, SKILL_PROJECTILE)
        addEvent(doSendDistanceShoot, 500, pos, { x = position.x + math.random(-1, 1), y = position.y + math.random(-1, 1), z = position.z }, SKILL_PROJECTILE)
        doSendMagicEffect(position, EFFECT_LOVE_HEARTS_FOUR)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_DisarmingVoice")
setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile_DisarmingVoice")
setCombatArea(combat, createCombatArea(AREA_WAVE7))

function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end