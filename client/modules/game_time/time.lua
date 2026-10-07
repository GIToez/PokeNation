-- Constants
local UPDATE_INTERVAL = 1
local TIME_DELTA = 1440 * UPDATE_INTERVAL / 3600
local PSOUL_MINUTE_PER_SECOND = 2.5

local LIGHT_STATES = {}
LIGHT_STATES.DAY = 0
LIGHT_STATES.NIGHT = 1
LIGHT_STATES.SUNSET = 3
LIGHT_STATES.SUNRISE = 4

local SUNSET = 1305
local SUNRISE = 430

-- Vars
local window, time, timeNow, lightState, lightStateImage, event
local enabled = true

-- Methods
local function updateLight(state)
    if (state ~= lightState) then
        lightState = state
        if (lightState == LIGHT_STATES.SUNSET) then
            lightStateImage:setImageSource('/images/ui/clock-moon')
            lightStateImage:setTooltip(tr('Night'))
        else
            lightStateImage:setImageSource('/images/ui/clock-sun')
            lightStateImage:setTooltip(tr('Day'))
        end
    end
end

function setTime(worldTime)
    timeNow = worldTime

    if (worldTime >= SUNSET or worldTime < SUNRISE) then
        updateLight(LIGHT_STATES.SUNSET)
    else
        updateLight(LIGHT_STATES.SUNRISE)
    end

    local hours = 0
    while (worldTime > 60) do
        hours = hours + 1
        worldTime = worldTime - 60
    end

    time:setText(string.format("%02d:%02d", hours, worldTime))
end

function setDisplay(v)
    enabled = v
    window:setVisible(enabled)
end

local function increaseMinute()
    if (not timeNow) then
        return
    end

    timeNow = timeNow + 1
    if (timeNow > 1440) then
        timeNow = timeNow - 1440
    end
    setTime(timeNow)
end

local function reset()
    removeEvent(event)
    event = nil

    timeNow = nil
    lightState = nil
end

function setLocation(text)
    window:recursiveGetChildById('location'):setText(text)
end

-- Hooks
function onOnline() end

function onOffline()
    --reset()
end

function onLightHour(lightHour)
  setTime(lightHour)
end

function onInit()
    window = g_ui.loadUI('time', modules.game_interface.getRootPanel())
    time = window:recursiveGetChildById('timeLabel')
    time:setText("00:00")
    lightStateImage = window:recursiveGetChildById('timeImage')

    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onLightHour = onLightHour
    })

    if (g_game.isOnline()) then
        onOnline()
    end

    event = cycleEvent(increaseMinute, PSOUL_MINUTE_PER_SECOND * 1000)
end

function onTerminate()
    disconnect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onLightHour = onLightHour
    })

    removeEvent(event)
    event = nil

    if (window) then
        window:destroy()
        window = nil
    end

    time = nil
    timeNow = nil
    lightState = nil
    lightStateImage = nil
end