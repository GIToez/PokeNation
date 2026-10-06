setCreatureIcon(getNpcId(), CREATURE_ICONS.CHAT)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

--[[ ]]

local REWARD_DURATION = 1.5 * 60 * 60 -- 1.5 hour
local REWARD_INTERVAL = 23 * 60 * 60 -- or serversave
local REWARD_MAX_USES = 30 -- 30 days of using
local PLAYER_FACTION_STORAGE = 8712
local PLAYER_LAST_USE_STORAGE = 8721
local PLAYER_USES_COUNT_STORAGE = 8722

local FACTION_IDS = {}
FACTION_IDS.COLD_WATERS = 1
FACTION_IDS.GUNS_AND_ROSES = 2
FACTION_IDS.LUNATTICUS = 3
FACTION_IDS.SEA_DRAGONS = 4

local FACTION_NAMES = {}
FACTION_NAMES[FACTION_IDS.COLD_WATERS] = "Cold Waters"
FACTION_NAMES[FACTION_IDS.GUNS_AND_ROSES] = "Guns and Roses"
FACTION_NAMES[FACTION_IDS.LUNATTICUS] = "Lunatticus"
FACTION_NAMES[FACTION_IDS.SEA_DRAGONS] = "Sea Dragons"

local REWARD_TYPES = {}
REWARD_TYPES.XP = 1
REWARD_TYPES.LOOT = 2
REWARD_TYPES.CATCH = 3
REWARD_TYPES.EGG = 4

local REWARD_DESCRIPTIONS = {}
REWARD_DESCRIPTIONS[REWARD_TYPES.XP] = "Extra XP"
REWARD_DESCRIPTIONS[REWARD_TYPES.LOOT] = "Loot Chance"
REWARD_DESCRIPTIONS[REWARD_TYPES.CATCH] = "Catch Chance"
REWARD_DESCRIPTIONS[REWARD_TYPES.EGG] = "Egg Generation Chance"

local REWARD_APPLIES = {}
REWARD_APPLIES[REWARD_TYPES.XP] = function(cid, bonus, testing)
    if (testing) then
        return getPlayerExtraExpRate(cid) <= 0
    end

    return doExtraExpRateStart(cid, REWARD_DURATION, bonus / 100)
end

REWARD_APPLIES[REWARD_TYPES.LOOT] = function(cid, bonus, testing)
    if (testing) then
        return getPlayerExtraLootRate(cid) <= 0
    end

    return doExtraLootRateStart(cid, REWARD_DURATION, bonus / 100)
end

REWARD_APPLIES[REWARD_TYPES.CATCH] = function(cid, bonus, testing)
    if (testing) then
        return getPlayerExtraCatchRateTime(cid) - os.time() <= 0
    end

    return doExtraCatchRateStart(cid, REWARD_DURATION, bonus / 100)
end

REWARD_APPLIES[REWARD_TYPES.EGG] = function(cid, bonus, testing)
    if (testing) then
        return getPlayerExtraEggRateTime(cid) - os.time() <= 0
    end

    return doExtraEggRateStart(cid, REWARD_DURATION, bonus / 100)
end

local REWARDS = {}
REWARDS[FACTION_IDS.COLD_WATERS] = {
    { type = REWARD_TYPES.CATCH, bonus = 40 },
    { type = REWARD_TYPES.EGG, bonus = 30 },
    { type = REWARD_TYPES.XP, bonus = 20 },
    { type = REWARD_TYPES.LOOT, bonus = 10 },
}

REWARDS[FACTION_IDS.GUNS_AND_ROSES] = {
    { type = REWARD_TYPES.LOOT, bonus = 40 },
    { type = REWARD_TYPES.XP, bonus = 30 },
    { type = REWARD_TYPES.CATCH, bonus = 20 },
    { type = REWARD_TYPES.EGG, bonus = 10 },
}

REWARDS[FACTION_IDS.LUNATTICUS] = {
    { type = REWARD_TYPES.EGG, bonus = 40 },
    { type = REWARD_TYPES.CATCH, bonus = 30 },
    { type = REWARD_TYPES.LOOT, bonus = 20 },
    { type = REWARD_TYPES.XP, bonus = 10 },
}

REWARDS[FACTION_IDS.SEA_DRAGONS] = {
    { type = REWARD_TYPES.XP, bonus = 40 },
    { type = REWARD_TYPES.CATCH, bonus = 30 },
    { type = REWARD_TYPES.EGG, bonus = 20 },
    { type = REWARD_TYPES.LOOT, bonus = 10 },
}

