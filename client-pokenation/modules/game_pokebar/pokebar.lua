-- PokeNation Pokemon team bar. Port of the legacy PSoul game_pokebar (client/modules/game_pokebar):
-- same packets (0xFF 0x04-0x08), same server commands ("/cp N" summon/return/switch, "/pd N" details).
-- Differences: layout containers instead of hand-placed anchors, empty slots up to the team size,
-- fainted / in-use states, a context menu and a details request.
--
-- Server data per slot: portrait item id, fastcall number, label colour and label text ("85%",
-- "FNT", "USE"). Species comes from the client table (pokenation_lib/pokemon.lua). Level, nickname
-- and absolute HP are not part of the bar packets; the details window (game_pokemondetails) shows
-- what the server sends for "/pd N".

local TEAM_SIZE = 6
local HORIZONTAL, VERTICAL = 0, 1
local POSITION_SETTING = 'pokebar-pos'
local ORIENTATION_SETTING = 'pokebar-orientation'

local HEALTH_COLORS = {
    [PokeNation.BarTextColor.Healthy] = '#3ad15a',
    [PokeNation.BarTextColor.Hurt] = '#d6c629',
    [PokeNation.BarTextColor.Critical] = '#e03a3a'
}

local bar
local orientation = HORIZONTAL
local slots = {}     -- ordered list of { fastcall, itemId, color, text, widget }
local inUse          -- fastcall number of the summoned Pokemon ("USE" label)

local function healthColorByPercent(percent)
    if percent >= 80 then
        return HEALTH_COLORS[PokeNation.BarTextColor.Healthy]
    elseif percent >= 40 then
        return HEALTH_COLORS[PokeNation.BarTextColor.Hurt]
    end
    return HEALTH_COLORS[PokeNation.BarTextColor.Critical]
end

local function findSlot(fastcall)
    for index, slot in ipairs(slots) do
        if slot.fastcall == fastcall then
            return slot, index
        end
    end
end

local function speciesName(slot)
    local name = getPokemonNameByIconItemId(slot.itemId)
    return name ~= '' and name or tr('Pokemon')
end

local function isFainted(slot)
    return slot.text == 'FNT'
end

local function refreshSlot(slot)
    local widget = slot.widget
    if not widget then
        return
    end
    local portrait = widget:getChildById('portrait')
    local label = widget:getChildById('health')
    portrait:setItemId(slot.itemId)
    label:setText(slot.text or '')
    label:setColor(HEALTH_COLORS[slot.color] or '#ffffff')
    portrait:setOpacity(isFainted(slot) and 0.35 or 1)
    widget:setOn(inUse == slot.fastcall)

    local state = isFainted(slot) and tr('fainted') or (slot.text or '')
    if inUse == slot.fastcall then
        state = state .. ', ' .. tr('summoned')
    end
    widget:setTooltip(string.format('%s (%s)\n%s', speciesName(slot), state,
        tr('Click: summon / return. Shift+click or right-click: details.')))
end

function summon(fastcall)
    return PokeNation.say('/cp ' .. fastcall)
end

function requestDetails(fastcall)
    local slot = findSlot(fastcall)
    if modules.game_pokemondetails and slot then
        modules.game_pokemondetails.request(fastcall, slot.itemId, speciesName(slot))
    end
    return PokeNation.say('/pd ' .. fastcall)
end

local function showMenu(slot, mousePosition)
    local menu = g_ui.createWidget('PopupMenu')
    menu:setGameMenu(true)
    menu:addOption(inUse == slot.fastcall and tr('Return') or tr('Summon'), function() summon(slot.fastcall) end)
    menu:addOption(tr('Details'), function() requestDetails(slot.fastcall) end)
    menu:addSeparator()
    menu:addOption(tr('Switch orientation'), switchOrientation)
    menu:display(mousePosition)
end

local function relayout()
    bar:destroyChildren()
    for _, slot in ipairs(slots) do
        local widget = g_ui.createWidget('PokeBarSlot', bar)
        widget:setId('poke' .. slot.fastcall)
        slot.widget = widget
        widget.onMouseRelease = function(self, mousePosition, mouseButton)
            if not self:containsPoint(mousePosition) then
                return false
            end
            if mouseButton == MouseRightButton then
                showMenu(slot, mousePosition)
            elseif g_keyboard.isShiftPressed() then
                requestDetails(slot.fastcall)
            else
                summon(slot.fastcall)
            end
            return true
        end
        refreshSlot(slot)
    end
    for i = #slots + 1, TEAM_SIZE do
        local empty = g_ui.createWidget('PokeBarSlot', bar)
        empty:setId('empty' .. i)
        empty:setEnabled(false)
        empty:setTooltip(tr('Empty team slot'))
    end
end

