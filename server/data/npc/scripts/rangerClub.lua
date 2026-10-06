local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local TALKSTATE = {}
TALKSTATE.NONE = 0
TALKSTATE.JOIN = 1
TALKSTATE.TASK = 2
TALKSTATE.PROMOTION = 3
TALKSTATE.PAUSE = 4
TALKSTATE.BOSS = 5
TALKSTATE.BOSS_CONTINUE = 6
TALKSTATE.TASK_CONTINUE = 7

local lastBoss = {}
local lastTask = {}

local function showTaskInfo(cid, task)
    local info = {}
    info[#info +1] = "Pokemon: "
    info[#info +1] = task.monster
    info[#info +1] = "\nDefeats: "
    info[#info +1] = task.defeats
    info[#info +1] = "\nBoss: "
    info[#info +1] = (task.boss and "Yes" or "No")
    info[#info +1] = "\nPoints Reward: "
    info[#info +1] = task.rewards.points
    info[#info +1] = "\nItems Reward: "
    if (#task.rewards.items > 0) then
        for _, item in pairs(task.rewards.items) do
            info[#info +1] = "\n"
            info[#info +1] = item.count
            info[#info +1] = "x "
            info[#info +1] = getItemNameById(item.itemid)
        end

    else
        info[#info +1] = "None"
    end

    doPlayerPopupFYI(cid, table.concat(info))
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'join') or msgcontains(msg, 'entrar')) then
        if (RangerClub.getPlayerRank(cid) ~= RangerClub.RANK_IDS.NONE) then
            selfSay("You already joined our club!", cid)
            return true
        end

        npcHandler.talkState[talkUser] = TALKSTATE.JOIN
        selfSay("You really want to be part of the Ranger Club?", cid)

    elseif (msgcontains(msg, 'task') or msgcontains(msg, 'tarefa')) then
        if (RangerClub.getPlayerRank(cid) == RangerClub.RANK_IDS.NONE) then
            selfSay("You are not part of our club! Type {join} if you want to enter.", cid)
            return true
        end

        local task = RangerClub.getPlayerTask(cid)
        if (task ~= RangerClub.TASK_IDS.NONE) then
            local defeats = RangerClub.getPlayerTaskDefeats(cid, task)
            if (defeats < RangerClub.getTaskDefeats(task)) then
                selfSay("You have not completed your current task. If you want to accept a new task, you have to pause your current one. Do you want to pause your current task?", cid)
                npcHandler.talkState[talkUser] = TALKSTATE.PAUSE
                return true
            end

            RangerClub.onPlayerEndTask(cid, task)
            if (RangerClub.getTaskInfo(task).boss) then
                selfSay("Great job! Here is your reward. You also enabled a new {boss} challenge! If you're up for another hunting mission just ask me for a {task}.", cid)
            else
                selfSay("Great job! Here is your reward. If you're up for another hunting mission just ask me for a {task}.", cid)
            end
            return true
        end

        npcHandler:sayStory(string.createStory(string.format(__L(cid, "In your current rank, you can choose one of these tasks: %s"), RangerClub.getPlayerAvailableTasks(cid))), cid)
        npcHandler.talkState[talkUser] = TALKSTATE.TASK

    elseif (msgcontains(msg, 'promotion') or msgcontains(msg, 'promocao')) then
        if (RangerClub.getPlayerRank(cid) == RangerClub.RANK_IDS.NONE) then
            selfSay("You are not part of our club! Type {join} if you want to enter.", cid)
            return true
        end

        selfSay("Oh, you want to receive a promotion in the Ranger Club?", cid)
        npcHandler.talkState[talkUser] = TALKSTATE.PROMOTION

    elseif (msgcontains(msg, 'boss') or msgcontains(msg, 'bosses') or msgcontains(msg, 'chefe') or msgcontains(msg, 'chefao')) then
        if (RangerClub.getPlayerRank(cid) == RangerClub.RANK_IDS.NONE) then
            selfSay("You are not part of our club! Type {join} if you want to enter.", cid)
            return true
        end

        selfSay(string.format(__L(cid, "You are able to defeat these bosses: %s"), RangerClub.getPlayerAvailableBosses(cid)), cid)
        npcHandler.talkState[talkUser] = TALKSTATE.BOSS

    elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        if (npcHandler.talkState[talkUser] == TALKSTATE.JOIN) then
            npcHandler.talkState[talkUser] = TALKSTATE.NONE

            local result = RangerClub.canPromotePlayer(cid, RangerClub.RANK_IDS.ROOKIE)
            if (isString(result)) then
                selfSay(result, cid)
                return true
            end

            RangerClub.setPlayerRank(cid, RangerClub.RANK_IDS.ROOKIE)
            selfSay("Congratulations, now you are a part of our club! Type {task} to see your options.", cid)

        elseif (npcHandler.talkState[talkUser] == TALKSTATE.PROMOTION) then
            npcHandler.talkState[talkUser] = TALKSTATE.NONE
            local next = RangerClub.getRankNext(RangerClub.getPlayerRank(cid))

            if (not next) then
                selfSay("There is no promotion for your rank!", cid)
                return true
            end

            local result = RangerClub.canPromotePlayer(cid, next)
            if (isString(result)) then
                selfSay(result, cid)
                return true
            end

            RangerClub.setPlayerRank(cid, next)
            selfSay("Congratulations, you got promoted!", cid)

        elseif (npcHandler.talkState[talkUser] == TALKSTATE.PAUSE) then
            npcHandler.talkState[talkUser] = TALKSTATE.NONE
            RangerClub.setPlayerTask(cid, RangerClub.TASK_IDS.NONE)
            selfSay("Your task has been paused. You can start a new {task} now!", cid)

        elseif (npcHandler.talkState[talkUser] == TALKSTATE.BOSS_CONTINUE and lastBoss[cid]) then
            npcHandler.talkState[talkUser] = TALKSTATE.NONE

            local result = RangerClub.canChallengeBoss(cid, lastBoss[cid])
            if (isString(result)) then
                selfSay(result, cid)
                return true
            end

            selfSay("Here you go! Good luck!", cid)
            RangerClub.doPlayerChallengeBoss(cid, lastBoss[cid])

            lastBoss[cid] = nil

        elseif (npcHandler.talkState[talkUser] == TALKSTATE.TASK_CONTINUE and lastTask[cid]) then
            npcHandler.talkState[talkUser] = TALKSTATE.NONE
            RangerClub.setPlayerTask(cid, lastTask[cid].id)
            selfSay("Your task has been updated! Good hunt!", cid)
            lastTask[cid] = nil
        end

        npcHandler.talkState[talkUser] = TALKSTATE.NONE

    elseif (npcHandler.talkState[talkUser] == TALKSTATE.TASK) then
        local task = RangerClub.getTaskByName(msg)
        if (task) then
            local result = RangerClub.canStartTask(cid, task)
            if (isString(result)) then
                npcHandler.talkState[talkUser] = TALKSTATE.NONE
                selfSay(result, cid)
                return true
            end

            showTaskInfo(cid, task)
            selfSay("These are the details of this task, do you accept it?", cid)
            npcHandler.talkState[talkUser] = TALKSTATE.TASK_CONTINUE
            lastTask[cid] = task

        else
            selfSay(string.format(__L(cid, "Sorry? In your current rank, you can choose one of these tasks: %s"), RangerClub.getPlayerAvailableTasks(cid)), cid)
        end

    elseif (npcHandler.talkState[talkUser] == TALKSTATE.BOSS) then
        local boss = RangerClub.getBossByName(msg)
        if (boss) then
            npcHandler.talkState[talkUser] = TALKSTATE.BOSS_CONTINUE
            lastBoss[cid] = boss
            selfSay("You really want to challenge this boss?", cid)

        else
            selfSay(string.format(__L(cid, "Sorry? You are able to defeat these bosses: %s"), RangerClub.getPlayerAvailableBosses(cid)), cid)
        end

    elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
        selfSay("Ok!", cid)
        lastTask[cid] = nil
        lastBoss[cid] = nil
        npcHandler.talkState[talkUser] = TALKSTATE.NONE

    else
        selfSay("Welcome to the Ranger Club! You can view the {task} list, try your {promotion} inside the club or challenge the {bosses}.", cid)
    end

    return true
end)
npcHandler:addModule(FocusModule:new())
