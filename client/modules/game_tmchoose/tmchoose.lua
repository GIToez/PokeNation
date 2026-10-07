tmChooseWindow = nil
panel = nil

tmConfirmWindow = nil
tmConfirmWindowPanel = nil

local currentTmMoveItemId
--

local function hide()
    tmChooseWindow:hide()
end

local function show()
    tmChooseWindow:show()
end

local function reset()
    panel:destroyChildren()
end

local function proceed(tmMoveItemId, moveItemId)
    currentTmMoveItemId = moveItemId

    tmChooseWindow:setVisible(false)
    tmConfirmWindowPanel:destroyChildren()

    local new = g_ui.createWidget('Item', tmConfirmWindowPanel)
    new:setItemId(tmMoveItemId)
    new:setMargin(0)
    new:setVirtual(true)

    local arrow = g_ui.createWidget('Item', tmConfirmWindowPanel)
    arrow:setItemId(11573)
    arrow:setMargin(0)
    arrow:setVirtual(true)
    arrow:setImageSource('')

    local old = g_ui.createWidget('Item', tmConfirmWindowPanel)
    old:setItemId(moveItemId)
    old:setMargin(0)
    old:setVirtual(true)

    tmConfirmWindow:getChildById('iconItem'):setItemId(15688)
    tmConfirmWindow:setPosition({x = g_window.getDisplaySize().width / 2.5, y = g_window.getDisplaySize().height / 2.5})
    tmConfirmWindow:setVisible(true)
end
--

function onTmChoose(tmMoveItemId, moves)
    reset()

    for k, v in pairs(moves) do
        local item = g_ui.createWidget('Item', panel)
        item:setId(k)
        item:setItemId(v)
        item:setMargin(0)
        item:setVirtual(true)
        item.onClick = function() proceed(tmMoveItemId, item:getItemId()) end
    end

    tmChooseWindow:getChildById('iconItem'):setItemId(15688)
    tmChooseWindow:setPosition({x = g_window.getDisplaySize().width / 4, y = g_window.getDisplaySize().height / 3})
    tmChooseWindow:setVisible(true)
end

function onConfirm()
    tmConfirmWindow:setVisible(false)
    g_game.talkChannel(MessageModes.Say, 0 , '/tc ' .. currentTmMoveItemId)
end

function onCancel()
    tmConfirmWindow:setVisible(false)
end

function onOnline()
    reset()
end

function onOffline()
    hide()
    reset()
end

function onInit()
    g_ui.importStyle('tmchoose')

    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onTmChoose = onTmChoose})

    tmChooseWindow = g_ui.createWidget('TmChooseWindow', g_ui.getRootWidget())
    tmChooseWindow:setup()
    tmChooseWindow:setVisible(false)
    panel = tmChooseWindow:recursiveGetChildById('moves')

    tmConfirmWindow = g_ui.createWidget('TmConfirmWindow', g_ui.getRootWidget())
    tmConfirmWindow:setup()
    tmConfirmWindowPanel = tmConfirmWindow:recursiveGetChildById('moves')
    tmConfirmWindow:setVisible(false)

    if (g_game.isOnline()) then
        onOnline()
    end

    --onTmChoose(10000, {15000, 15001, 15002, 15003, 15004, 15005, 15005, 15005, 15005, 15005, 15005, 15005, 15005, 15005, 15005})
end

function onTerminate()
    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onTmChoose = onTmChoose})

    reset()
    tmChooseWindow:destroy()
    tmConfirmWindow:destroy()
end