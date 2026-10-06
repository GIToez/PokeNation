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

local FIRST_QUEST_STORAGE = 8673
local LAST_QUEST_STORAGE = 8676
local LAST_ED_BLACKHOOD_QUEST_STORAGE = 8701
local WILL_KID_LAST_BATTLE_STORAGE = 9712
local PLAYER_FACTION_STORAGE = 8712
local SOTASHI_LAST_QUEST_STORAGE = 8672

local FACTION_IDS = {}
FACTION_IDS.COLD_WATERS = 1
FACTION_IDS.GUNS_AND_ROSES = 2
FACTION_IDS.LUNATTICUS = 3
FACTION_IDS.SEA_DRAGONS = 4

local TALK_SEQUENCE_STATE = {}
local TALK_SEQUENCE = {}
TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'yes', 'sim' },
    onSay = function(cid)
        npcHandler:sayStory(string.createStory(__L(cid, 'Thank you, you have been helpful. Seems to me that you have a bright future as a Seaman, if you prove yourself worthy, you can join our crew. However, I cannot deal with this right now. I was going through my notes end I may have some leads to what happen to us. The last thing I remember is to leave the pirate sanctuary, heading to the {Black Waters}... RRR Why I am telling you this? ... Never mind, perhaps you may know something...')), cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'black waters', 'aguas negras' },
    onSay = function(cid)
        selfSay('You do now! What do you now? Can you {tell}?', cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'tell', 'contar' },
    onSay = function(cid)
        selfSay('WE LOST THE BATTLE? I WAS CAPTURED? ... Just... Why am I here? Then? What did happened to me? And all my friends? Are they alive too? {Tellme} more!', cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'tellme', 'conte' },
    onSay = function(cid)
        selfSay("WHAT?? They all died? Did I? But I'm here, was I brought to life? Are you sure you do not have the sea madness? Are you sure of it all?", cid)
        selfSay("{YES} or {NO}", cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'yes', 'sim' },
    onSay = function(cid)
        selfSay("I'll need some proof of that. Calico, Jack Spearow's brother, I thrust him, we have a secret password. Go to him, if he judge you fit, he will talk to you, tell him this: {Molor Varghalis}. Get back here to tell me what did he have to say.", cid)
        doCreatureSetStorage(cid, FIRST_QUEST_STORAGE, QUEST_STATUS.STARTED)
        return true
    end
}

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    if (getCreatureStorage(cid, LAST_QUEST_STORAGE) == QUEST_STATUS.FINISHED and getPlayerDefeatedNPC(cid, WILL_KID_LAST_BATTLE_STORAGE)) then
        if (getCreatureStorage(cid, PLAYER_FACTION_STORAGE) ~= QUEST_STATUS.UNSTARTED) then
            selfSay("You have already chosen your faction!", cid)
            return true
        end

        if (msgcontains(msg, 'member') or msgcontains(msg, 'membro')) then
            selfSay("So which faction do you want to be a part of? {Cold Waters}, {Guns and Roses}, {Lunatticus} or {Sea Dragons}?", cid)

        elseif (msgcontains(msg, 'dragon') or msgcontains(msg, 'dragoes')) then
            doCreatureSetStorage(cid, PLAYER_FACTION_STORAGE, FACTION_IDS.SEA_DRAGONS)
            selfSay("Congratulations, you are now part of the Sea Dragons faction!", cid)

        elseif (msgcontains(msg, 'guns')) then
            doCreatureSetStorage(cid, PLAYER_FACTION_STORAGE, FACTION_IDS.GUNS_AND_ROSES)
            selfSay("Congratulations, you are now part of the Guns and Roses faction!", cid)

        elseif (msgcontains(msg, 'lunatticus')) then
            doCreatureSetStorage(cid, PLAYER_FACTION_STORAGE, FACTION_IDS.LUNATTICUS)
            selfSay("Congratulations, you are now part of the Luantticus faction!", cid)

        elseif (msgcontains(msg, 'cold')) then
            doCreatureSetStorage(cid, PLAYER_FACTION_STORAGE, FACTION_IDS.COLD_WATERS)
            selfSay("Congratulations, you are now part of the Cold Waters faction!", cid)

        else
            npcHandler:sayStory(string.createStory(__L(cid, "You filled Will Kid alone, discovered what happened to us ... now we know that it was his fault, the boy never overcame his brother's death and was confused ... this is sad, I do not care what happened With me, I would live my whole life on my ship, now I can live forever in it, it will be difficult to get used to, but okay. Look, everyone's sorry they fought with you, you got into this story for ourselves, and it helped us figure out what happened to us ... we spent all day talking about who would have the honor of having you as an honorary member ... then we have concluded that this honor belongs to you, you will choose one of us to be a {member}, you are already a member of our alliance if you want, but you can choose one of us to represent. Think about it, when you decide, come back to any of us, you can still try to talk to all of us before we decide.")), cid)
        end

        return true
    end

    if (getCreatureStorage(cid, LAST_QUEST_STORAGE) == QUEST_STATUS.STARTED) then
        local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
        npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])
        return true
    end

    if (getCreatureStorage(cid, FIRST_QUEST_STORAGE) == QUEST_STATUS.UNSTARTED) then
        local sequenceReturn, TALK_SEQUENCE_STATE = doTalkSequence(cid, msg, TALK_SEQUENCE, TALK_SEQUENCE_STATE)
        if (not sequenceReturn) then
            selfSay('Hello, Are you the young adventurer who is helping us?', cid)
        end
        return true
    end

    if (msgcontains(msg, { 'molor vahoaris', 'paper', 'papel', 'yes', 'sim', 'no', 'nao' })) then
        local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
        npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])
    else
        selfSay('Yah?', cid)
    end

    return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (getCreatureStorage(cid, LAST_QUEST_STORAGE) == QUEST_STATUS.FINISHED and getPlayerDefeatedNPC(cid, WILL_KID_LAST_BATTLE_STORAGE)) then
        npcHandler:sayStory(string.createStory(__L(cid, "You filled Will Kid alone, discovered what happened to us ... now we know that it was his fault, the boy never overcame his brother's death and was confused ... this is sad, I do not care what happened With me, I would live my whole life on my ship, now I can live forever in it, it will be difficult to get used to, but okay. Look, everyone's sorry they fought with you, you got into this story for ourselves, and it helped us figure out what happened to us ... we spent all day talking about who would have the honor of having you as an honorary member ... then we have concluded that this honor belongs to you, you will choose one of us to be a {member}, you are already a member of our alliance if you want, but you can choose one of us to represent. Think about it, when you decide, come back to any of us, you can still try to talk to all of us before we decide.")), cid)
        npcHandler:addFocus(cid)
        return false
    end

    if (getCreatureStorage(cid, SOTASHI_LAST_QUEST_STORAGE) ~= QUEST_STATUS.FINISHED) then
        selfSay("I'm so busy now!", cid)
        return false
    end

    if (getCreatureStorage(cid, LAST_QUEST_STORAGE) == QUEST_STATUS.STARTED) then
        npcHandler.talkState[cid] = doQuestTalk(cid, name, 'quest', npcHandler.talkState[cid])
        npcHandler:addFocus(cid)
        return false
    end

    if (getCreatureStorage(cid, LAST_ED_BLACKHOOD_QUEST_STORAGE) == QUEST_STATUS.STARTED) then
        selfSay("Hello, so Sotashi is into this, I know which medallion he is, he is in Sotashi's room... go there, and get him if you need...", cid)
        return false
    end

    if (getPlayerDefeatedNPC(cid, "Sotashi")) then
        npcHandler.talkState[cid] = doQuestTalk(cid, name, 'quest', npcHandler.talkState[cid])
        npcHandler:addFocus(cid)
        return false
    end

    if (getCreatureStorage(cid, FIRST_QUEST_STORAGE) ~= QUEST_STATUS.UNSTARTED) then
        selfSay("Molor Varghalis.", cid)
        npcHandler:addFocus(cid)
        return false
    end

    selfSay("{YES} or {NO}", cid)
    return true
end)


npcHandler:addModule(FocusModule:new())
