local CHANCE_MAX = 100000
local REQUIRED_DAMAGE_RATIO = 0.1 -- 10%

local REWARDS = {}
REWARDS["Grisly Mind"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18114, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Grisly Mind artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 12233, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- mind plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Blastertoise"] =  {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18107, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Blastertoise artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 12230, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- splash plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Pink Fury"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18109, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Pink Fury artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 18084, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- Moon Stone
    {itemid = 12232, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- love plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Smaug"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18126, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Smaug artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 18081, count = 3, chance = (CHANCE_MAX / 18), unique = false}, -- sky plate
    {itemid = 12240, count = 3, chance = (CHANCE_MAX / 18), unique = false}, -- draco plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["The Turbo"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18122, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- The Turbo artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 12237, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- zap plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Toby"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18116, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Toby artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 12235, count = 3, chance = (CHANCE_MAX / 18), unique = false}, -- toxic plate
    {itemid = 18082, count = 3, chance = (CHANCE_MAX / 18), unique = false}, -- spooky plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["King Panlong"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18124, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- King Panlong artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 18081, count = 3, chance = (CHANCE_MAX / 18), unique = false}, -- sky plate
    {itemid = 12230, count = 3, chance = (CHANCE_MAX / 18), unique = false}, -- splash plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["The A. Mesmer"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18117, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- The A. Mesmer artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 12233, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- mind plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Sweet Lover"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18121, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Sweet Lover artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 12233, count = 3, chance = (CHANCE_MAX / 18), unique = false}, -- mind plate
    {itemid = 12236, count = 3, chance = (CHANCE_MAX / 18), unique = false}, -- icicle plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Mad Mum"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18118, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Mad Mum artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 12232, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- love plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["DoomBoy"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18115, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- DoomBoy artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 12243, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- fist plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Flesh'n Fire"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18123, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Flesh'n Fire artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 12229, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- flame plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Charles Spencer"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18119, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Charles Spencer artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 12233, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- mind plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Winged Wisdom"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18112, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Winged Wisdom artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 18081, count = 3, chance = (CHANCE_MAX / 18), unique = false}, -- sky plate
    {itemid = 12232, count = 3, chance = (CHANCE_MAX / 18), unique = false}, -- love plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Phyllo Terribil"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18113, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Phyllo Terribil artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 18088, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- Water Stone
    {itemid = 12243, count = 3, chance = (CHANCE_MAX / 18), unique = false}, -- fist plate
    {itemid = 12230, count = 3, chance = (CHANCE_MAX / 18), unique = false}, -- splash plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Cesar, The Simian"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18111, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Cesar, The Simian artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 12243, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- fist plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Great Saul"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18108, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Great Saul artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 13807, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- earth plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Twisted Blades"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18120, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Twisted Blades artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 18081, count = 3, chance = (CHANCE_MAX / 18), unique = false}, -- sky plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Mr. Gormandize"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18125, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Mr. Gormandize artifacts
    {itemid = 12232, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- love plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

REWARDS["Kirby"] = {
    {itemid = 18757, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- mastery stone
    {itemid = 18110, count = 1, chance = (CHANCE_MAX / 36), unique = false}, -- Kirby artifacts
    {itemid = 14463, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- rare candy
    {itemid = 18084, count = 1, chance = (CHANCE_MAX / 18), unique = false}, -- Moon Stone
    {itemid = 12232, count = 5, chance = (CHANCE_MAX / 18), unique = false}, -- love plate
    {itemid = 2160, count = 2, chance = CHANCE_MAX, unique = false}, -- gold bar
}

--
local function canReceiveReward(cid)
    local last = getCreatureStorage(cid, BOSS_REWARD_STORAGE)
    return (last == -1) or ((os.time() - last) >= BOSS_REWARD_INTERVAL)
end

local function giveRandomReward(cid, rewards)
    for _, reward in pairs(rewards) do
        if (getRandom(1, CHANCE_MAX) <= reward.chance) then
            local count = getRandom(1, reward.count)
            doPlayerSafeAddItem(cid, reward.itemid, count, true, reward.unique)
            doCreatureSetStorage(cid, BOSS_REWARD_STORAGE, os.time())
            doDatalogBossReward(getPlayerGUID(cid), reward.itemid, count, os.time())
            break
        end
    end
end

function onPrepareDeath(cid, deathList)
    local rewards = REWARDS[getCreatureName(cid)]
    if (not rewards) then
        log(LOG_TYPES.ERROR, "bossReward - Unknown reward.", getCreatureName(cid))
        return true
    end

    for _, killer in pairs(deathList) do
        if (isCreature(killer)) then
            killer = getCreatureMaster(killer)
            log(LOG_TYPES.INFO, "bossReward - Killer / Ratio / CanReceiveReward", getCreatureName(cid), getCreatureDamageRatioByMaster(cid, killer), canReceiveReward(killer))
            if (isPlayer(killer) and getCreatureDamageRatioByMaster(cid, killer) >= REQUIRED_DAMAGE_RATIO) then
                if (canReceiveReward(killer)) then
                    giveRandomReward(killer, rewards)
                else
                    doPlayerSendTextMessage(killer, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You must wait %s to be able to receive another World Boss reward."), table.concat(string.timediff(BOSS_REWARD_INTERVAL - (os.time() - getCreatureStorage(killer, BOSS_REWARD_STORAGE)), killer))))
                end
            end
        end
    end

    local position = getCreaturePosition(cid)
    for i = 1, 12 do
        addEvent(doSendMagicEffect, (i * 100), getPositionRandomAdjacent(position, 2), EFFECT_BIG_ENERGY_BALL)
    end

    doRemoveCreature(cid)
    return false
end