local function applyOrientation()
    local layout
    if orientation == VERTICAL then
        layout = UIVerticalLayout.create(bar)
    else
        layout = UIHorizontalLayout.create(bar)
    end
    layout:setFitChildren(true)
    bar:setLayout(layout)
end

function switchOrientation()
    orientation = orientation == HORIZONTAL and VERTICAL or HORIZONTAL
    applyOrientation()
end

local function show()
    bar:show()
    bar:raise()
end

local function reset()
    slots = {}
    inUse = nil
    bar:destroyChildren()
end

-- Server events (OPCODES.md section 5)
local function onPokemonBarAdd(itemId, fastcall, color, text)
    local slot = findSlot(fastcall)
    if not slot then
        slot = { fastcall = fastcall }
        slots[#slots + 1] = slot
    end
    slot.itemId = itemId
    slot.color = color
    slot.text = text
    if color == PokeNation.BarTextColor.InUse then
        -- An added Pokemon is never the summoned one; keep the label readable.
        slot.color = PokeNation.BarTextColor.Healthy
    end
    relayout()
    show()
end

local function onPokemonBarRemove(fastcall)
    local _, index = findSlot(fastcall)
    if index then
        table.remove(slots, index)
    end
    if inUse == fastcall then
        inUse = nil
    end
    relayout()
end

local function onPokemonBarUpdate(fastcall, color, text)
    local slot = findSlot(fastcall)
    if not slot then
        return
    end
    if color == PokeNation.BarTextColor.InUse then
        -- "USE" marks the summoned Pokemon; the label keeps its last health text.
        local previous = inUse and findSlot(inUse)
        inUse = fastcall
        if previous and previous ~= slot then
            refreshSlot(previous)
        end
    else
        if inUse == fastcall then
            inUse = nil
        end
        slot.color = color
        slot.text = text
    end
    refreshSlot(slot)
end

local function onPokemonBarOpen()
    if #slots == 0 then
        relayout()
    end
    show()
end

local function onPokemonBarClose()
    bar:hide()
    reset()
end

local function onSummonHealthChange(creature, healthPercent)
    if not inUse or not creature:isLocalPlayerSummon() then
        return
    end
    local slot = findSlot(inUse)
    if not slot or not slot.widget then
        return
    end
    local label = slot.widget:getChildById('health')
    label:setText(healthPercent .. '%')
    label:setColor(healthColorByPercent(healthPercent))
end

local function onGameStart()
    reset()
    bar:hide()
end

local function onGameEnd()
    reset()
    bar:hide()
end

-- Read-only view for tests and other modules.
function getSlots()
    local list = {}
    for _, slot in ipairs(slots) do
        list[#list + 1] = { fastcall = slot.fastcall, itemId = slot.itemId, color = slot.color, text = slot.text,
            name = speciesName(slot), inUse = inUse == slot.fastcall, fainted = isFainted(slot) }
    end
    return list
end

function getInUse()
    return inUse
end

function getWidget()
    return bar
end

function init()
    g_ui.importStyle('pokebar')
    bar = g_ui.createWidget('PokeBarWindow', modules.game_interface.getRootPanel())
    bar:hide()
    orientation = g_settings.getNumber(ORIENTATION_SETTING, HORIZONTAL)
    applyOrientation()
    scheduleEvent(function() bar.moved = PokeNation.loadWidgetPosition(bar, POSITION_SETTING) end, 100)
    bar.onDragLeave = function() bar.moved = true end

    bar.onMouseRelease = function(self, mousePosition, mouseButton)
        if mouseButton == MouseRightButton then
            local menu = g_ui.createWidget('PopupMenu')
            menu:setGameMenu(true)
            menu:addOption(tr('Switch orientation'), switchOrientation)
            menu:display(mousePosition)
            return true
        end
        return false
    end

    connect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd,
        onPokemonBarAdd = onPokemonBarAdd,
        onPokemonBarRemove = onPokemonBarRemove,
        onPokemonBarUpdate = onPokemonBarUpdate,
        onPokemonBarOpen = onPokemonBarOpen,
        onPokemonBarClose = onPokemonBarClose
    })
    connect(Creature, { onHealthPercentChange = onSummonHealthChange })
end

function terminate()
    disconnect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd,
        onPokemonBarAdd = onPokemonBarAdd,
        onPokemonBarRemove = onPokemonBarRemove,
        onPokemonBarUpdate = onPokemonBarUpdate,
        onPokemonBarOpen = onPokemonBarOpen,
        onPokemonBarClose = onPokemonBarClose
    })
    disconnect(Creature, { onHealthPercentChange = onSummonHealthChange })
    if bar.moved then
        g_settings.set(POSITION_SETTING, bar:getPosition())
    end
    g_settings.set(ORIENTATION_SETTING, orientation)
    bar:destroy()
    bar = nil
end
