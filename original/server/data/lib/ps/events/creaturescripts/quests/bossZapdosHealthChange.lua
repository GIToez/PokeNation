-- Battle Level
local BATTLE_LEVEL_STORAGE = 1000

local function getBattleLevel(cid)
    local v = getCreatureStorage(cid, BATTLE_LEVEL_STORAGE)
    return v > -1 and v or 0
end

function setBattleLevel(cid, value)
    doCreatureSetStorage(cid, BATTLE_LEVEL_STORAGE, value)
end

--
local PROJECTILE = PROJECTILE_THUNDER
local EFFECT = EFFECT_ELECTRIC_SPARK
local AREA_CIRCLE3X3 = {
	{0, 0, 1, 1, 1, 0, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{1, 1, 1, 1, 1, 1, 1},
	{1, 1, 1, 3, 1, 1, 1},
	{1, 1, 1, 1, 1, 1, 1},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 0, 1, 1, 1, 0, 0}
}

local function doEffect(pos)
    doSendDistanceShoot(getSkyPosition(pos), pos, PROJECTILE)
    addEvent(doSendMagicEffect, 300, pos, EFFECT)
    addEvent(doSendDistanceShoot, 300, pos, {x = pos.x + 1, y = pos.y, z = pos.z}, PROJECTILE)
    addEvent(doSendDistanceShoot, 300, pos, {x = pos.x - 1, y = pos.y, z = pos.z}, PROJECTILE)
    addEvent(doSendDistanceShoot, 300, pos, {x = pos.x, y = pos.y + 1, z = pos.z}, PROJECTILE)
    addEvent(doSendDistanceShoot, 300, pos, {x = pos.x, y = pos.y - 1, z = pos.z}, PROJECTILE)
end

function onTargetTile_ZapdosDungeon(cid, position)
    if (getRandom(0, 1) == 0) then
        doEffect(position)

        if (getSamePosition(getCreaturePosition(cid), position)) then
            doCreatureTrueDamage(cid, -150, EFFECT_ELECTRIC_CLOUD, TEXTCOLOR_YELLOW, position)
        end
    end
end

local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile_ZapdosDungeon")
setCombatArea(combat, createCombatArea(AREA_CIRCLE3X3))

local function doSpell(cid, pos)
    if (isCreature(cid)) then
        doCombat(cid, combat, positionToVariant(pos))
    end
end

function doStartDischarge(cid)
    for j = 0, 10 do
        addEvent(function()
            local pos = getCreaturePosition(cid)
            local skyPos = getSkyPosition(pos)
            for i = 0, 5 do
                addEvent(doSendDistanceShoot, i * 100, pos, skyPos, PROJECTILE)
            end

            addEvent(doSpell, 1000, cid, pos)
        end, j * 900)
    end
end
--

function onStatsChange(cid, attacker, type, combat, value)
    if (type == STATSCHANGE_HEALTHLOSS) then
        local bl = getBattleLevel(cid)
        if ((bl >= 0 and bl <= 2) and (getCreatureHealth(cid) / getCreatureMaxHealth(cid)) <= 0.7) then
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_ZAPDOS_CRY)
            doStartDischarge(getCreatureMaster(attacker))

            addEvent(function(name, pos)
                setBattleLevel(doCreateMonster(name, pos), bl + 1)
            end, 10000, "Boss Zapdos", getCreaturePosition(cid))

            doRemoveCreature(cid)
            return false
        end
    end

    return true
end
