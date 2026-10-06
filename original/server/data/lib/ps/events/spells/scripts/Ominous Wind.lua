local SKILL_NAME = "Ominous Wind"
local EFFECT = getPokemonSkillEffect(SKILL_NAME)
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

function onTargetCreature_OminousWind(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
end

function onTargetTile_OminousWind(cid, position)
    for i = 0, 4 do
        local tmpPos = {x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2), z = position.z}
        doSendDistanceShoot(position, tmpPos, PROJECTILE)
        addEvent(doSendMagicEffect, 300, tmpPos, EFFECT)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_OminousWind")
setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile_OminousWind")
setCombatArea(combat, createCombatArea(AREA_CIRCLE3X3))

function onCastSpell(cid, var)
	if (getRandom(0, 100) <= 10) then
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_LOW, cid)
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_LOW, cid)
        doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_LOW, cid)
    end
    return doCombat(cid, combat, var)
end
