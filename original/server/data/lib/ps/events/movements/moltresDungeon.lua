local PROJECTILE = PROJECTILE_FIRE
local EFFECT = EFFECT_FIRE_FIELD
local AREA_CIRCLE3X3 = {
	{0, 0, 1, 1, 1, 0, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{1, 1, 1, 1, 1, 1, 1},
	{1, 1, 1, 3, 1, 1, 1},
	{1, 1, 1, 1, 1, 1, 1},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 0, 1, 1, 1, 0, 0}
}

local function doEffect(pos, cid)
    doSendDistanceShoot(getSkyPosition(pos), pos, PROJECTILE)
    addEvent(doSendMagicEffect, 300, pos, EFFECT)
    addEvent(doSendDistanceShoot, 300, pos, {x = pos.x + 1, y = pos.y, z = pos.z}, PROJECTILE)
    addEvent(doSendDistanceShoot, 300, pos, {x = pos.x - 1, y = pos.y, z = pos.z}, PROJECTILE)
    addEvent(doSendDistanceShoot, 300, pos, {x = pos.x, y = pos.y + 1, z = pos.z}, PROJECTILE)
    addEvent(doSendDistanceShoot, 300, pos, {x = pos.x, y = pos.y - 1, z = pos.z}, PROJECTILE)

    if (getSamePosition(getCreaturePosition(cid), pos)) then
        doCreatureTrueDamage(cid, -250, EFFECT_BIG_FLAMES, TEXTCOLOR_RED, pos)
    end
end

function onTargetTile_MoltresDungeon(cid, position)
    if (getRandom(0, 1) == 0) then
        doEffect(position, cid)
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile_MoltresDungeon")
setCombatArea(combat, createCombatArea(AREA_CIRCLE3X3))

local function doSpell(cid, pos)
    if (isCreature(cid)) then
        doCombat(cid, combat, positionToVariant(pos))
    end
end

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if (not isPlayer(cid) or getRandom(0, 100) > 20) then
        return true
    end

    local pos = getCreaturePosition(cid)
    local skyPos = getSkyPosition(pos)
	for i = 0, 5 do
        addEvent(doSendDistanceShoot, i * 100, pos, skyPos, PROJECTILE)
    end

    addEvent(doSpell, 1000, cid, pos)
    return true
end