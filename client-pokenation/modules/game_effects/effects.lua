-- PokeNation creature colour effects, 0xFF 0x13 (U32 creature id, U8 effect id, U32 var). Port of the legacy
-- PSoul game_effects. The legacy client had a C++ Creature:setOutfitColor(color, fadeMs) that
-- interpolated the outfit tint; Redemption has no equivalent, so the tint is drawn with the stock
-- Thing:setMarked overlay and cleared after the same duration (no gradual fade). The ghost copies the
-- legacy client created for RED_COPY_FADE_OUT and EVOLVE are not reproduced; the creature itself is
-- tinted instead.

local Effect = {
    RED_COPY_FADE_OUT = 0,
    RED_FADE_IN = 1,
    BURN = 2,
    FREEZE = 3,
    POISON = 4,
    BADPOISON = 5,
    HIGHCRITICALCHANCE = 6, -- CHARGE shares id 6 on the server
    GRAY = 7,
    PURPLE = 8,
    EVOLVE = 9
}

local TINTS = {
    [Effect.RED_COPY_FADE_OUT] = { '#ff0f0096', 700 },
    [Effect.RED_FADE_IN] = { '#ff0f0096', 700 },
    [Effect.BURN] = { '#ff6000' },
    [Effect.FREEZE] = { '#00b4ff' },
    [Effect.POISON] = { '#30e927' },
    [Effect.BADPOISON] = { '#a227e9' },
    [Effect.HIGHCRITICALCHANCE] = { '#e92c27' },
    [Effect.GRAY] = { '#969696' },
    [Effect.PURPLE] = { '#9617ba' },
    [Effect.EVOLVE] = { '#000000c0', 5000 }
}

local pending = {}  -- creature id -> scheduled clear event
local received = {} -- effect id -> count this session

local function clearTint(creature)
    local id = creature:getId()
    removeEvent(pending[id])
    pending[id] = nil
    creature:setMarked('white')
end

local function onCreatureEffect(creature, effectId, var)
    received[effectId] = (received[effectId] or 0) + 1
    local tint = TINTS[effectId]
    if not tint or not creature:getPosition() then
        return
    end
    local duration = tint[2] or var
    if not duration or duration <= 0 then
        duration = 700
    end
    local id = creature:getId()
    removeEvent(pending[id])
    creature:setMarked(tint[1])
    pending[id] = scheduleEvent(function()
        pending[id] = nil
        creature:setMarked('white')
    end, duration)
end

local function reset()
    for _, event in pairs(pending) do
        removeEvent(event)
    end
    pending = {}
    received = {}
end

function getReceived(effectId)
    return received[effectId] or 0
end

function getEffectIds()
    return Effect
end

function init()
    connect(Creature, { onEffect = onCreatureEffect })
    connect(g_game, { onGameEnd = reset })
end

function terminate()
    disconnect(Creature, { onEffect = onCreatureEffect })
    disconnect(g_game, { onGameEnd = reset })
    reset()
end
