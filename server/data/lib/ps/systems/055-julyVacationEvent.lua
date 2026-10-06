if (JulyVacationEvent) then
    return
end

JulyVacationEvent = {}

local COMMON_CHEST_ITEMID = 29117
local RARE_CHEST_ITEMID = 29122
local LEGENDARY_CHEST_ITEMID = 29120

local STAMINA_REWARDS = {
    {
        requiredStaminaChange = -(60 * 60) * 1000,
        reward = { itemId = COMMON_CHEST_ITEMID, count = 1, unique = true }
    },
    {
        requiredStaminaChange = -(120 * 60) * 1000,
        reward = { itemId = RARE_CHEST_ITEMID, count = 1, unique = true }
    },
    {
        requiredStaminaChange = -(180 * 60) * 1000,
        reward = { itemId = LEGENDARY_CHEST_ITEMID, count = 1, unique = true }
    },
}

local CHESTS_REWARDS = {
    [COMMON_CHEST_ITEMID] = {
        random = {
            { itemId = 27764, count = 1, unique = false, chance = 3000 }, -- TM Box Nível 20 3%
            { itemId = 29125, count = 1, unique = false }, -- Seal Box Comum
            { itemId = 12248, count = 15, unique = false }, -- 15 Revives
            { itemId = 18945, count = 1, unique = false }, -- Doll Box Comum
            { itemId = 29130, count = 50, unique = false }, -- 50x Comida Especial +5
            { itemId = 29128, count = 1, unique = false }, -- Mastery Paint Ticket Box
        },
        certainty = {
            { itemId = 29132, count = 1, unique = true }, -- 1 Fragment of The Choosen Ones
        }
    },
    [RARE_CHEST_ITEMID] = {
        random = {
            { itemId = 27767, count = 1, unique = false, chance = 3000 }, -- TM Box Nível 40
            { itemId = 29129, count = 1, unique = false }, -- Mastery Ball Box
            { itemId = 29127, count = 1, unique = false }, -- Paint Ticket Box Raro
            { itemId = 23949, count = 1, unique = false }, -- Vitamin Box
            { itemId = 29131, count = 1, unique = false }, -- XP Boost Potion +15% 1h
            { itemId = 29130, count = 100, unique = false }, -- 100x Comida Especial +5
        },
        certainty = {
            { itemId = 29132, count = 2, unique = true }, -- 2 Fragment of The Choosen Ones
        }
    },
    [LEGENDARY_CHEST_ITEMID] = {
        random = {
            { itemId = 27768, count = 1, unique = false, chance = 3000 }, -- TM Box Nível 60
            { itemId = 29126, count = 1, unique = false }, -- Seal Box Raro
            { itemId = 29124, count = 1, unique = false }, -- Doll Box Raro
            { itemId = 29133, count = 1, unique = false }, -- Paint Ticket Box Legendário
        },
        certainty = {
            { itemId = 29132, count = 3, unique = true }, -- 3 Fragment of The Choosen Ones
        }
    }
}

for chestItemId, chestConfig in pairs(CHESTS_REWARDS) do
    local remaingChance = RANDOM_CHANCE_MAX
    local randomTicketMin = RANDOM_CHANCE_MIN
    local rewardsWithAutomaticChance = 0

    for k, v in pairs(chestConfig.random) do
        local chance = v.chance
        if (chance) then
            remaingChance = remaingChance - chance
        else
            rewardsWithAutomaticChance = rewardsWithAutomaticChance + 1
        end
    end

    for k, v in pairs(chestConfig.random) do
        local chance = v.chance
        if (not chance) then
            chance = remaingChance / rewardsWithAutomaticChance
            CHESTS_REWARDS[chestItemId].random[k].chance = chance
        end

        CHESTS_REWARDS[chestItemId].random[k].randomTicketMin = randomTicketMin
        CHESTS_REWARDS[chestItemId].random[k].randomTicketMax = randomTicketMin + v.chance

        randomTicketMin = CHESTS_REWARDS[chestItemId].random[k].randomTicketMax
    end
end

local STAMINA_CHANGE_CACHE = {}
local STAMINA_RECEIVED_REWARDS_CACHE = {}
JulyVacationEvent.onStaminaChange = function(cid, stamina, change)
    if (change > 0) then
        return
    end

    local guid = getPlayerGUID(cid)
    if (not STAMINA_CHANGE_CACHE[guid]) then
        STAMINA_CHANGE_CACHE[guid] = change
    else
        STAMINA_CHANGE_CACHE[guid] = STAMINA_CHANGE_CACHE[guid] + change
    end

    for k, v in pairs(STAMINA_REWARDS) do
        if (STAMINA_CHANGE_CACHE[guid] <= v.requiredStaminaChange) then
            if (not STAMINA_RECEIVED_REWARDS_CACHE[guid] or not STAMINA_RECEIVED_REWARDS_CACHE[guid][v.reward.itemId]) then
                if (not STAMINA_RECEIVED_REWARDS_CACHE[guid]) then
                    STAMINA_RECEIVED_REWARDS_CACHE[guid] = {}
                end

                doPlayerSafeAddItem(cid, v.reward.itemId, v.reward.count, v.reward.unique, true)
                STAMINA_RECEIVED_REWARDS_CACHE[guid][v.reward.itemId] = true
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "You completed %s of hunting and received your reward."), table.concat(string.timediff(-(v.requiredStaminaChange) / 1000, cid))))
                doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_RED)
            end
        end
    end
end

JulyVacationEvent.onPlayerUseRewardChest = function(cid, item)
    local chest = CHESTS_REWARDS[item.itemid]
    if (not chest) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local randomRewardTicket = getRandom(RANDOM_CHANCE_MIN, RANDOM_CHANCE_MAX)
    local reward = nil
    for k, v in pairs(chest.random) do
        if (v.randomTicketMin <= randomRewardTicket and v.randomTicketMax >= randomRewardTicket) then
            reward = v
            break
        end
    end

    if (reward) then
        doRemoveItem(item.uid, 1)
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_YELLOW)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, getItemNameById(item.itemId) .. __L(cid, " contains: "))

        doPlayerSafeAddItem(cid, reward.itemId, reward.count, true, reward.unique)
        doDatalogJulyVacationDrops(getPlayerGUID(cid), reward.itemId, reward.count, os.time())

        for _, v in pairs(chest.certainty) do
            doPlayerSafeAddItem(cid, v.itemId, v.count, true, v.unique)
            doDatalogJulyVacationDrops(getPlayerGUID(cid), v.itemId, v.count, os.time())
        end
    end
end