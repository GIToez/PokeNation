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

local SEA_DRAGON_QUEST_STORAGE = 0

local npcBattle = NpcBattle:new(getNpcName(), 9310, 9710, npcHandler)
npcBattle:setPokemons({ "Machamp", "Granbull", "Feraligatr", "Heracross", "Ursaring", "Snorlax" })
npcBattle:setOneWin(true)
npcBattle:setDifficulty(NPC_DIFFICULTY_DYNAMIC)
npcBattle:setPokemonDefeatExperienced(true)
npcBattle:setLossSpeech("This taste, it's bitter, it's been a long time since I've tasted defeat, you look like me a few {years} back.")
npcBattle:setWinSpeech("You were brave, but you're still weak, I can give you another beating if you want.")
npcBattle:setBattleInterval(10 * 60)

local TALK_SEQUENCE_STATE = {}
local TALK_SEQUENCE = {}
TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'strange', 'estranho' },
    onSay = function(cid)
        selfSay("Err, well, something confusing, I woke up a few days ago and was here in a different {era}... but that's none of your business.", cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'era' },
    onSay = function(cid)
        selfSay("You're bothering me with so many questions, what's your interest in it, do you know who you're talking to? I am Redbeard, the most feared pirate of the seven seas, and you are annoying me, you are not afraid of {death}?", cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'death', 'morte' },
    onSay = function(cid)
        selfSay("You're brave enough to insist, but speaking of death, I've been living with her all along, I think she sympathized with me and so she gave me a second chance, or maybe she's afraid of me and wants to stay away. But since you're so brave, I want to {challenge} you.", cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'challenge', 'desafiar' },
    onSay = function(cid)
        npcHandler.talkState[cid] = npcBattle:doTalkStart(getNpcId(), cid)
        return true
    end
}

TALK_SEQUENCE[#TALK_SEQUENCE + 1] = {
    keywords = { 'yes', 'sim' },
    onSay = function(cid)
        npcHandler.talkState[cid] = npcBattle:doTalkEnd(getNpcId(), cid, npcHandler.talkState[cid])
        return true
    end
}

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local sequenceReturn, TALK_SEQUENCE_STATE = doTalkSequence(cid, msg, TALK_SEQUENCE, TALK_SEQUENCE_STATE)
    if (sequenceReturn) then
        return true
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
    npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])

    return true
end)


npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (getPlayerDefeatedNPC(cid, name)) then
        selfSay("You need {gold}, do not you? I'm seeing you very interested in us, but fortunately, I'm in need of a help, are you interested?", cid)
        npcHandler:addFocus(cid)
        return false
    end

    return true
end)

npcHandler:addModule(FocusModule:new())
