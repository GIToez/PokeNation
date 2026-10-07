-- Constants
local MESSAGES = {}
MESSAGES.ON_WIN = {image = "/images/messages/duel_win"}
MESSAGES.ON_LOSE = {image = "/images/messages/duel_lose"}

-- Vars
local window, event, firstShow

-- Methods
local function show(message)
    window:setImageSource(message.image)
    window:restartImageAnimation();
    window:show()
    g_effects.fadeIn(window, 2000)
    event = scheduleEvent(function()
        g_effects.fadeOut(window, 3000)
        event = scheduleEvent(function()
            window:hide()
        end, 3000)
    end, (2.3 + 5 - 3) * 1000)
end

-- Hooks
function onOnline()
    firstShow = {}
end

function onOffline()
end

function onSkillChange(localPlayer, id, level, percent)
    if (not firstShow[id]) then -- Receiving first data from server, isnt a really skill change
        firstShow[id] = true
        return
    end
    if (id == 0 or id == 2) then -- Duel Win / Battle Win
        show(MESSAGES.ON_WIN)
    elseif (id == 1 or id == 3) then -- Duel Loss / Battle Loss
        show(MESSAGES.ON_LOSE)
    end
end

function onInit()
    window = g_ui.loadUI('duelMessage', modules.game_interface.getRootPanel())
    window:hide()

    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline
    })

    connect(LocalPlayer, {
        onSkillChange = onSkillChange,
    })

    if (g_game.isOnline()) then
        onOnline()
    end
end

function onTerminate()
    disconnect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline
    })

    disconnect(LocalPlayer, {
        onSkillChange = onSkillChange,
    })

    window:destroy()
end