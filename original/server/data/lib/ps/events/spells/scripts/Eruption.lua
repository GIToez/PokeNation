local SKILL_NAME = "Eruption"
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local EFFECT = getPokemonSkillEffect(SKILL_NAME)
local ROUNDS = 5

local function doEffect(pos)
    doSendDistanceShoot(getSkyPosition(pos), pos, PROJECTILE)
    addEvent(doSendMagicEffect, 300, pos, EFFECT)
    addEvent(doSendDistanceShoot, 300, pos, {x = pos.x + 1, y = pos.y, z = pos.z}, PROJECTILE)
    addEvent(doSendDistanceShoot, 300, pos, {x = pos.x - 1, y = pos.y, z = pos.z}, PROJECTILE)
    addEvent(doSendDistanceShoot, 300, pos, {x = pos.x, y = pos.y + 1, z = pos.z}, PROJECTILE)
    addEvent(doSendDistanceShoot, 300, pos, {x = pos.x, y = pos.y - 1, z = pos.z}, PROJECTILE)
end

function onTargetCreature_Eruption(cid, target)
    doEffect(getCreaturePosition(target))
    doSkillDamage(cid, target, SKILL_NAME, 150 * (getCreatureHealth(cid) / getCreatureMaxHealth(cid)))
end

function onTargetTile_Eruption(cid, position)
    if (getRandom(0, 1) == 0) then
        doEffect(position)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Eruption")
setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile_Eruption")
setCombatArea(combat, createCombatArea(AREA_CIRCLE3X3))

local function doSpell(cid)
    if (isCreature(cid)) then
        doCombat(cid, combat, positionToVariant(getCreaturePosition(cid)))
    end
end

function onCastSpell(cid, var)
	local pos = getCreaturePosition(cid)
    local skyPos = getSkyPosition(pos)
	for i = 0, ROUNDS do
        addEvent(doSendDistanceShoot, i * 100, pos, skyPos, PROJECTILE)
    end
    addEvent(doSpell, ROUNDS * 100, cid)
    return true
end
