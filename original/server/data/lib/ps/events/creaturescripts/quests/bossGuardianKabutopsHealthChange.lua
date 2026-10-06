-- Battle Level
local BATTLE_LEVEL_STORAGE = 1000

local function getBattleLevel(cid)
    local v = getCreatureStorage(cid, BATTLE_LEVEL_STORAGE)
    return v > -1 and v or 0
end

function setBattleLevel(cid, value)
    doCreatureSetStorage(cid, BATTLE_LEVEL_STORAGE, value)
end

-- Spells
-- Special 1
local SP1_AREAS = {
    createCombatArea({
        {1, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 2, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 1},
    }),
    createCombatArea({
        {1, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 2, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 1},
    }),
    createCombatArea({
        {0, 1, 0, 0, 0, 1, 0},
        {0, 1, 0, 0, 0, 1, 0},
        {0, 1, 0, 0, 0, 1, 0},
        {0, 1, 0, 2, 0, 1, 0},
        {0, 1, 0, 0, 0, 1, 0},
        {0, 1, 0, 0, 0, 1, 0},
        {0, 1, 0, 0, 0, 1, 0},
    }),
    createCombatArea({
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 1, 2, 1, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
    }),
    createCombatArea({
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 3, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
    }),
}

local SP1_COMBATS = {}
for i, area in ipairs(SP1_AREAS) do
    SP1_COMBATS[i] = createCombatObject()
    onTargetTile_GuardianKabutops = function(cid, pos)
        local target = getTopCreature(pos).uid
        if (isCreature(target)) then
            doCreatureTrueDamage(target, -(math.floor(getCreatureHealth(target) * 0.9)), EFFECT_GUARDIAN_KABUTOPS_EMERGE_PARCIAL, COLOR_RED, pos)
        end
    end
    setCombatCallback(SP1_COMBATS[i], CALLBACK_PARAM_TARGETTILE,  "onTargetTile_GuardianKabutops")
    setCombatParam(SP1_COMBATS[i], COMBAT_PARAM_EFFECT, EFFECT_BONE_EMERGE_FULL)
    setCombatArea(SP1_COMBATS[i], area)
end
-- Special 2
local SP2_AREAS = {
    createCombatArea({
        {1, 0, 0, 0, 0, 0, 0},
        {0, 1, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 0, 0, 0},
        {0, 0, 0, 2, 0, 0, 0},
        {0, 0, 0, 0, 1, 0, 0},
        {0, 0, 0, 0, 0, 1, 0},
        {0, 0, 0, 0, 0, 0, 1},
    }),
    createCombatArea({
        {0, 1, 0, 0, 0, 0, 0},
        {0, 1, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 0, 0, 0},
        {0, 0, 0, 2, 0, 0, 0},
        {0, 0, 0, 0, 1, 0, 0},
        {0, 0, 0, 0, 1, 0, 0},
        {0, 0, 0, 0, 0, 1, 0},
    }),
    createCombatArea({
        {0, 0, 1, 0, 0, 0, 0},
        {0, 0, 1, 0, 0, 0, 0},
        {0, 0, 1, 0, 0, 0, 0},
        {0, 0, 0, 2, 0, 0, 0},
        {0, 0, 0, 0, 1, 0, 0},
        {0, 0, 0, 0, 1, 0, 0},
        {0, 0, 0, 0, 1, 0, 0},
    }),
    createCombatArea({
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 2, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
    }),
    createCombatArea({
        {0, 0, 0, 0, 0, 1, 0},
        {0, 0, 0, 0, 1, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 2, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 1, 0, 0, 0, 0},
        {0, 1, 0, 0, 0, 0, 0},
    }),
    createCombatArea({
        {0, 0, 0, 0, 0, 0, 1},
        {0, 0, 0, 0, 0, 1, 0},
        {0, 0, 0, 0, 1, 0, 0},
        {0, 0, 0, 2, 0, 0, 0},
        {0, 0, 1, 0, 0, 0, 0},
        {0, 1, 0, 0, 0, 0, 0},
        {1, 0, 0, 0, 0, 0, 0},
    }),
    createCombatArea({
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 1},
        {0, 0, 0, 0, 1, 1, 0},
        {0, 0, 0, 2, 0, 0, 0},
        {0, 1, 1, 0, 0, 0, 0},
        {1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
    }),
    createCombatArea({
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {1, 1, 1, 2, 1, 1, 1},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
    }),
    createCombatArea({
        {0, 0, 0, 0, 0, 0, 0},
        {1, 0, 0, 0, 0, 0, 0},
        {0, 1, 0, 0, 0, 0, 0},
        {0, 0, 1, 2, 1, 0, 0},
        {0, 0, 0, 0, 0, 1, 0},
        {0, 0, 0, 0, 0, 0, 1},
        {0, 0, 0, 0, 0, 0, 0},
    }),
}

local SP2_COMBATS = {}
for i, area in ipairs(SP2_AREAS) do
    SP2_COMBATS[i] = createCombatObject()
    onTargetTile_GuardianKabutops = function(cid, pos)
        local target = getTopCreature(pos).uid
        if (isCreature(target)) then
            doCreatureTrueDamage(target, -(math.floor(getCreatureHealth(target) * 0.3)), EFFECT_GUARDIAN_KABUTOPS_EMERGE_PARCIAL, COLOR_RED, pos)
        end
    end
    setCombatCallback(SP2_COMBATS[i], CALLBACK_PARAM_TARGETTILE,  "onTargetTile_GuardianKabutops")
    setCombatParam(SP2_COMBATS[i], COMBAT_PARAM_EFFECT, EFFECT_BONE_EMERGE_FULL)
    setCombatArea(SP2_COMBATS[i], area)
end
--
local function doSpell(cid, combat, pos)
    if (isCreature(cid)) then
        doCombat(cid, combat, positionToVariant(pos))
    end
end

local function startSpecial(cid, combats)
    for i, combat in ipairs(combats) do
        addEvent(doSpell, (4500 / #combats) * (i - 1) + 1, cid, combat, getCreaturePosition(cid))
    end
end
--

function onStatsChange(cid, attacker, type, combat, value)
    if (type == STATSCHANGE_HEALTHLOSS) then
        local bl = getBattleLevel(cid)
        if ((bl >= 0 and bl <= 3) and (getCreatureHealth(cid) / getCreatureMaxHealth(cid)) <= 0.7) then
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_GUARDIAN_KABUTOPS_HIDE)

            addEvent(startSpecial, 1000, getCreatureMaster(attacker), getRandom(0, 1) == 0 and SP1_COMBATS or SP2_COMBATS)

            local pos = getCreaturePosition(cid)
            addEvent(doSendMagicEffect, 6500, pos, EFFECT_GUARDIAN_KABUTOPS_EMERGE_FULL)
            addEvent(function(pos) setBattleLevel(doCreateMonster("Guardian Kabutops", pos), bl + 1) end, 9000, pos)

            doRemoveCreature(cid)
            return false
        end
    end

    return true
end
