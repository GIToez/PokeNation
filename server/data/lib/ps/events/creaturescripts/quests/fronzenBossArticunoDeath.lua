-- Battle Level
local BATTLE_LEVEL_STORAGE = 1000

local function getBattleLevel(cid)
    local v = getCreatureStorage(cid, BATTLE_LEVEL_STORAGE)
    return v > -1 and v or 0
end

local function setBattleLevel(cid, value)
    doCreatureSetStorage(cid, BATTLE_LEVEL_STORAGE, value)
end

function onPrepareDeath(cid, deathList)
    local pos = getCreaturePosition(cid)

    doSendMagicEffect(pos, EFFECT_ICE_EXPLOSION)
    setBattleLevel(doCreateMonster("Boss Articuno", getCreaturePosition(cid)), getBattleLevel(cid) + 1)
    doRemoveCreature(cid)
    return false
end
