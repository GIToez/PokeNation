setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

function sayStory(...) return npcHandler:sayStory(...) end

local name = getNpcName()

local SHIP_ANSWER_STORAGE = 8689
local SHIP_ANSWER_ACCEPTED = 1
local SHIP_ANSWER_DENIED = 2

local SHELL_QUEST_STORAGE = 8690
local TEA_QUEST_STORAGE = 8688

local QUEST_WAITING_STORAGE = 8691

local TALK_SEQUENCE_STATE = {}
local TALK_SEQUENCE = {}
TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'strange', 'estranho' },
    onSay = function(cid)
        selfSay("So it's something surreal, it involves {magic} stuff, you would not understand, but I'm crazy enough to understand it.", cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'magic', 'magica' },
    onSay = function(cid)
        selfSay("Ah! Something happens to us for a long time, it seems we die and we come back to life, some of my sailors have been trying to understand this for days, but I do not care, what would be better than going back to life? Maybe tea, tea is good !! I need a tea, I would give my second life for a {tea}...", cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'tea', 'cha' },
    onSay = function(cid)
        selfSay("I love tea, I think you already noticed, but this thing to come back to life, it seems like it has a price, we can not get out of the ship, yesterday I went on the coast to get some shells, I like shells too... errr When I left the Shadow a little, some thing prevented me from going further, it seemed that my soul was weakened, well I was sad, I had a shell so beautiful 2 steps, could not get it.", cid)
        npcHandler.talkState[cid] = doQuestTalk(cid, name, 'quest', npcHandler.talkState[cid])
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'yes', 'sim' },
    onSay = function(cid)
        npcHandler.talkState[cid] = doQuestTalk(cid, name, 'yes', npcHandler.talkState[cid])
        return true
    end
}

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local shipAnswer = getCreatureStorage(cid, SHIP_ANSWER_STORAGE)
    if (shipAnswer == QUEST_STATUS.UNSTARTED) then
        if (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
            selfSay("What a heresy, you do not have good taste, now it's time for my tea, I would invite you but you do not like my beautiful ship, now go, if you want to talk to me come back in 1 hour.", cid)
            doCreatureSetStorage(cid, SHIP_ANSWER_STORAGE, SHIP_ANSWER_DENIED)
            doCreatureSetStorage(cid, QUEST_WAITING_STORAGE, os.time() + (60 * 60))
            npcHandler:releaseFocus(cid)

        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            selfSay("I know, I know, I spent my whole life taking care of my graceful Shadow, what brings you here? I do not remember waiting for visitors, but since you're here, do you want some tea? I'm going to ask one of the boys to make some delicious tea, come back in 10 minutes and you'll be all set.", cid)
            doCreatureSetStorage(cid, SHIP_ANSWER_STORAGE, SHIP_ANSWER_ACCEPTED)
            doCreatureSetStorage(cid, QUEST_WAITING_STORAGE, os.time() + (10 * 60))
            npcHandler:releaseFocus(cid)

        else
            selfSay("The Shadow, it is beautiful is {not} it?", cid)
        end
        return true

    elseif (shipAnswer == SHIP_ANSWER_DENIED) then
        if (getCreatureStorage(cid, SHELL_QUEST_STORAGE) == QUEST_STATUS.UNSTARTED) then
            if (msgcontains(msg, 'shadow') or msgcontains(msg, 'sombra')) then
                selfSay("I'm not willing to talk about it with people who do not like a nice ship like that, but since you're curious, you know things are strange, it seems like we come back to life after a few hundred years and that sounds good, but I do not feel Curious about how it happened... once you're back, maybe I can give you a {second} chance.", cid)
            elseif (msgcontains(msg, { 'second', 'segunda', 'yes', 'sim' })) then
                npcHandler.talkState[cid] = doQuestTalk(cid, name, msg, npcHandler.talkState[cid])
            else
                selfSay("How can you come back here if you despise the {Shadow}, what do you want?", cid)
            end

            return true
        end

        --    elseif (getCreatureStorage(cid, TEA_QUEST_STORAGE) ~= QUEST_STATUS.UNSTARTED) then
        --        npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])
        --        return true

    else
        local sequenceReturn, TALK_SEQUENCE_STATE = doTalkSequence(cid, msg, TALK_SEQUENCE, TALK_SEQUENCE_STATE)
        if (sequenceReturn) then
            return true
        end
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
    npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])

    return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    local waiting = getCreatureStorage(cid, QUEST_WAITING_STORAGE)
    if (waiting ~= QUEST_STATUS.UNSTARTED) then
        local diff = waiting - os.time()
        if (diff > 0) then
            selfSay(string.format(__L(cid, "You must wait %s to continue."), table.concat(string.timediff(diff, cid))), cid)
            return false
        end
    end

    local shipAnswer = getCreatureStorage(cid, SHIP_ANSWER_STORAGE)
    if (shipAnswer ~= QUEST_STATUS.UNSTARTED) then
        if (shipAnswer == SHIP_ANSWER_ACCEPTED) then
            if (getCreatureStorage(cid, TEA_QUEST_STORAGE) == QUEST_STATUS.FINISHED) then
                if (getCreatureStorage(cid, SHELL_QUEST_STORAGE) ~= QUEST_STATUS.FINISHED) then
                    selfSay("Look, I do not want to disturb you, but now that I'm satisfied with tea, I've been thinking about that shell.", cid)
                    npcHandler.talkState[cid] = doQuestTalk(cid, name, 'quest', npcHandler.talkState[cid])
                else
                    selfSay("Sorry I'm busy cleaning this wonderful shell, you could talk to Calico if it's something important, he's the one who takes care of this boring part of important things, he's in the cabin underneath.", cid)
                    return false
                end
            else
                selfSay("Hello, welcome to my beautiful ship, The Shadow, he's beautiful is not... ah it's you, I remembered, but why did you come back? Ahhh! Yes, the tea... errrr has a problem, it seems that we have no tea... this would not be a problem, I could ask one of my comrades to get on the coast, but it seems like something {strange} has happened.", cid)
            end

            npcHandler:addFocus(cid)
            return false
        else
            selfSay("Hello, welcome to my beautiful ship, The Shadow, it is beautiful is not... ah it's you, urrg, how can you come back here if you despise the {Shadow}, what do you want?", cid)
            npcHandler:addFocus(cid)
            return false
        end
    end

    return true
end)

npcHandler:addModule(FocusModule:new())
