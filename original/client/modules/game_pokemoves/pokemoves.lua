local ProgressCallback = {
    update = 1,
    finish = 2
}

local ORIENTATIONS = {}
ORIENTATIONS.HORIZONTAL = 0
ORIENTATIONS.VERTICAL = 1

pokemonMovesWindow = nil

local COOLDOWN_RECTS = {}
local orientation = ORIENTATIONS.HORIZONTAL
local defaultWidth = 0
local defaultHeight = 0

--

function removeCooldown(progressRect)
    COOLDOWN_RECTS[progressRect].label:destroy()
    COOLDOWN_RECTS[progressRect] = nil

    removeEvent(progressRect.event)
    if progressRect.icon then
        progressRect.icon:destroy()
        progressRect.icon = nil
    end
    progressRect:destroy()
    progressRect = nil
end

function turnOffCooldown(progressRect)
    removeEvent(progressRect.event)
    if progressRect.icon then
        progressRect.icon:setOn(false)
        progressRect.icon = nil
    end

    progressRect = nil
end

function initCooldown(progressRect, updateCallback, finishCallback)
    progressRect:setPercent(0)

    progressRect.callback = {}
    progressRect.callback[ProgressCallback.update] = updateCallback
    progressRect.callback[ProgressCallback.finish] = finishCallback

    updateCallback()
end

function updateCooldown(progressRect, timeStart, timeEnd)
    local time = g_clock.seconds()
    if (time <= timeEnd) then
        local percent = ((time - timeStart) / (timeEnd - timeStart)) * 100
        local timeStr = string.format("%.0f", timeEnd - time)

        progressRect:setPercent(percent)

        COOLDOWN_RECTS[progressRect].label:setText(timeStr)
        COOLDOWN_RECTS[progressRect].cooldown = timeEnd - time

        if (COOLDOWN_RECTS[progressRect].cooldown > 3.9) then
            COOLDOWN_RECTS[progressRect].label:setColor(TextColors.white)
        else
--            COOLDOWN_RECTS[progressRect].label:setColor('#FF0000')
            progressRect:setBackgroundColor('#F3161690')
        end

        removeEvent(progressRect.event)
        progressRect.event = scheduleEvent(function()
            if (progressRect.callback) then
                progressRect.callback[ProgressCallback.update]()
            end
        end, 100)
        return true
    end

    progressRect.callback[ProgressCallback.finish]()
end

function hide()
    pokemonMovesWindow:hide()
end

function show()
    pokemonMovesWindow:show()
end

local function reallocateIcons()
    local last
    for k, v in pairs(pokemonMovesWindow:getChildren()) do
        v:breakAnchors()

        if (orientation == ORIENTATIONS.HORIZONTAL) then
            if (last) then
                v:addAnchor(AnchorLeft, last:getId(), AnchorRight)
            else
                v:addAnchor(AnchorLeft, 'parent', AnchorLeft)
            end

        else
            if (last) then
                v:addAnchor(AnchorTop, last:getId(), AnchorBottom)
            else
                v:addAnchor(AnchorTop, 'parent', AnchorTop)
            end
        end

        last = v
    end
end

local function resize()
    if (pokemonMovesWindow:getChildCount() == 0) then
        pokemonMovesWindow:resize(defaultWidth, defaultHeight)
        return
    end

    if (orientation == ORIENTATIONS.HORIZONTAL) then
        local width = pokemonMovesWindow:getPaddingLeft() + pokemonMovesWindow:getPaddingRight()
        for k, v in pairs(pokemonMovesWindow:getChildren()) do
            width = width + v:getWidth()
        end

        pokemonMovesWindow:resize(width, defaultHeight)
    else
        local height = pokemonMovesWindow:getPaddingTop() + pokemonMovesWindow:getPaddingBottom()
        for k, v in pairs(pokemonMovesWindow:getChildren()) do
            height = height + v:getHeight()
        end

        pokemonMovesWindow:resize(defaultWidth, height)
    end
end

function switchOrientation()
    orientation = orientation == ORIENTATIONS.HORIZONTAL and ORIENTATIONS.VERTICAL or ORIENTATIONS.HORIZONTAL
    resize()
    reallocateIcons()
end

function reset()
    pokemonMovesWindow:destroyChildren()
    resize()
end

--

