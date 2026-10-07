-- PokeNation Pokemon move bar. Port of the legacy PSoul game_pokemoves (client/modules/game_pokemoves):
-- same packets (0xFF 0x01 moves, 0xFF 0x09 cooldown) and the same server commands ("mN" uses the
-- N-th move of the list, "/sd <iconId>" asks for the move description).
--
-- The server sends only the icon ids of the moves the summoned Pokemon may use (locked moves after
-- the TM / egg-move slots are left out, server lib/ps/functions/player.lua doUpdatePokemonMoves).
-- Energy cost, cooldown and type are learned from the "/sd" answer (shift+click) and required
-- levels / missing energy from the server's refusal messages; the server stays authoritative.
--
-- Keyboard: F1-F12 use m1-m12 and Shift+F1-F4 use m13-m16 (the legacy client needed the player to
-- create these hotkeys by hand). Function keys never collide with WASD or arrow-key walking.

local HORIZONTAL, VERTICAL = 0, 1
local POSITION_SETTING = 'pokemoves-pos'
local ORIENTATION_SETTING = 'pokemoves-orientation'
local REFUSAL_WINDOW_MS = 2000

local window
local orientation = HORIZONTAL
local moves = {}          -- index -> { iconId, name, widget, cooldownEnd, cooldownTotal, event, info, lockedLevel }
local moveInfo = {}       -- iconId -> parsed "/sd" answer, kept for the session
local lastUsed            -- { index, time } of the last move order, to match refusal messages
local pendingDetails      -- iconId of the last "/sd" request
local boundKeys = {}

local keyForIndex = PokeNation.moveKey

