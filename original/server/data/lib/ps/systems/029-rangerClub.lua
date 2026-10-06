if (RangerClub) then
    return
end

RangerClub = {}

-- Constants
dofile(PS_LIB_CONFIG_DIR .. "001-rangerClub.lua")

-- Methods
RangerClub.getPlayerRank = function(cid)
    local v = getCreatureStorage(cid, playersStorages.rangerClubRank)
    return v >= 0 and v or RangerClub.RANK_IDS.NONE
end

RangerClub.setPlayerRank = function(cid, rank)
    doCreatureSetStorage(cid, playersStorages.rangerClubRank, rank)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.RANGER_CLUB_1)
end

RangerClub.getPlayerPoints = function(cid)
    local v = getCreatureStorage(cid, playersStorages.rangerClubPoints)
    return v >= 0 and v or 0
end

RangerClub.setPlayerPoints = function(cid, points)
    doCreatureSetStorage(cid, playersStorages.rangerClubPoints, points)
end

RangerClub.getPlayerTask = function(cid)
    local v = getCreatureStorage(cid, playersStorages.rangerClubTask)
    return v >= 0 and v or RangerClub.TASK_IDS.NONE
end

RangerClub.setPlayerTask = function(cid, taskId)
    doCreatureSetStorage(cid, playersStorages.rangerClubTask, taskId)
end

RangerClub.getPlayerTaskDefeats = function(cid, taskId)
    local v = getCreatureStorage(cid, RangerClub.TASKS[taskId].defeatsStorage)
    return v >= 0 and v or 0
end

RangerClub.setPlayerTaskDefeats = function(cid, taskId, defeats)
    doCreatureSetStorage(cid, RangerClub.TASKS[taskId].defeatsStorage, defeats)
end

