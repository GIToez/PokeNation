local ProgressCallback = {
  update = 1,
  finish = 2
}

local ORIENTATIONS = {}
ORIENTATIONS.HORIZONTAL = 0
ORIENTATIONS.VERTICAL = 1

statusBar = nil

local COOLDOWN_RECTS = {}
local orientation = ORIENTATIONS.HORIZONTAL
local defaultWidth = 0
local defaultHeight = 0

local STATUS_BY_ITEMID = {}
STATUS_BY_ITEMID[16715] = "Burn"
STATUS_BY_ITEMID[16716] = "Freeze"
STATUS_BY_ITEMID[16717] = "Paralyze"
STATUS_BY_ITEMID[16718] = "Poison"
STATUS_BY_ITEMID[16719] = "Sleep"
STATUS_BY_ITEMID[16720] = "Confusion"
STATUS_BY_ITEMID[16721] = "Low Accuracy"
STATUS_BY_ITEMID[16722] = "Extra Speed"
STATUS_BY_ITEMID[16723] = "Lower Attack"
STATUS_BY_ITEMID[16724] = "Extra Attack"
STATUS_BY_ITEMID[16725] = "Lower Defense"
STATUS_BY_ITEMID[16726] = "Extra Defense"
STATUS_BY_ITEMID[16727] = "Insomnia"
STATUS_BY_ITEMID[16728] = "Reflect"
STATUS_BY_ITEMID[16729] = "Prevent Status"
STATUS_BY_ITEMID[16730] = "Flinch"
STATUS_BY_ITEMID[16731] = "Bad Poison"
STATUS_BY_ITEMID[16732] = "High Critical Chance"
STATUS_BY_ITEMID[16733] = "Recharge"
STATUS_BY_ITEMID[16734] = "Infatuate"
STATUS_BY_ITEMID[16735] = "Store Damage"
STATUS_BY_ITEMID[16736] = "Counter"
STATUS_BY_ITEMID[16737] = "Substitute"
STATUS_BY_ITEMID[16738] = "Charge"
STATUS_BY_ITEMID[11205] = "Health +1"
STATUS_BY_ITEMID[11206] = "Health +2"
STATUS_BY_ITEMID[11207] = "Health +3"
STATUS_BY_ITEMID[11208] = "Health +4"
STATUS_BY_ITEMID[17393] = "Blink"
STATUS_BY_ITEMID[17587] = "Stockpile Charge 1"
STATUS_BY_ITEMID[17588] = "Stockpile Charge 2"
STATUS_BY_ITEMID[17589] = "Stockpile Charge 3"

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
            COOLDOWN_RECTS[progressRect].label:setColor('#FF0000')
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
    statusBar:hide()
end

function show()
    statusBar:show()
end

function reset()
    statusBar:destroyChildren()
end

local function reallocateIcons()
    local last
    for k, v in pairs(statusBar:getChildren()) do
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
    if (statusBar:getChildCount() == 0) then
        statusBar:resize(defaultWidth, defaultHeight)
        return
    end
    
    if (orientation == ORIENTATIONS.HORIZONTAL) then
        local width = statusBar:getPaddingLeft() + statusBar:getPaddingRight()
        for k, v in pairs(statusBar:getChildren()) do
            width = width + v:getWidth()
        end

        statusBar:resize(width, defaultHeight)
    else
        local height = statusBar:getPaddingTop() + statusBar:getPaddingBottom()
        for k, v in pairs(statusBar:getChildren()) do
            height = height + v:getHeight()
        end

        statusBar:resize(defaultWidth, height)
    end
end

function switchOrientation()
    orientation = orientation == ORIENTATIONS.HORIZONTAL and ORIENTATIONS.VERTICAL or ORIENTATIONS.HORIZONTAL
    resize()
    reallocateIcons()
end

--

function onStatusBarAdd(itemId, cooldown)
    hide()

    local icon = g_ui.createWidget('StatusItem', statusBar)
    icon:setItemId(itemId)
    icon:setTooltip(tr(tostring(STATUS_BY_ITEMID[itemId])))

    resize()
    reallocateIcons()
    show()

    local progressRect = g_ui.createWidget('ProgressRect', icon)
    progressRect:setId(icon:getId())
    progressRect:fill('parent')
    progressRect:setBackgroundColor('#1637F290')

    local label = g_ui.createWidget('CooldownLabel', progressRect)
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
        icon:destroy()
        resize()
        reallocateIcons()
    end

    initCooldown(progressRect, updateFunc, finishFunc)
end

function onStatusBarRemove(itemId)
    for k, v in pairs(statusBar:getChildren()) do
        if (v:getItemId() == itemId) then
            v:destroy()
        end
    end

    resize()
    reallocateIcons()
end

function onStatusBarClear()
    reset()
    resize()
end

function onPokemonMovesClose()
    hide()
end

function onPokemonMovesOpen()
    show()
end

function onOnline()
    reset()
    show()
end

function onOffline()
    hide()
    reset()
end

function onInit()
    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onStatusBarAdd = onStatusBarAdd,
        onStatusBarRemove = onStatusBarRemove,
        onStatusBarClear = onStatusBarClear})

    statusBar = g_ui.loadUI('statusbar', modules.game_interface.getRootPanel())
    --[[scheduleEvent(function() statusBar:setPosition(g_settings.getPoint('statusbar-pos', {x = 400, y = 400}))
    end, 100)]]
    orientation = ORIENTATIONS.HORIZONTAL--g_settings.getInteger('statusbar-orientation', ORIENTATIONS.HORIZONTAL)
    --statusBar:hide()

    --[[statusBar.onMouseRelease = function(self, mousePosition, mouseButton)
        if (mouseButton == MouseRightButton) then
            local menu = g_ui.createWidget('PopupMenu')
            menu:addOption(tr('Switch Orientation'), switchOrientation)
            menu:display(mousePosition)
            return true
        end
        return false
    end]]

    defaultWidth = statusBar:getWidth()
    defaultHeight = statusBar:getHeight()

    if (g_game.isOnline()) then
        onOnline()
    end
end

function onTerminate()
    disconnect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onStatusBarAdd = onStatusBarAdd,
        onStatusBarRemove = onStatusBarRemove,
        onStatusBarClear = onStatusBarClear})

    --g_settings.set('statusbar-pos', statusBar:getPosition())
    --g_settings.set('statusbar-orientation', orientation)

    statusBar:destroy()
end