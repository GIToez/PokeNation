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

local FIRST_QUEST_STORAGE = 8671
local LAST_QUEST_STORAGE = 8717
local LAST_NAGUMO_QUEST_STORAGE = 8674
local ED_BLACKHOOD_QUESTIONING_QUEST_STORAGE = 8699
local QUESTIONING_STATUS_STORAGE = 8706

local npcBattle = NpcBattle:new(getNpcName(), 9309, 9709, npcHandler)
npcBattle:setPokemons({ "Vaporeon", "Gyarados", "Lapras", "Quagsire", "Mantine", "Azumarill" })
npcBattle:setOneWin(true)
npcBattle:setDifficulty(NPC_DIFFICULTY_DYNAMIC)
npcBattle:setPokemonDefeatExperienced(true)
npcBattle:setRewardUniqueItems({ 14461, 50, 28072, 1 })
npcBattle:setOnWin(function(cid)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.HALLOWEEN_WON_SATOSHI)
end)
npcBattle:setLossSpeech("Hmm, I erred by underestimating you, you're a good trainer.")
npcBattle:setWinSpeech("It seems that you lack discipline to improve your trainer skills, you can study a way to beat me and give you another chance.")

local TALK_SEQUENCE_STATE = {}

--[[ SEQUENCE DEFAULT ]]
local TALK_SEQUENCE_DEFAULT = {}
TALK_SEQUENCE_DEFAULT[#TALK_SEQUENCE_DEFAULT + 1] = {
    keywords = { 'nagumo' },
    onSay = function(cid)
        selfSay("You can't see her now, what is so important? We just came {back} to life. Time is important, and you are wasting ours.", cid)
        return true
    end
}

TALK_SEQUENCE_DEFAULT[#TALK_SEQUENCE_DEFAULT + 1] = {
    keywords = { 'back', 'voltamos' },
    onSay = function(cid)
        selfSay("Yes, long history, but we don't have time, if you want to talk to Nagumo, you have to prove you are {honorable}.", cid)
        return true
    end
}

TALK_SEQUENCE_DEFAULT[#TALK_SEQUENCE_DEFAULT + 1] = {
    keywords = { 'honorable', 'honra' },
    onSay = function(cid)
        npcHandler:sayStory(string.createStory(__L(cid, "Yes. Captain Nagumo is busy, trying to figure out what brought us back to life. If it sound strange to you, imagine to us! We wake up, in the sea, a few days ago, without any explanation. But don't worry with this now. If you want to prove worthy to talk to captain Nagumo you have to find her journal, she always take notes on two of them, you mast find the second one, its hidden on a mountain west from here. Find it and bring it to me.")), cid)
        doCreatureSetStorage(cid, FIRST_QUEST_STORAGE, QUEST_STATUS.STARTED)
        return true
    end
}

--[[ SEQUENCE QUESTIONING - ED BLACKHOOD QUEST ]]
local TALK_SEQUENCE_QUESTIONING = {}
TALK_SEQUENCE_QUESTIONING[#TALK_SEQUENCE_QUESTIONING + 1] = {
    keywords = { 'talk', 'falar' },
    onSay = function(cid)
        selfSay('What? How dare you fiddle with my stuff... how could you take my diary and read it... and what {Ed} has to do with it or Nagumo.', cid)
        return true
    end
}

TALK_SEQUENCE_QUESTIONING[#TALK_SEQUENCE_QUESTIONING + 1] = {
    keywords = { 'ed' },
    onSay = function(cid)
        npcHandler:sayStory(string.createStory(__L(cid, "What? Am I guilty of what is happening? Ed can only be crazy, you want to know what I was looking for? Well, I'll tell you. Yes, Ed was right, I have a \"fall\" for Nagumo, as he prefers to call, but he would never harm her or be selfish enough to hurt her for something of mine. I looked for a way to give my life for her, a way I could give her my life, if I could not protect her, but I never found an effective way, until the battle of Black Water, without spells , I was able to save her, and to my surprise we are eternally trapped here on this ship, I do not know if some divine being gave us a second chance or what ... satisfied? Look, I trusted you, and you did this to me ... I do not want to talk to you anymore ...")), cid)
        doCreatureSetStorage(cid, QUESTIONING_STATUS_STORAGE, QUEST_STATUS.FINISHED)
        return true
    end
}

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (getCreatureStorage(cid, FIRST_QUEST_STORAGE) == QUEST_STATUS.UNSTARTED) then
        local sequenceReturn, TALK_SEQUENCE_STATE = doTalkSequence(cid, msg, TALK_SEQUENCE_DEFAULT, TALK_SEQUENCE_STATE)
        if (not sequenceReturn) then
            selfSay('Hey Stranger. What are brings you to the Exile? Captain Nagumo is heather busy, I can take care for now.', cid)
        end

        return true
    end

    if (getCreatureStorage(cid, ED_BLACKHOOD_QUESTIONING_QUEST_STORAGE) == QUEST_STATUS.STARTED) then
        local sequenceReturn, TALK_SEQUENCE_STATE = doTalkSequence(cid, msg, TALK_SEQUENCE_QUESTIONING, TALK_SEQUENCE_STATE)
        return true
    end

--    if (getCreatureStorage(cid, LAST_QUEST_STORAGE) == QUEST_STATUS.FINISHED and getCreatureStorage(cid, LAST_NAGUMO_QUEST_STORAGE) == QUEST_STATUS.UNSTARTED) then
--    if (getCreatureStorage(cid, LAST_NAGUMO_QUEST_STORAGE) == QUEST_STATUS.FINISHED) then
    if (getCreatureStorage(cid, LAST_QUEST_STORAGE) == QUEST_STATUS.FINISHED and getCreatureStorage(cid, LAST_NAGUMO_QUEST_STORAGE) == QUEST_STATUS.FINISHED) then
        if (msgcontains(msg, 'duel') or msgcontains(msg, 'duelo')) then
            selfSay("You're brave, are you prepared?", cid)
            npcHandler.talkState[talkUser] = npcBattle:doTalkStart(getNpcId(), cid)
        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            npcHandler.talkState[talkUser] = npcBattle:doTalkEnd(getNpcId(), cid, npcHandler.talkState[talkUser])
        end

        return true
    end

    npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])

    return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (getCreatureStorage(cid, ED_BLACKHOOD_QUESTIONING_QUEST_STORAGE) == QUEST_STATUS.STARTED) then
        selfSay("I'm busy now, you need to {talk} to me?", cid)
        npcHandler:addFocus(cid)
        return false
    end

    if (getPlayerDefeatedNPC(cid, name)) then
        selfSay("You have proved yourself worthy to stay in the Exile, go to Nagumo, she has a proposal to make.", cid)
        npcHandler:addFocus(cid)
        return false
    end

    if (getCreatureStorage(cid, LAST_QUEST_STORAGE) == QUEST_STATUS.FINISHED and getCreatureStorage(cid, LAST_NAGUMO_QUEST_STORAGE) == QUEST_STATUS.FINISHED) then
        selfSay("Hi, I see that you are very interested in helping Nagumo, you seem to be interested too much, I do not know your intentions, but if you want to continue having the right to step on the Exile, you will have to face me in a Pokemon {duel}.", cid)
        npcHandler:addFocus(cid)
        return false
    end

    return true
end)

npcHandler:addModule(FocusModule:new())
