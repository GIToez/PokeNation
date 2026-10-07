-- PokeNation Pokemon status conditions. Port of the legacy PSoul game_statusbar: packets 0xFF 0x0E-0x10
-- (add itemId + duration in seconds, remove itemId, clear). Names come from PokeNation.STATUS_BY_ITEMID.

local panel
local entries = {}   -- itemId -> { widget, timeEnd, event }

local function statusName(itemId)
    return PokeNation.STATUS_BY_ITEMID[itemId] or tr('Status') .. ' ' .. itemId
end

local function removeEntry(itemId)
    local entry = entries[itemId]
    if not entry then
        return
    end
    removeEvent(entry.event)
    if entry.widget then
        entry.widget:destroy()
    end
    entries[itemId] = nil
    if panel and panel:getChildCount() == 0 then
        panel:hide()
    end
end

local function tick(itemId)
    local entry = entries[itemId]
    if not entry then
        return
    end
    local remaining = entry.timeEnd - g_clock.seconds()
    if remaining <= 0 then
        removeEntry(itemId)
        return
    end
    local widget = entry.widget
    widget:getChildById('cooldown'):setPercent((1 - remaining / entry.duration) * 100)
    local label = widget:getChildById('seconds')
    label:setText(string.format('%.0f', remaining))
    label:setColor(remaining > 3.9 and '#ffffff' or '#ff3030')
    entry.event = scheduleEvent(function() tick(itemId) end, 100)
end

local function clear()
    for itemId in pairs(entries) do
        removeEntry(itemId)
    end
    entries = {}
    if panel then
        panel:destroyChildren()
        panel:hide()
    end
end

local function onStatusBarAdd(itemId, duration)
    removeEntry(itemId)
    local widget = g_ui.createWidget('StatusSlot', panel)
    widget:setId('status' .. itemId)
    widget:getChildById('icon'):setItemId(itemId)
    widget:setTooltip(statusName(itemId))
    local entry = { widget = widget, duration = math.max(duration, 1), timeEnd = g_clock.seconds() + duration }
    entries[itemId] = entry
    if duration <= 0 then
        -- Permanent until the server removes it.
        widget:getChildById('cooldown'):setPercent(100)
        widget:getChildById('seconds'):setText('')
    else
        tick(itemId)
    end
    panel:show()
end

local function onStatusBarRemove(itemId)
    removeEntry(itemId)
end

function getStatuses()
    local list = {}
    for itemId, entry in pairs(entries) do
        list[#list + 1] = { itemId = itemId, name = statusName(itemId),
            remaining = math.max(0, entry.timeEnd - g_clock.seconds()) }
    end
    return list
end

function getWidget()
    return panel
end

function init()
    g_ui.importStyle('statusbar')
    panel = g_ui.createWidget('StatusBarPanel', modules.game_interface.getRootPanel())
    panel:hide()
    connect(g_game, {
        onGameStart = clear,
        onGameEnd = clear,
        onStatusBarAdd = onStatusBarAdd,
        onStatusBarRemove = onStatusBarRemove,
        onStatusBarClear = clear
    })
end

function terminate()
    disconnect(g_game, {
        onGameStart = clear,
        onGameEnd = clear,
        onStatusBarAdd = onStatusBarAdd,
        onStatusBarRemove = onStatusBarRemove,
        onStatusBarClear = clear
    })
    clear()
    panel:destroy()
    panel = nil
end
