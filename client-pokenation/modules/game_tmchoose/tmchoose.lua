-- PokeNation TM chooser. Port of the legacy PSoul game_tmchoose: the server sends the TM move icon and
-- the Pokemon's current move icons (0xFF 0x0D); the player picks the move to replace, confirms, and the
-- client says "/tc <replaced move icon id>". The server re-validates the choice (TM item, Pokemon, move).
-- Listeners are disconnected on unload (the legacy onTerminate re-connected them, so a module reload
-- or relog duplicated every callback; BUG-57).

local window
local tmMoveItemId
local chosenMoveItemId

local function showChoice()
    chosenMoveItemId = nil
    window:getChildById('description'):setText(tr('Select the move that will be replaced by the Technical Machine:'))
    window:getChildById('moves'):show()
    window:getChildById('confirm'):hide()
    window:getChildById('okButton'):hide()
end

local function choose(moveItemId)
    chosenMoveItemId = moveItemId
    window:getChildById('description'):setText(tr('Replace %s with %s?', getMoveNameByIconItemId(moveItemId),
        getMoveNameByIconItemId(tmMoveItemId)))
    window:getChildById('moves'):hide()
    local confirmPanel = window:getChildById('confirm')
    confirmPanel:getChildById('newMove'):setItemId(tmMoveItemId)
    confirmPanel:getChildById('oldMove'):setItemId(moveItemId)
    confirmPanel:show()
    window:getChildById('okButton'):show()
end

function cancel()
    if chosenMoveItemId then
        showChoice()
        return
    end
    window:hide()
end

function confirm()
    if not chosenMoveItemId then
        return
    end
    PokeNation.say('/tc ' .. chosenMoveItemId)
    chosenMoveItemId = nil
    window:hide()
end

local function onTmChoose(tmItemId, moves)
    tmMoveItemId = tmItemId
    local panel = window:getChildById('moves')
    panel:destroyChildren()
    for index, moveItemId in ipairs(moves) do
        local button = g_ui.createWidget('TmMoveButton', panel)
        button:setId('move' .. index)
        button:setItemId(moveItemId)
        button:setTooltip(getMoveNameByIconItemId(moveItemId))
        button.onClick = function() choose(moveItemId) end
    end
    showChoice()
    window:show()
    window:raise()
    window:focus()
end

local function reset()
    tmMoveItemId = nil
    chosenMoveItemId = nil
    window:getChildById('moves'):destroyChildren()
    window:hide()
end

function getState()
    return { visible = window:isVisible(), tm = tmMoveItemId, chosen = chosenMoveItemId,
        moves = window:getChildById('moves'):getChildCount() }
end

function getWindow()
    return window
end

function init()
    g_ui.importStyle('tmchoose')
    window = g_ui.createWidget('TmChooseWindow', modules.game_interface.getRootPanel())
    window:hide()
    connect(g_game, { onGameStart = reset, onGameEnd = reset, onTmChoose = onTmChoose })
end

function terminate()
    disconnect(g_game, { onGameStart = reset, onGameEnd = reset, onTmChoose = onTmChoose })
    window:destroy()
    window = nil
end
