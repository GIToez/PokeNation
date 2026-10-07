-- Vars
local window, event

-- Consts
local TIP_ID_WELCOME = 0

-- Methods
local function show(value)
    if (value == TIP_ID_WELCOME) then
        local welcome = g_ui.createWidget('WelcomeWindow', modules.game_interface.getRootPanel())

        g_effects.fadeIn(welcome, 3000)
        scheduleEvent(
            function()
                g_effects.fadeOut(welcome, 4000)
                scheduleEvent(function() welcome:destroy() end, 4001)
            end, 6000)

        return
    end

    window:recursiveGetChildById('image'):setImageSource('/images/tips/' .. value)
    window:restartImageAnimation()
    window:show()
    --[[g_effects.fadeIn(window, 2000)
    event = scheduleEvent(function()
        g_effects.fadeOut(window, 3000)
        event = scheduleEvent(function()
            window:hide()
        end, 3000)
    end, 9000)]]
end

-- Hooks
function onTip(id)
    show(id)
end

function onOkClick()
    if (window) then
        window:hide()
    end
end

function onInit()
    window = g_ui.loadUI('tips', modules.game_interface.getRootPanel())
    window:hide()

    connect(g_game, {
        onTip = onTip
    })
end

function onTerminate()
    disconnect(g_game, {
        onTip = onTip,
    })

    if (window) then
        window:destroy()
        window = nil
    end
end