local function getRewardsMessage(cid, rewards)
    local message = {}
    for i, reward in ipairs(rewards) do
        message[#message + 1] = __L(cid, REWARD_DESCRIPTIONS[reward.type])
        message[#message + 1] = " +"
        message[#message + 1] = reward.bonus
        message[#message + 1] = "%"

        if (i == (#rewards - 1)) then
            message[#message + 1] = __L(cid, " and ")
        elseif (i ~= #rewards) then
            message[#message + 1] = ", "
        end
    end
    return table.concat(message)
end

local TALK_STATES = {}
TALK_STATES.REWARD_ASKING = 1

--[[ ]]

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, { 'reward', 'recompensa' })) then -- check if player has reward available and show it
        local faction = getCreatureStorage(cid, PLAYER_FACTION_STORAGE)
        if (not faction or faction == EMPTY_STORAGE) then
            selfSay("Come on! It seems you are not part of any faction! Unfortunately you can not redeem a reward.", cid)
            return true
        end

        if (not REWARDS[faction]) then
            log(LOG_TYPES.ERROR, "EventHalloweenFactionReward::onSay - Unknown faction", faction, getCreatureName(cid))
            selfSay("Error! Something wrong has happened, we are calling those responsible. Please try again tomorrow!", cid)
            return true
        end

        selfSay(string.format(__L(cid, "Huuum! Your faction is %s, the rewards available to you are: %s. The duration is %s. Do you want to redeem them right now?"),
            FACTION_NAMES[faction],
            getRewardsMessage(cid, REWARDS[faction]),
            table.concat(string.timediff(REWARD_DURATION, cid))), cid)
        npcHandler.talkState[talkUser] = TALK_STATES.REWARD_ASKING

    elseif (npcHandler.talkState[talkUser] == TALK_STATES.REWARD_ASKING) then
        if (msgcontains(msg, { 'yes', 'sim' })) then
            local faction = getCreatureStorage(cid, PLAYER_FACTION_STORAGE)

            local useCount = getCreatureStorage(cid, PLAYER_USES_COUNT_STORAGE)
            if (useCount and useCount ~= EMPTY_STORAGE and useCount >= REWARD_MAX_USES) then
                selfSay(string.format(__L(cid, "You have already used the maximum amount of %s reward uses!"), REWARD_MAX_USES), cid)
                return true
            end

            local lastUse = getCreatureStorage(cid, PLAYER_LAST_USE_STORAGE)
            if (lastUse and lastUse ~= EMPTY_STORAGE and lastUse <= getGlobalStorageValue(GLOBAL_STORAGES.SERVER_START_TIME)) then
                local remaingTime = (lastUse + REWARD_INTERVAL) - os.time()
                if (remaingTime > 0) then
                    selfSay(string.format(__L(cid, "Sorry, you must wait %s seconds to use the reward again."), table.concat(string.timediff(remaingTime, cid))), cid)
                    return true
                end
            end

            local canPlayerReceiveRewards = true
            for _, reward in pairs(REWARDS[faction]) do
                if (REWARD_APPLIES[reward.type]) then
                    if (not REWARD_APPLIES[reward.type](cid, reward.bonus, true)) then
                        canPlayerReceiveRewards = false
                        break
                    end

                else
                    log(LOG_TYPES.ERROR, "EventHalloweenFactionReward::onSay - Unknown reward apply", reward)
                    canPlayerReceiveRewards = false
                    break
                end
            end

            if (not canPlayerReceiveRewards) then
                selfSay("Oops! It seems you can not receive the reward yet. Please try again later.", cid)
                return true
            end

            for _, reward in pairs(REWARDS[faction]) do
                REWARD_APPLIES[reward.type](cid, reward.bonus, false)
            end

            useCount = useCount > 0 and (useCount + 1) or 1
            doCreatureSetStorage(cid, PLAYER_USES_COUNT_STORAGE, useCount)
            doCreatureSetStorage(cid, PLAYER_LAST_USE_STORAGE, os.time())
            selfSay(string.format(__L(cid, "Congratulations! Your %s faction bonus has been activated! Your rewards are %s. Duration: %s. Use count: %s of %s."),
                FACTION_NAMES[faction],
                getRewardsMessage(cid, REWARDS[faction]),
                table.concat(string.timediff(REWARD_DURATION, cid)),
                useCount,
                REWARD_MAX_USES
            ), cid)
            doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_RED)

        else
            selfSay("It's all right!", cid)
            npcHandler.talkState[talkUser] = nil
        end
    end

    return true
end)
npcHandler:addModule(FocusModule:new())