local function updateTooltip(move)
    local lines = { move.name ~= '' and move.name or tr('Move %d', move.index) }
    local info = moveInfo[move.iconId]
    if info then
        lines[#lines + 1] = info.summary
    end
    if move.lockedLevel then
        lines[#lines + 1] = tr('Requires level %d', move.lockedLevel)
    end
    if move.missingEnergy then
        lines[#lines + 1] = tr('Needs %d energy', move.missingEnergy)
    end
    local key = keyForIndex(move.index)
    lines[#lines + 1] = tr('Click or %s: use. Shift+click: details.', key or '-')
    move.widget:setTooltip(table.concat(lines, '\n'))
end

local function stopCooldown(move)
    if move.event then
        removeEvent(move.event)
        move.event = nil
    end
    move.cooldownEnd = nil
    if move.widget then
        move.widget:getChildById('cooldown'):hide()
        move.widget:getChildById('cooldownText'):setText('')
    end
end

local function tickCooldown(move)
    move.event = nil
    if not move.cooldownEnd or not move.widget then
        return
    end
    local remaining = move.cooldownEnd - g_clock.millis()
    if remaining <= 0 then
        stopCooldown(move)
        return
    end
    local rect = move.widget:getChildById('cooldown')
    rect:show()
    rect:setPercent(100 - (remaining / move.cooldownTotal) * 100)
    rect:setBackgroundColor(remaining < 4000 and '#f3161690' or '#1637f290')
    move.widget:getChildById('cooldownText'):setText(string.format('%d', math.ceil(remaining / 1000)))
    move.event = scheduleEvent(function() tickCooldown(move) end, 100)
end

local function startCooldown(move, seconds)
    stopCooldown(move)
    if seconds <= 0 then
        return
    end
    move.cooldownTotal = seconds * 1000
    move.cooldownEnd = g_clock.millis() + move.cooldownTotal
    tickCooldown(move)
end

function useMove(index)
    local move = moves[index]
    if not move then
        return false
    end
    lastUsed = { index = index, time = g_clock.millis() }
    return PokeNation.say('m' .. index)
end

function requestDetails(index)
    local move = moves[index]
    if not move then
        return false
    end
    pendingDetails = move.iconId
    return PokeNation.say('/sd ' .. move.iconId)
end

local function applyOrientation()
    local layout = orientation == VERTICAL and UIVerticalLayout.create(window) or UIHorizontalLayout.create(window)
    layout:setFitChildren(true)
    window:setLayout(layout)
end

function switchOrientation()
    orientation = orientation == HORIZONTAL and VERTICAL or HORIZONTAL
    applyOrientation()
end

-- The server sends no move list when the Pokemon is returned, so the bar keeps the moves of the ball
-- in the ball slot (as the legacy client did) and is dimmed while nothing is summoned.
local function refreshSummonedState()
    if not window or not modules.game_pokebar then
        return
    end
    window:setOpacity(modules.game_pokebar.getInUse() and 1 or 0.5)
end

local function onPokemonBarUpdate()
    addEvent(refreshSummonedState)
end

local function clear()
    for _, move in pairs(moves) do
        stopCooldown(move)
    end
    moves = {}
    lastUsed = nil
    window:destroyChildren()
end

-- 0xFF 0x01
local function onPokemonMoves(pokemonIconId, iconIds)
    clear()
    local count = 0
    for index, iconId in ipairs(iconIds) do
        if index > PokeNation.MAX_MOVES then
            break
        end
        count = index
        local widget = g_ui.createWidget('MoveSlot', window)
        widget:setId('move' .. index)
        widget:getChildById('icon'):setItemId(iconId)
        widget:getChildById('hotkey'):setText(keyForIndex(index) or '')
        local move = { index = index, iconId = iconId, name = getMoveNameByIconItemId(iconId), widget = widget }
        moves[index] = move
        widget.onMouseRelease = function(self, mousePosition, mouseButton)
            if not self:containsPoint(mousePosition) then
                return false
            end
            if mouseButton == MouseRightButton then
                local menu = g_ui.createWidget('PopupMenu')
                menu:setGameMenu(true)
                menu:addOption(tr('Use'), function() useMove(index) end)
                menu:addOption(tr('Details'), function() requestDetails(index) end)
                menu:addSeparator()
                menu:addOption(tr('Switch orientation'), switchOrientation)
                menu:display(mousePosition)
            elseif g_keyboard.isShiftPressed() then
                requestDetails(index)
            else
                useMove(index)
            end
            return true
        end
        updateTooltip(move)
    end
    window:setVisible(count > 0)
    if count > 0 then
        window:raise()
    end
    addEvent(refreshSummonedState)
end

-- 0xFF 0x09: seconds == 0 resets the cooldown (server doBallResetAllCooldowns)
local function onPokemonMoveCooldown(iconId, seconds)
    for _, move in pairs(moves) do
        if move.iconId == iconId then
            startCooldown(move, seconds)
        end
    end
end

local function parseDetails(text)
    -- English template of server lib/ps/events/talkactions/client/skillDescription.lua
    local name, power, energy, cooldown = text:match('^Move: (.-), Power: (.-), Energy: (%d+), Cooldown: (%d+)s')
    if not name then
        return nil
    end
    local moveType = text:match('Type: (.-),') or ''
    local category = text:match('Category: (.-),') or ''
    local range = text:match('Range: (%d+) sqm') or '?'
    return {
        name = name, power = power, energy = tonumber(energy), cooldown = tonumber(cooldown), type = moveType,
        category = category, range = tonumber(range),
        summary = tr('Power %s, energy %s, cooldown %ss', power, energy, cooldown) .. '\n' ..
            tr('%s / %s, range %s', moveType, category, range)
    }
end

local function onTextMessage(mode, text)
    if pendingDetails then
        local info = parseDetails(text)
        if info then
            moveInfo[pendingDetails] = info
            for _, move in pairs(moves) do
                if move.iconId == pendingDetails then
                    updateTooltip(move)
                end
            end
            pendingDetails = nil
            return
        end
    end
    if not lastUsed or g_clock.millis() - lastUsed.time > REFUSAL_WINDOW_MS then
        return
    end
    local move = moves[lastUsed.index]
    if not move then
        return
    end
    -- Refusals of server lib/ps/systems/003-skill.lua doPokemonUseSkill (English templates).
    local level = text:match('level for this move is too low %((%d+)%)')
    local energy = text:match('has insufficient energy %((%d+)%)')
    if level then
        move.lockedLevel = tonumber(level)
        move.widget:getChildById('locked'):show()
        updateTooltip(move)
    elseif energy then
        move.missingEnergy = tonumber(energy)
        updateTooltip(move)
    end
end

local function bindKeys()
    if not PokeNation.moveKeysEnabled() then
        return
    end
    local root = modules.game_interface.getRootPanel()
    for index = 1, PokeNation.MAX_MOVES do
        local key = keyForIndex(index)
        local callback = function() useMove(index) end
        g_keyboard.bindKeyDown(key, callback, root)
        boundKeys[key] = callback
    end
end

local function unbindKeys()
    local root = modules.game_interface.getRootPanel()
    for key, callback in pairs(boundKeys) do
        g_keyboard.unbindKeyDown(key, callback, root)
    end
    boundKeys = {}
end

local function onGameStart()
    clear()
    window:hide()
end

local function onGameEnd()
    clear()
    window:hide()
    moveInfo = {}
end

-- 0xFF 0x02 / 0x03 (server never sends 0x02; 0x03 also opens the Pokemon bar)
local function onMoveBarClose()
    window:hide()
end

local function onMoveBarOpen()
    if next(moves) then
        window:show()
    end
end

-- Read-only view for tests and other modules.
function getMoves()
    local list = {}
    for index, move in pairs(moves) do
        list[index] = {
            index = index, iconId = move.iconId, name = move.name, key = keyForIndex(index),
            cooldown = move.cooldownEnd and math.max(0, move.cooldownEnd - g_clock.millis()) or 0,
            lockedLevel = move.lockedLevel, info = moveInfo[move.iconId]
        }
    end
    return list
end

function isActive()
    return window:isVisible() and window:getOpacity() == 1
end

function getWidget()
    return window
end

function init()
    g_ui.importStyle('pokemoves')
    window = g_ui.createWidget('PokeMovesWindow', modules.game_interface.getRootPanel())
    window:hide()
    orientation = g_settings.getNumber(ORIENTATION_SETTING, HORIZONTAL)
    applyOrientation()
    scheduleEvent(function() window.moved = PokeNation.loadWidgetPosition(window, POSITION_SETTING) end, 100)
    window.onDragLeave = function() window.moved = true end

    connect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd,
        onPokemonBarUpdate = onPokemonBarUpdate,
        onPokemonMoves = onPokemonMoves,
        onPokemonMoveCooldown = onPokemonMoveCooldown,
        onMoveBarOpen = onMoveBarOpen,
        onMoveBarClose = onMoveBarClose,
        onTextMessage = onTextMessage
    })
    bindKeys()
end

function terminate()
    disconnect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd,
        onPokemonBarUpdate = onPokemonBarUpdate,
        onPokemonMoves = onPokemonMoves,
        onPokemonMoveCooldown = onPokemonMoveCooldown,
        onMoveBarOpen = onMoveBarOpen,
        onMoveBarClose = onMoveBarClose,
        onTextMessage = onTextMessage
    })
    unbindKeys()
    clear()
    if window.moved then
        g_settings.set(POSITION_SETTING, window:getPosition())
    end
    g_settings.set(ORIENTATION_SETTING, orientation)
    window:destroy()
    window = nil
end
