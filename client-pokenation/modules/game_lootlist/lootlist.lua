-- PokeNation loot strip. Port of the legacy PSoul game_lootlist: 0xFF 0x1A carries a list of
-- (item id, count) pairs; each entry fades out after a few seconds.

local VISIBLE_MS, FADE_MS = 5000, 1000

local panel
local received = 0

local function addEntry(itemId, count)
    local entry = g_ui.createWidget('LootEntry', panel)
    entry:setItemId(itemId)
    entry:getChildById('count'):setText(count > 1 and tostring(count) or '')
    entry.fadeEvent = scheduleEvent(function()
        g_effects.fadeOut(entry, FADE_MS)
        entry.destroyEvent = scheduleEvent(function() entry:destroy() end, FADE_MS)
    end, VISIBLE_MS)
end

local function onLootList(list)
    for itemId, count in pairs(list) do
        addEntry(itemId, count)
        received = received + 1
    end
    panel:show()
end

local function reset()
    for _, entry in ipairs(panel:getChildren()) do
        removeEvent(entry.fadeEvent)
        removeEvent(entry.destroyEvent)
    end
    panel:destroyChildren()
    received = 0
end

function getState()
    return { visible = panel:getChildCount(), received = received }
end

function init()
    g_ui.importStyle('lootlist')
    panel = g_ui.createWidget('LootListPanel', modules.game_interface.getRootPanel())
    connect(g_game, { onGameStart = reset, onGameEnd = reset, onLootList = onLootList })
end

function terminate()
    disconnect(g_game, { onGameStart = reset, onGameEnd = reset, onLootList = onLootList })
    reset()
    panel:destroy()
    panel = nil
end
