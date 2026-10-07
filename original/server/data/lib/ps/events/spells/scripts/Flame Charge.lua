local SKILL_NAME = "Flame Charge"
local EFFECT = getPokemonSkillEffect(SKILL_NAME)
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

function onTargetCreature_FlameCharge(cid, target)
    local cidPos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    if (getSameFloor(cidPos, targetPos)) then
        local pos = getPositionAdjacent(cid, targetPos, false)
        if (pos) then
            doSendDistanceShoot(getCreaturePosition(cid), targetPos, PROJECTILE)
            doTeleportThing(cid, pos, false)
            doSkillDamage(cid, target, SKILL_NAME)
            doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPEED, nil, cid)
        end
    end
end
local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_FlameCharge")

local function doSpell(cid)
    if (isCreature(cid) and hasTarget(cid)) then
        doCombat(cid, combat, numberToVariant(getCreatureTarget(cid)))
    end
end

function onCastSpell(cid, var)
    local pos = getCreaturePosition(cid)
    executeInArea(pos, CLOCKWISE1, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 100, pos, CLOCKWISE2, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 200, pos, CLOCKWISE3, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 300, pos, CLOCKWISE4, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 400, pos, CLOCKWISE5, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 500, pos, CLOCKWISE6, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 600, pos, CLOCKWISE7, doSendMagicEffect, EFFECT)
    addEvent(executeInArea, 700, pos, CLOCKWISE8, doSendMagicEffect, EFFECT)
    addEvent(doSpell, 700, cid)
	return true
end
