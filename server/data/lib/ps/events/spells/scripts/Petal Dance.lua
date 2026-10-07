local SKILL_NAME = "Petal Dance"

function onTargetCreature_PetalDance(cid, target)
	local targetPos, i = getCreaturePosition(target)
    for i = 0, 15 do
        local tmpPos = {x = targetPos.x + getRandom(-3, 3), y = targetPos.y + getRandom(-3, 3), z = targetPos.z}
        doSendDistanceShoot(targetPos, tmpPos, PROJECTILE_COLORED_LEAVES)
        addEvent(doSendDistanceShoot, 200, tmpPos, targetPos, PROJECTILE_COLORED_LEAVES)
    end
end

local function doSpell(cid, combat, var)
    if (isCreature(cid)) then
        doCombat(cid, combat, var)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_PetalDance")
function onCastSpell(cid, var)
	local i, random = 0, getRandom(2, 3)
    doSkillMultipleDamages(cid, SKILL_NAME, random, math.floor(120 / random))
    for i = 1, random do
        addEvent(doSpell, 500 * (i - 1), cid, combat, var)
    end

    local pos = getCreaturePosition(cid)
    for i = 0, 15 do
        local tmpPos = {x = pos.x + getRandom(-7, 7), y = pos.y + getRandom(-5, 5), z = pos.z}
        doSendDistanceShoot(pos, tmpPos, PROJECTILE_COLORED_LEAVES)
        addEvent(doSendDistanceShoot, 200, tmpPos, pos, PROJECTILE_COLORED_LEAVES)
    end

    addEvent(doCreatureAddStatus, 500 * (random + 1), cid, CREATURE_STATUS_CONFUSION, nil, cid)
    return true
end