function onPokemonMoveCooldown(itemId, cooldown)
    local icon
    for k, v in pairs(pokemonMovesWindow:getChildren()) do
        if (v:getItemId() == itemId) then
            icon = v
            break
        end
    end

    if (not icon) then
        return
    end

    local progressRect = g_ui.createWidget('ProgressRect', icon)
    progressRect:setId(icon:getId())
    progressRect:fill('parent')
    progressRect:setBackgroundColor('#1637F290')

    local label = g_ui.createWidget('CooldownLabel', progressRect)
    label:setFont('verdana-11px-rounded')
    label:setId(progressRect:getId() .. 'label')
    label:setText(cooldown)
    label:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
    label:addAnchor(AnchorVerticalCenter, 'parent', AnchorVerticalCenter)

    COOLDOWN_RECTS[progressRect] = {}
    COOLDOWN_RECTS[progressRect].cooldown = cooldown
    COOLDOWN_RECTS[progressRect].label = label

    local timeStart, timeEnd = g_clock.seconds(), g_clock.seconds() + cooldown
    local updateFunc = function()
        updateCooldown(progressRect, timeStart, timeEnd)
    end

    local finishFunc = function()
        removeCooldown(progressRect)
    end

    initCooldown(progressRect, updateFunc, finishFunc)
end

function onPokemonMoves(iconItemId, moves)
    hide()
    reset()

    for k, v in pairs(moves) do
        local itemWidget = g_ui.createWidget('MoveItem', pokemonMovesWindow)
        itemWidget:setId('move' .. k)
        itemWidget:setItemId(v)
        itemWidget:setTooltip(getMoveNameByIconItemId(v))
        --itemWidget:setTooltip(tostring(v))
        --[[itemWidget.onTerminate = function()
            for k, v in pairs(itemWidget:getChildren()) do
                if (COOLDOWN_RECTS[v]) then
                    COOLDOWN_RECTS[v].label:destroy()
                    COOLDOWN_RECTS[v] = nil
                    turnOffCooldown(v)
                end
            end
        end]]

        itemWidget.onMouseRelease = function(self, mousePosition, mouseButton)
            if mouseButton == MouseLeftButton and g_keyboard.isShiftPressed() then
                g_game.talkChannel(MessageModes.Say, 0, '/sd ' .. v)
                return true
            end
            g_game.talkChannel(MessageModes.Say, 0, 'm' .. k)
            return true
        end
    end

    resize()
    reallocateIcons()
    show()
end

function onPokemonMovesClose()
    hide()
end

function onPokemonMovesOpen()
    show()
end

function onOnline()
    hide()
    reset()
end

function onOffline()
    hide()
    reset()
end

function onInit()
    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onPokemonMoveCooldown = onPokemonMoveCooldown,
        onPokemonMoves = onPokemonMoves,
        onPokemonMovesClose = onPokemonMovesClose,
        onPokemonMovesOpen = onPokemonMovesOpen
    })

    pokemonMovesWindow = g_ui.loadUI('pokemoves', modules.game_interface.getRootPanel())
    scheduleEvent(function()
        local p = g_settings.getPoint('pokemonmoves-pos')
        if (p and p.x > 0 and p.y > 0) then
            pokemonMovesWindow:breakAnchors()
            pokemonMovesWindow:setPosition(p)
        end
    end, 100)
    --[[scheduleEvent(function() pokemonMovesWindow:setPosition(g_settings.getPoint('pokemonmoves-pos',
        {x = 300, y = 300})) end, 100)]]
    orientation = g_settings.getInteger('pokemonmoves-orientation', ORIENTATIONS.HORIZONTAL)
    pokemonMovesWindow:hide()

    pokemonMovesWindow.onMouseRelease = function(self, mousePosition, mouseButton)
        if (mouseButton == MouseRightButton) then
            local menu = g_ui.createWidget('PopupMenu')
            menu:addOption(tr('Switch Orientation'), switchOrientation)
            menu:display(mousePosition)
            return true
        end
        return false
    end

    defaultWidth = pokemonMovesWindow:getWidth()
    defaultHeight = pokemonMovesWindow:getHeight()

    if (g_game.isOnline()) then
        onOnline()
    end
end

function onTerminate()
    disconnect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onPokemonMoveCooldown = onPokemonMoveCooldown,
        onPokemonMoves = onPokemonMoves,
        onPokemonMovesClose = onPokemonMovesClose,
        onPokemonMovesOpen = onPokemonMovesOpen
    })

    local pos = { x = pokemonMovesWindow:getX(), y = pokemonMovesWindow:getY() }
    g_settings.set('pokemonmoves-pos', pos)
    g_settings.set('pokemonmoves-orientation', orientation)

    pokemonMovesWindow:destroy()
end