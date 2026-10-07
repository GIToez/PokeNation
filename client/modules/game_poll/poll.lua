-- Constants

-- Vars
local window, pollQuestions, pollIcon, pollQuestionLabel, showIconOnLogin, textMode, textWindow

-- Methods
local function hide()
    window:hide()
end

local function show()
    window:show()
end

local function reset()
  if (pollIcon) then
      pollIcon:destroy()
      pollIcon = nil
  end
end

function doPreparePollIconShow(show)
    showIconOnLogin = show
end

-- Hooks
function onPollNotification()
    if (pollIcon) then
        pollIcon:destroy()
        pollIcon = nil
    end

    pollIcon = g_ui.createWidget('PollIcon', modules.game_interface.getRootPanel())
    pollIcon.onClick = function()
        g_game.requestPollWindow()
        pollIcon:hide()
    end
    pollIcon:setTooltip(tr("PSoul Poll"))
end

function onOnline()
    if (showIconOnLogin) then
        onPollNotification()
    end
end

function onOffline()
    hide()
    reset()
end

function onPollWindow(pollQuestion, pollOptions)
    if (pollQuestionLabel) then
        pollQuestionLabel:setText(pollQuestion)
    end

    pollQuestions:destroyChildren()

    if (isTable(pollOptions)) then
        textMode = nil
        for id, option in pairs(pollOptions) do
            local opt = g_ui.createWidget('PollCheckBox', pollQuestions)
            opt:setText(option)
            opt:setId(id)
        end
    else
        textMode = true
        textWindow:setVisible(true)
    end

    window:show()
end

function onVote()
    if (textMode) then
        g_game.doPollVoteText(textWindow:getText())

    else
        local voteOption
        for _, option in pairs(pollQuestions:getChildren()) do
            if (option:isChecked()) then
                voteOption = option
                break
            end
        end

        if (voteOption) then
            g_game.doPollVote(voteOption:getId())
        end
    end

    showIconOnLogin = nil
    window:hide()
end

function onCancel()
    window:hide()
    if (pollIcon) then
        pollIcon:show()
    end
end

function setOption(id, checked)
    if (checked) then
        for _, option in pairs(pollQuestions:getChildren()) do
            if (id ~= option:getId() and option:isChecked()) then
                option:setChecked(false)
            end
        end
    end
end

function onInit()
    g_ui.importStyle('poll')

    window = g_ui.createWidget('PollWindow', modules.game_interface.getRootPanel())
    window:setVisible(false)

    pollQuestions = window:getChildById('pollQuestions')
    pollQuestionLabel = window:getChildById('pollQuestionLabel')
    textWindow = window:getChildById('text')

    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onPollWindow = onPollWindow
    })

    if (g_game.isOnline()) then
        onOnline()
    end
end

function onTerminate()
    disconnect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onPollWindow = onPollWindow
    })

    reset()
    window:destroyChildren()
    window:destroy()
end