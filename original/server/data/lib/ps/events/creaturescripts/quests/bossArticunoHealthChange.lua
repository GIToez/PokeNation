-- Battle Level
local BATTLE_LEVEL_STORAGE = 1000

local function getBattleLevel(cid)
    local v = getCreatureStorage(cid, BATTLE_LEVEL_STORAGE)
    return v > -1 and v or 0
end

local function setBattleLevel(cid, value)
    doCreatureSetStorage(cid, BATTLE_LEVEL_STORAGE, value)
end

--
local function doStartEvent(bl)
    local pos = {x = 5194, y = 281, z = 7}
    setBattleLevel(doCreateMonster("Frozen Boss Articuno", pos), bl + 1)
    doSendMagicEffect(pos, EFFECT_ICE_ROCK)
end
--

function onStatsChange(cid, attacker, type, combat, value)
    if (type == STATSCHANGE_HEALTHLOSS) then
        local bl = getBattleLevel(cid)
        if ((bl >= 0 and bl <= 2) and (getCreatureHealth(cid) / getCreatureMaxHealth(cid)) <= 0.7) then
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_ARTICUNO_CRY)
            addEvent(doStartEvent, 2500, getBattleLevel(cid))

            doRemoveCreature(cid)
            return false
        end
    end

    return true
end