RangerClub.getPlayerAvailableTasks = function(cid)
    local tasks = {}
    local playerRank = RangerClub.getPlayerRank(cid)

    for id, rank in pairs(RangerClub.RANKS) do
        if (id <= playerRank) then
            if (rank.tasks) then
                for _, task in pairs(rank.tasks) do
                    tasks[#tasks + 1] = "{"
                    tasks[#tasks + 1] = task.name
                    tasks[#tasks + 1] = "}, "
                end
            end
        end
    end
    tasks[#tasks] = "}."

    return table.concat(tasks)
end

RangerClub.setPlayerBossAvailable = function(cid, bossId, value)
    doCreatureSetStorage(cid, RangerClub.BOSSES[bossId].statusStorage, value)
end

RangerClub.getPlayerBossAvailable = function(cid, bossId)
    return getCreatureStorage(cid, RangerClub.BOSSES[bossId].statusStorage)
end

RangerClub.getPlayerAvailableBosses = function(cid)
    local bosses = {}

    for id, boss in pairs(RangerClub.BOSSES) do
        if (RangerClub.getPlayerBossAvailable(cid, id) == RangerClub.BOSS_STATUS.AVAILABLE) then
            bosses[#bosses + 1] = "{"
            bosses[#bosses + 1] = boss.name
            bosses[#bosses + 1] = "}, "
        end
    end
    if (#bosses > 0) then
        bosses[#bosses] = "}."
    else
        bosses[#bosses + 1] = __L(cid, "None.")
    end

    return table.concat(bosses)
end

RangerClub.getBossByName = function(name)
    for id, boss in pairs(RangerClub.BOSSES) do
        if (string.lower(boss.name) == string.lower(name) or
                (boss.auxName and string.lower(boss.auxName) == string.lower(name))) then
            return boss
        end
    end

    return nil
end

RangerClub.getFreeBossArena = function()
    for _, arena in pairs(RangerClub.BOSS_ARENAS) do
        local continue = false
        local spec = getSpectators(arena.centerPos, arena.rangeX, arena.rangeY, true)
        if (spec) then
            for __, cid in pairs(spec) do
                if (not continue and isPlayer(cid)) then
                    continue = true
                end
            end
        end

        if (not continue) then
            return arena
        end
    end

    return nil
end

RangerClub.canChallengeBoss = function(cid, boss)
    if (RangerClub.getPlayerBossAvailable(cid, boss.id) ~= RangerClub.BOSS_STATUS.AVAILABLE) then
        return "You can not challenge this boss."

    elseif (not RangerClub.getFreeBossArena()) then
        return "There is no free arena now. Please try again later."

    elseif (boss.requiredItem and getPlayerItemCount(cid, boss.requiredItem.itemid) < boss.requiredItem.count) then
        return string.format(__L(cid, "You need %sx %s to challenge this boss."), boss.requiredItem.count, getItemNameById(boss.requiredItem.itemid))
    end

    return true
end

RangerClub.canStartTask = function(cid, task)
    if (RangerClub.getPlayerRank(cid) < task.requiredRank) then
        return "You can not start this task."
    end

    return true
end

RangerClub.doPlayerChallengeBoss = function(cid, boss)
    local arena = RangerClub.getFreeBossArena()
    if (not arena) then
        return false
    end

    if (boss.requiredItem and not doPlayerRemoveItem(cid, boss.requiredItem.itemid, boss.requiredItem.count)) then
        return false
    end

    local spec = getSpectators(arena.centerPos, arena.rangeX, arena.rangeY, true)
    if (spec) then
        for __, tmpCid in pairs(spec) do
            doRemoveCreature(tmpCid)
        end
    end

    setPlayerBlockLogout(cid, true)
    setPlayerBackPosition(cid, getCreaturePosition(cid))
    doTeleportThing(cid, arena.centerPos)

    local effect = table.random({EFFECT_WHITE_WIND, EFFECT_BIG_ENERGY_BALL, EFFECT_GREEN_FLASH,
        EFFECT_BIG_YELLOW_ENERGY_BALL, EFFECT_LEAVES_TWO, EFFECT_GREEN_FLASH_TWO, EFFECT_BIG_PURPLE_BALL,
        EFFECT_PURPLE_ELECTRIC_CLOUD})
    for i = 1, 120 do
        addEvent(doSendMagicEffect, (i * 100), {x = arena.centerPos.x + getRandom(arena.rangeX, -arena.rangeX),
            y = arena.centerPos.y + getRandom(arena.rangeY, -arena.rangeY), z = arena.centerPos.z}, effect)
    end

    addEvent(function()
        doSendMagicEffect(arena.centerPos, EFFECT_TELEPORT)
        doCreateMonster(boss.monster, arena.centerPos, false)
    end, 10000)
end

RangerClub.getTaskByName = function(name)
    for _, task in pairs(RangerClub.TASKS) do
        if (string.lower(task.name) == string.lower(name)) then
            return task
        end
    end

    return nil
end

RangerClub.getRankNext = function(rank)
    return RangerClub.RANKS[rank].next
end

RangerClub.getTaskDefeats = function(taskId)
    return RangerClub.TASKS[taskId].defeats
end

RangerClub.getRankInfo = function(rankId)
    return RangerClub.RANKS[rankId]
end

RangerClub.getTaskInfo = function(taskId)
    return RangerClub.TASKS[taskId]
end

RangerClub.canPromotePlayer = function(cid, rank)
    if (RangerClub.getPlayerPoints(cid) < RangerClub.RANKS[rank].requiredPoints) then
        return string.format(__L(cid, "To be promoted to the next rank, you need at least %s Ranger Club points."), RangerClub.RANKS[rank].requiredPoints)

    elseif (getPlayerLevel(cid) < RangerClub.RANKS[rank].requiredLevel) then
        return string.format(__L(cid, "To be promoted to the next rank, you need at least level %s."), RangerClub.RANKS[rank].requiredLevel)
    end

    return true
end

RangerClub.doPlayerAddPoints = function(cid, points)
    local current = RangerClub.getPlayerPoints(cid)
    if (current < RangerClub.MAX_POINTS) then
        if ((current + points) < RangerClub.MAX_POINTS) then
            RangerClub.setPlayerPoints(cid, current + points)
        else
            RangerClub.setPlayerPoints(cid, RangerClub.MAX_POINTS)
        end
    end

    doPlayerAddHighscoreValue(cid, HIGHSCORE_IDS.RANGER_CLUB, points)
end

RangerClub.doPlayerAddRewards = function(cid, rewards, datalogItems)
    if (rewards.experience and rewards.experience > 0) then
        doPlayerAddExperience(cid, rewards.experience)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Ranger Club Reward: %s experience point%s"), rewards.experience, rewards.experience > 1 and "s!" or "!"))
    end

    if (rewards.points and rewards.points > 0) then
        RangerClub.doPlayerAddPoints(cid, rewards.points)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Ranger Club Reward: %s ranger club point%s"), rewards.points, rewards.points > 1 and "s!" or "!"))
    end

    if (rewards.items and #rewards.items > 0) then
        for _, item in pairs(rewards.items) do
            if (not item.chance or getRandom(RANDOM_CHANCE_MIN, RANDOM_CHANCE_MAX) <= item.chance) then
                local count = ((item.mincount and item.maxcount) and getRandom(item.mincount, item.maxcount) or
                        item.count)
                doPlayerSafeAddItem(cid, item.itemid, count, true, item.unique)

                if (datalogItems) then
                    doDatalogRangerClubBossReward(getPlayerGUID(cid), item.itemid, count, os.time())
                end
            end
        end
    end
end

RangerClub.onPlayerKill = function(cid, name)
    local task = RangerClub.getTaskByName(name)
    if (not task or RangerClub.getPlayerTask(cid) ~= task.id) then
        return
    end

    local defeats = RangerClub.getPlayerTaskDefeats(cid, task.id)
    if (defeats >= task.defeats) then
        return
    end

    defeats = defeats + 1
    RangerClub.setPlayerTaskDefeats(cid, task.id, defeats)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, string.format(__L(cid, "Ranger Club Task: %s - step complete [%s/%s]."),task.name, defeats, task.defeats))

    if (defeats >= task.defeats) then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Ranger Club Task: Complete! Visit a Ranger Club master to get your reward!")
    end
end

RangerClub.onPlayerEndTask = function(cid, taskId)
    RangerClub.setPlayerTask(cid, RangerClub.TASK_IDS.NONE)
    RangerClub.setPlayerTaskDefeats(cid, taskId, 0)
    RangerClub.doPlayerAddRewards(cid, RangerClub.TASKS[taskId].rewards)

    if (RangerClub.TASKS[taskId].boss) then
        RangerClub.setPlayerBossAvailable(cid, RangerClub.TASKS[taskId].boss, RangerClub.BOSS_STATUS.AVAILABLE)
    end

    doDatalogRangerClubTask(getPlayerGUID(cid), taskId, os.time())
    doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.COMPLETE_RANGERCLUB_TASK, 1)
end

RangerClub.onPlayerDefeatBoss = function(cid, name)
    local boss = RangerClub.getBossByName(name)
    if (not boss) then
        log(LOG_TYPES.ERROR, "RangerClub.onPlayerDefeatBoss - Unknown boss name", getCreatureName(cid), name)
        return
    end

    RangerClub.setPlayerBossAvailable(cid, boss.id, RangerClub.BOSS_STATUS.UNAVAILABLE)
    RangerClub.doPlayerAddRewards(cid, boss.rewards, true)
    doTeleportThing(cid, TRADE_ROOM_POSITION)
    setPlayerBlockLogout(cid, false)
    doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, string.format(__L(cid, "Congratulations! You defeated %s boss challenge!"), name))

    local info = getMonsterInfo(boss.name, false)
    if (info) then -- Add common monster rewards
        local rewards = {items = {}}
        for __, tmpLoot in pairs(info.loot) do
            rewards.items[#rewards.items + 1] = {itemid = tmpLoot.id, count = tmpLoot.count,
                chance = tmpLoot.chance * RangerClub.BOSS_LOOT_EXTRA_CHANCE}
        end
        RangerClub.doPlayerAddRewards(cid, rewards, true)
    end

    if (boss.onKill) then
        boss.onKill(cid)
    end

    doDatalogRangerClubBoss(getPlayerGUID(cid), boss.id, os.time())
    doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.COMPLETE_RANGERCLUB_BOSS, 1)
end