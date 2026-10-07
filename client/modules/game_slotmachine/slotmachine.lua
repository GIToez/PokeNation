-- Constants
local ROUND_DURATION = 5000
local WHEEL_VISIBLE_SLOTS = 3
local EVENT_INTERVAl = 50
local EVENT_INTERVAl_FAST = 1

local SLOT_IDS = {}
SLOT_IDS.LEFTOVER = 1
SLOT_IDS.POKEBALL = 2
SLOT_IDS.GREATBALL = 3
SLOT_IDS.ULTRABALL = 4
SLOT_IDS.MASTERBALL = 5
SLOT_IDS.AMULETICON = 6
SLOT_IDS.LAST = SLOT_IDS.AMULETICON

local SLOTS = {
    [SLOT_IDS.LEFTOVER] = {image = '/images/slotMachine/leftover'},
    [SLOT_IDS.POKEBALL] = {image = '/images/slotMachine/pokeball'},
    [SLOT_IDS.GREATBALL] = {image = '/images/slotMachine/greatball'},
    [SLOT_IDS.ULTRABALL] = {image = '/images/slotMachine/ultraball'},
    [SLOT_IDS.MASTERBALL] = {image = '/images/slotMachine/masterball'},
    [SLOT_IDS.AMULETICON] = {image = '/images/slotMachine/amuletcoin'},
}

-- Vars
local window, wheelLeft, wheelMid, wheelRight
local wheels = {}
local roundDurationRemaing = {}
local roundResult = {}

-- Methods
local function hide()
    window:hide()
end

local function show()
    window:show()
end

local function reset()
    wheelLeft:destroyChildren()
    wheelMid:destroyChildren()
    wheelRight:destroyChildren()
end

local function rollMachine(result1, result2, result3)
    reset()

    --window:getChildById('icon'):setItemId(22120)

    for wheelKey, wheel in pairs(wheels) do
        local first

        for slot = 1, (SLOT_IDS.LAST * 2) do
            local itemWidget = g_ui.createWidget('SlotMachineItem', wheel)
            itemWidget:setId('item' .. slot)
            itemWidget:setImageSource(slot <= SLOT_IDS.LAST and SLOTS[slot].image or SLOTS[slot - SLOT_IDS.LAST].image)

            if (not first) then
                first = itemWidget
            end
        end

        local mid = first:getHeight() * (SLOT_IDS.LAST * 2 - WHEEL_VISIBLE_SLOTS)
        first:setMarginTop(-(mid))

        roundDurationRemaing[first] = ROUND_DURATION

        if (wheelKey == 1) then
            roundResult[first] = result1
        elseif (wheelKey == 2) then
            roundResult[first] = result2
        else
            roundResult[first] = result3
        end

        local func
        func = function()
            if (roundDurationRemaing[first] <= 0) then
                local current = (-(first:getMarginTop()) / first:getHeight()) + 2
                if (current > SLOT_IDS.LAST) then
                    current = current - SLOT_IDS.LAST
                end

                if (current == roundResult[first]) then
                    local wheel = first:getParent()
                    local children = wheel:getChildren()
                    --children[math.ceil(-(first:getMarginTop()) / first:getHeight()) + 2]:setOpacity(0.1)
                    g_effects.startBlink(children[math.ceil(-(first:getMarginTop()) / first:getHeight()) + 2])
                    return
                end
            end

            if (first:getMarginTop() <= -((SLOT_IDS.LAST - WHEEL_VISIBLE_SLOTS) * first:getHeight())) then
                if (roundDurationRemaing[first] > 0) then
                    first:setMarginTop(first:getMarginTop() + (roundDurationRemaing[first] / ROUND_DURATION *
                            first:getHeight()))
                else
                    first:setMarginTop(first:getMarginTop() + 1)
                    scheduleEvent(func, EVENT_INTERVAl_FAST)
                    return
                end
            else
                first:setMarginTop(-mid)
            end

            roundDurationRemaing[first] = roundDurationRemaing[first] - EVENT_INTERVAl
            scheduleEvent(func, EVENT_INTERVAl)
        end

        func()

        --[[cycleEvent(
            function()

        --wheelLeft:moveChildToIndex(first, math.random(0, 2))
        --wheelLeft:moveChildToIndex(wheelLeft:getFirstChild(), 3)
        end, 50)]]
    end
end

-- Hooks
function onOnline()
    --[[rollMachine(math.random(1, 6), math.random(1, 6), math.random(1, 6))
    scheduleEvent(function()
        window:recursiveGetChildById('animationLeft'):setImageSource('/images/slotMachine/animationloss')
        window:recursiveGetChildById('animationRight'):setImageSource('/images/slotMachine/animationloss')
    end, ROUND_DURATION)]]
end

function onOffline()
    hide()
    reset()
end

function onSlotMachine(result1, result2, result3)
    window:recursiveGetChildById('animationLeft'):setImageSource('/images/slotMachine/animationstay')
    window:recursiveGetChildById('animationRight'):setImageSource('/images/slotMachine/animationstay')

    show()
    rollMachine(result1, result2, result3)
    scheduleEvent(function()
        if (result1 == result2 and result2 == result3) then
            window:recursiveGetChildById('animationLeft'):setImageSource('/images/slotMachine/animationwin')
            window:recursiveGetChildById('animationRight'):setImageSource('/images/slotMachine/animationwin')
        else
            window:recursiveGetChildById('animationLeft'):setImageSource('/images/slotMachine/animationloss')
            window:recursiveGetChildById('animationRight'):setImageSource('/images/slotMachine/animationloss')
        end
    end, ROUND_DURATION)
end

function onInit()
    g_ui.importStyle('slotmachine')

    window = g_ui.createWidget('SlotMachineWindow', modules.game_interface.getRootPanel())
    window:setup()
    window:setPosition({
        x = (g_window.getDisplaySize().width - window:getWidth()) / 2,
        y = (g_window.getDisplaySize().height - window:getHeight()) / 2})
    window:setVisible(false)
    window:setDroppable(false)

    wheelLeft = window:recursiveGetChildById('wheelLeft')
    wheelMid = window:recursiveGetChildById('wheelMid')
    wheelRight = window:recursiveGetChildById('wheelRight')

    wheels = {wheelLeft, wheelMid, wheelRight}

    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onSlotMachine = onSlotMachine
    })

    if (g_game.isOnline()) then
        onOnline()
    end
end

function onTerminate()
    disconnect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onSlotMachine = onSlotMachine
    })

    reset()
    window:destroyChildren()
    window:destroy()
end