-- Constants
local DEX_ITEMIDS = {11241, 17270}

-- Vars
local window, panel

-- Methods
local function hide()
    window:hide()
end

local function show()
    window:show()
end

local function reset()
    panel:destroyChildren()
end

function isDexContainer(container)
    return table.find(DEX_ITEMIDS, container:getContainerItem():getId())
end

-- Hooks

function onOnline()
    reset()

    --[[
    window:getChildById('icon'):setItemId(17270)
    local badges = {11174, 11176, 11178, 11180, 11182, 11184, 11186, 11188, 16844, 16845, 16846, 16847 }
    for k, v in pairs(badges) do
        local item = g_ui.createWidget('BadgeItem', panel)
        item:setId(k)
        item:setMargin(0)
        item:setItemId(v)
    end

    show()
    ]]
end

function onOffline()
    hide()
    reset()
end

function onContainerOpen(container, previousContainer)
    if (isDexContainer(container)) then
        panel:destroyChildren()
        window:getChildById('icon'):setItemId(container:getContainerItem():getId())

        for slot=0,container:getCapacity()-1 do
            local itemWidget = g_ui.createWidget('BadgeItem', panel)
            itemWidget:setId('item' .. slot)
            --itemWidget:setItemId(container:getItem(slot):getId())
            itemWidget:setMargin(0)
            itemWidget:setItem(container:getItem(slot))
            itemWidget.position = container:getSlotPosition(slot)
        end

        show()
    end
end

function onInit()
    g_ui.importStyle('badgecase')

    window = g_ui.createWidget('BadgeCaseWindow', modules.game_interface.getRootPanel())
    window:setup()
    window:setPosition({
        x = (g_window.getDisplaySize().width - window:getWidth()) / 2,
        y = (g_window.getDisplaySize().height - window:getHeight()) / 2})
    window:setVisible(false)
    window:setDroppable(false)

    panel = window:recursiveGetChildById('ownDexContainer')

    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline
    })

    connect(Container, { onOpen = onContainerOpen})

    if (g_game.isOnline()) then
        onOnline()
    end
end

function onTerminate()
    disconnect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline
    })

    disconnect(Container, { onOpen = onContainerOpen})

    reset()
    window:destroyChildren()
    window:destroy()
end