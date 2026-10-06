local QUEST_IDS = {}
QUEST_IDS.ACHIEVEMENTS = 15
QUEST_IDS.RANGER_CLUB = 48

function onQuestInfo(cid, questId)
    if (questId == QUEST_IDS.ACHIEVEMENTS) then
        local t = {}
        for _, achiev in pairs(ACHIEVEMENT_IDS) do
            if (not getAchievementSecret(achiev) or getPlayerAchievement(cid, achiev)) then
                t[#t + 1] = getAchievementName(cid, achiev)
                t[#t + 1] = __L(cid, getAchievementDescription(achiev))
            end
        end
        doPlayerSendCustomQuestInfo(cid, questId, t)
        return false

    elseif (questId == QUEST_IDS.RANGER_CLUB) then
        local t = {}

        local rankId = RangerClub.getPlayerRank(cid)
        if (rankId ~= RangerClub.RANK_IDS.NONE) then
            local rank = RangerClub.getRankInfo(rankId)

            t[#t + 1] = "Status"
            t[#t + 1] = string.format(__L(cid, "Rank: %s\nPoints: %s"), rank.name, RangerClub.getPlayerPoints(cid))
        end

        local taskId = RangerClub.getPlayerTask(cid)
        if (taskId ~= RangerClub.TASK_IDS.NONE) then
            local task = RangerClub.getTaskInfo(taskId)

            t[#t + 1] = __L(cid, "Current Task")
            t[#t + 1] = string.format(__L(cid, "Pokemon: %s\nDefeats: %s / %s"), task.monster, RangerClub.getPlayerTaskDefeats(cid, taskId), task.defeats)
        end

        doPlayerSendCustomQuestInfo(cid, questId, t)
        return false
    end
    return true
end