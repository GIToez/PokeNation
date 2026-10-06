lootList = nil

local defaultWidth = 0
local defaultHeight = 0

--

function hide()
    lootList:hide()
end

function show()
    lootList:show()
end

function reset()
    lootList:destroyChildren()
end

local function reallocateIcons()
    local last
    for k, v in pairs(lootList:getChildren()) do
        v:breakAnchors()

        if (last) then
            v:addAnchor(AnchorLeft, last:getId(), AnchorRight)
        else
            v:addAnchor(AnchorLeft, 'parent', AnchorLeft)
        end

        last = v
    end
end

local function resize()
    if (lootList:getChildCount() == 0) then
        lootList:resize(defaultWidth, defaultHeight)
        return
    end

    local width = lootList:getPaddingLeft() + lootList:getPaddingRight()
    for k, v in pairs(lootList:getChildren()) do
        width = width + v:getWidth()
    end

    lootList:resize(width, defaultHeight)
end

--

function onLootAdd(itemId, count)
    local icon = g_ui.createWidget('LootItem', lootList)
    icon:setItemId(itemId)

    resize()
    reallocateIcons()

    local label = g_ui.createWidget('CountLabel', icon)
    label:setId(icon:getId() .. 'label')
    label:setText(count)
    label:addAnchor(AnchorHorizontalCenter, 'parent', AnchorHorizontalCenter)
    label:addAnchor(AnchorTop, 'parent', AnchorBottom)

    local finishFunc = function()
        icon:destroy()
        resize()
        reallocateIcons()
    end
    g_effects.fadeOut(icon, 5000)
    scheduleEvent(finishFunc, 5010)
end

function onLootList(list)
    for itemId, itemCount in pairs(list) do
        onLootAdd(itemId, itemCount)
    end
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
        onLootList = onLootList
    })

    lootList = g_ui.loadUI('lootList', modules.game_interface.getRootPanel())

    defaultWidth = lootList:getWidth()
    defaultHeight = lootList:getHeight()

    if (g_game.isOnline()) then
        onOnline()
    end
end

function onTerminate()
    disconnect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onLootList = onLootList
    })

    lootList:destroy()
end