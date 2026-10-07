local SKILL_NAME = "Extreme Speed"
local INTERVAL = 500

local function doEffect(pos)
    local dist = table.random({-4, 4})
    local from = {x = pos.x, y = pos.y, z = pos.z}
    local to = {x = pos.x, y = pos.y, z = pos .z }

    if (getRandom(0, 1) == 0) then
        from.x = from.x - dist
        to.x = to.x - dist
    else
        from.y = from.y - dist
        to.y = to.y - dist
    end

    doSendMagicEffect(from, EFFECT_TELEPORT_FRAME)
    doSendDistanceShoot(from, to, PROJECTILE_GRAVEL)
    doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
    doSendMagicEffect(to, EFFECT_TELEPORT_FRAME)
end

function onTargetCreature_ExtremeSpeed(cid, target)
    local cidPos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    if (getSameFloor(cidPos, targetPos)) then
        local pos = getPositionAdjacent(cid, targetPos, false)
        if (pos) then
            doSendDistanceShoot(getSkyPosition(pos), pos, PROJECTILE_GRAVEL)
            doTeleportThing(cid, pos, false)
            doSkillDamage(cid, target, SKILL_NAME)
        end
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ExtremeSpeed")

local invisible = createConditionObject(CONDITION_INVISIBLE, INTERVAL)

local function doSpell(cid)
    if (isCreature(cid) and hasTarget(cid)) then
        doCombat(cid, combat, numberToVariant(getCreatureTarget(cid)))
    end
end

function onCastSpell(cid, var)
    local pos = getCreaturePosition(cid)

    doAddCondition(cid, invisible)
    doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
    doSendDistanceShoot(pos, getSkyPosition(pos), PROJECTILE_GRAVEL)

    local pos = getCreaturePosition(getCreatureTarget(cid))
    for i = 0, 6 do
        addEvent(doEffect, i * (INTERVAL / 6) + 1, pos)
    end

    addEvent(doSpell, INTERVAL, cid)
    return true
end
