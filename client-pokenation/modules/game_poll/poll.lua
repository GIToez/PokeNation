-- PokeNation server poll. Port of the legacy PSoul game_poll:
--   * the login packet carries a "poll available" byte (gamelib/protocollogin.lua -> g_game.onPollAvailable);
--   * clicking the poll icon sends 0xFA (g_game.requestPollWindow, gamelib/pokenation.lua);
--   * 0xFF 0x18 opens the window with either options (id -> text, one choice) or free-text mode;
--   * voting sends 0xFB with the option id or the text. The server checks that the account has an
--     open poll and records one vote per account (server/src/polls.cpp).
-- The vote button is disabled after sending so a double click cannot send two votes.

local window, icon
local pollAvailable = false
local textMode = false
local selectedId
local lastVote

local function destroyIcon()
    if icon then
        icon:destroy()
        icon = nil
    end
end

local function showIcon()
    destroyIcon()
    icon = g_ui.createWidget('PollIcon', modules.game_interface.getRootPanel())
    icon:setTooltip(tr('PokeNation Poll'))
    icon.onClick = function()
        g_game.requestPollWindow()
        icon:hide()
    end
end

local function selectOption(id)
    selectedId = id
    for _, option in ipairs(window:getChildById('options'):getChildren()) do
        option:setChecked(option.optionId == id)
    end
    window:getChildById('voteButton'):setEnabled(true)
end

local function onPollWindow(question, options)
    window:getChildById('question'):setText(question)
    window:getChildById('hint'):setText('')
    local optionsPanel = window:getChildById('options')
    local textEdit = window:getChildById('text')
    optionsPanel:destroyChildren()
    selectedId = nil
    textMode = type(options) ~= 'table'
    textEdit:setVisible(textMode)
    optionsPanel:setVisible(not textMode)
    window:getChildById('optionsScroll'):setVisible(not textMode)
    if textMode then
        textEdit:setText('')
        window:getChildById('voteButton'):setEnabled(true)
    else
        local ids = {}
        for id in pairs(options) do
            ids[#ids + 1] = id
        end
        table.sort(ids)
        for _, id in ipairs(ids) do
            local option = g_ui.createWidget('PollOption', optionsPanel)
            option:setId('option' .. id)
            option:setText(options[id])
            option.optionId = id
            option.onCheckChange = function(self, checked)
                if checked and selectedId ~= id then
                    selectOption(id)
                elseif not checked and selectedId == id then
                    self:setChecked(true)
                end
            end
        end
        window:getChildById('voteButton'):setEnabled(false)
    end
    window:show()
    window:raise()
    window:focus()
end

function vote()
    local voteButton = window:getChildById('voteButton')
    if not voteButton:isEnabled() then
        return
    end
    if textMode then
        local text = window:getChildById('text'):getText():trim()
        if text == '' then
            window:getChildById('hint'):setText(tr('Write an answer first.'))
            return
        end
        g_game.doPollVoteText(text)
        lastVote = { text = text }
    else
        if not selectedId then
            window:getChildById('hint'):setText(tr('Choose an option first.'))
            return
        end
        g_game.doPollVote(selectedId)
        lastVote = { option = selectedId }
    end
    voteButton:setEnabled(false)
    pollAvailable = false
    destroyIcon()
    window:hide()
end

function cancel()
    window:hide()
    if icon then
        icon:show()
    elseif pollAvailable then
        showIcon()
    end
end

local function onPollAvailable(available)
    pollAvailable = available
end

local function onGameStart()
    if pollAvailable then
        showIcon()
    end
end

local function onGameEnd()
    window:hide()
    destroyIcon()
end

function getState()
    return { visible = window:isVisible(), icon = icon ~= nil, textMode = textMode,
        options = window:getChildById('options'):getChildCount(), lastVote = lastVote }
end

function getWindow()
    return window
end

function selectOptionById(id)
    selectOption(id)
end

function setText(text)
    window:getChildById('text'):setText(text)
end

function init()
    g_ui.importStyle('poll')
    window = g_ui.createWidget('PollWindow', modules.game_interface.getRootPanel())
    window:hide()
    connect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd,
        onPollAvailable = onPollAvailable,
        onPollWindow = onPollWindow
    })
end

function terminate()
    disconnect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd,
        onPollAvailable = onPollAvailable,
        onPollWindow = onPollWindow
    })
    destroyIcon()
    window:destroy()
    window = nil
end
