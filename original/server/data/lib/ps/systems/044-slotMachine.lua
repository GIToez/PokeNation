if (SlotMachine) then
    return
end

SlotMachine = {}

-- Constants
local SLOT_IDS = {}
SLOT_IDS.LEFTOVER = 1
SLOT_IDS.POKEBALL = 2
SLOT_IDS.GREATBALL = 3
SLOT_IDS.ULTRABALL = 4
SLOT_IDS.MASTERBALL = 5
SLOT_IDS.AMULETICON = 6

local REEL_AMOUNT = 3
local ROLL_DELAY = 5000 + 1500
local COIN_ITEMID = 23497
local PLAY_PRICE = 100
local MAX_PLAY_PER_DAY = 90 -- (30 * 60) / (ROLL_DELAY / 1000) -- 30 minutes per day
local REQUIRED_LEVEL = 50

local SLOTS = {
    [SLOT_IDS.LEFTOVER] = {reelsAmount = {6, 1, 1}, payout = 1, name = "Leftover"},
    [SLOT_IDS.POKEBALL] = {reelsAmount = {5, 1, 1}, payout = 2, name = "Poke Ball"},
    [SLOT_IDS.GREATBALL] = {reelsAmount = {4, 1, 1}, payout = 3, name = "Great Ball"},
    [SLOT_IDS.ULTRABALL] = {reelsAmount = {3, 1, 1}, payout = 4, name = "Ultra Ball"},
    [SLOT_IDS.MASTERBALL] = {reelsAmount = {2, 1, 1}, payout = 10, name = "Master Ball"},
    [SLOT_IDS.AMULETICON] = {reelsAmount = {1, 1, 1}, payout = 30, name = "Amulet Coin"},
}

local EXHAUST_DELAY_MS = 8000
local EXHAUST_CONDITION = createConditionObject(CONDITION_EXHAUST, EXHAUST_DELAY_MS, false, CONDITION_SUBID.EXHAUST.SLOTMACHINE)

local NEXTUSEDATE_ATTR = 2500
local USE_DELAY = EXHAUST_DELAY_MS / 1000

-- Calc Full Cycle (total number of all possible combinations)
--[[
local FULL_CYCLE = 1
local tmp = {}
for reel = 1, REEL_AMOUNT do
    tmp[reel] = 0
    for slotId, slot in pairs(SLOTS) do
        tmp[reel] = tmp[reel] + slot.reelsAmount[reel]
    end
end

for k, v in pairs(tmp) do
    FULL_CYCLE = FULL_CYCLE * v
end

tmp = nil

local chances = {}
for slotId, slot in pairs(SLOTS) do
    chances[slotId] = 1
    for k, v in pairs(slot.reelsAmount) do
        chances[slotId] = chances[slotId] * v
    end
    chances[slotId] = (chances[slotId] / FULL_CYCLE) * 100
end

for k, v in pairs(chances) do
    print("Chance: " .. k .. " - " .. v .. "%")
end

local returns = {}
for slotId, slot in pairs(SLOTS) do
    returns[slotId] = slot.payout * chances[slotId]
end

for k, v in pairs(returns) do
    print("Return: " .. k .. " - " .. v .. "%")
end]]

-- Vars
local REELS = {}

for i = 1, REEL_AMOUNT do
    REELS[i] = {}

    for slotId, slot in pairs(SLOTS) do
        for _ = 1, slot.reelsAmount[i] do
            REELS[i][#REELS[i] + 1] = slotId
        end
    end

    table.shuffle(REELS[i])
end

local PLAYER_PLAY_COUNT_CACHE = {}

-- Local Methods

-- Global Methods
SlotMachine.onUse = function(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureCondition(cid, CONDITION_EXHAUST, CONDITION_SUBID.EXHAUST.SLOTMACHINE)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUAREEXHAUSTED)
        return true
    end

    local next = getItemAttribute(item.uid, NEXTUSEDATE_ATTR)
    if (next and next > getCurrentTimeInSeconds()) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
            string.format(__L(cid, "This machine will be able to use again in %s."), table.concat(string.timediff((next - getCurrentTimeInSeconds()), cid))))
        return true
    end

    if (getPlayerMoney(cid) < PLAY_PRICE) then
        doPlayerSendCancel(cid, string.format(__L(cid, "You do not have enough money. This costs %s dollars."), PLAY_PRICE))
        return true
    end

    if (getPlayerLevel(cid) < REQUIRED_LEVEL) then
        doPlayerSendCancel(cid, string.format(__L(cid, "You need at least level %s to use the slot machine."), REQUIRED_LEVEL))
        return true
    end

    local playerGuid = getPlayerGUID(cid)
    if (not PLAYER_PLAY_COUNT_CACHE[playerGuid]) then
        PLAYER_PLAY_COUNT_CACHE[playerGuid] = 0
    end

    if (PLAYER_PLAY_COUNT_CACHE[playerGuid] >= MAX_PLAY_PER_DAY) then
        doPlayerSendCancel(cid, string.format(__L(cid, "You ve already played %s times today, this is the limit per day."), MAX_PLAY_PER_DAY))
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_POFF)
        return true
    end

    local results = {table.random(REELS[1]), table.random(REELS[2]), table.random(REELS[3])}

    addEvent(function()
        if (isCreature(cid)) then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Your roll results: %s | %s | %s."), SLOTS[results[1]].name, SLOTS[results[2]].name, SLOTS[results[3]].name))

            local coins = 0

            if (results[1] == results[2] and results[2] == results[3]) then
                coins = SLOTS[results[1]].payout

                for i = 1, 6 do
                    addEvent(function() doSendMagicEffect(toPosition, EFFECT_FIREWORK_YELLOW) end, (i - 1) * 200 + 1)
                end

            elseif (results[1] == results[2] or results[1] == results[3] or results[2] == results[3]) then
                local winnerSlot = 1
                if (results[2] == results[3]) then
                    winnerSlot = 2
                end

                coins = math.floor(SLOTS[winnerSlot].payout / 3)
            end

            if (coins > 0) then
                doPlayerSafeAddItem(cid, COIN_ITEMID, coins, false, true, false)
            end

            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, string.format(__L(cid, "You won %s poke coin%s"), coins, (coins > 1 and "s." or ".")))
            doDatalogSlotMachine(os.time(), getPlayerGUID(cid), coins)
        end
    end, ROLL_DELAY)

    if (getPlayerUsingOtClient(cid)) then
        doPlayerSendSlotMachine(cid, results[1], results[2], results[3])
    else
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "The machine is rolling...")
    end

    doPlayerRemoveMoney(cid, PLAY_PRICE)
    doAddCondition(cid, EXHAUST_CONDITION)
    PLAYER_PLAY_COUNT_CACHE[playerGuid] = PLAYER_PLAY_COUNT_CACHE[playerGuid] + 1
    doItemSetAttribute(item.uid, NEXTUSEDATE_ATTR, getCurrentTimeInSeconds() + USE_DELAY)
    doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.PLAY_SLOT_MACHINE, 1)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Playing %s of %s available per day."), PLAYER_PLAY_COUNT_CACHE[playerGuid], MAX_PLAY_PER_DAY))
    return true
end