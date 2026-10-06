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
local POKEMON = {"Marowak", "Donphan", "Sandslash", "Dugtrio"}
local HOLES = {
    {x = 5020, y = 287, z = 7},
    {x = 5020, y = 282, z = 7},
    {x = 5028, y = 282, z = 7},
    {x = 5026, y = 287, z = 7},
}

local function doStartEvent(cid)
    for _, pos in pairs(HOLES) do
        doSendDistanceShoot(getSkyPosition(pos), pos, PROJECTILE_FIRE)
        setMonsterLevel(doCreateMonster(table.random(POKEMON), pos), 100)
        doSendMagicEffect(pos, EFFECT_FIRE_EXPLODE)
    end

end
--

function onStatsChange(cid, attacker, type, combat, value)
    if (type == STATSCHANGE_HEALTHLOSS) then
        local bl = getBattleLevel(cid)
        if ((bl >= 0 and bl <= 2) and (getCreatureHealth(cid) / getCreatureMaxHealth(cid)) <= 0.7) then
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_MOLTRES_CRY)
            doStartEvent(cid)

            addEvent(function(name, pos)
                setBattleLevel(doCreateMonster(name, pos), bl + 1)
            end, 60000, "Boss Moltres", getCreaturePosition(cid))

            doRemoveCreature(cid)
            return false
        end
    end

    return true
end
