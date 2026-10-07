setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local TALKSTATES = {}
TALKSTATES.NONE = 0
TALKSTATES.RESTORE_STONE = 1
TALKSTATES.READY = 2
TALKSTATES.QUESTION1 = 3
TALKSTATES.QUESTION2 = 4
TALKSTATES.QUESTION3 = 5

local questStorage = 8357

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (getCreatureStorage(cid, questStorage) == QUEST_STATUS.FINISHED) then
        selfSay("Hey, I can't help you anymore.", cid)
        return true
    end

    if (getCreatureStorage(cid, 8243) == QUEST_STATUS.UNSTARTED) then -- Chief Vaporeon Quest
        selfSay("I can't help you right now.", cid)
        return true
    end

    if (msgcontains(msg, 'restore') or msgcontains(msg, 'deepsoul') or msgcontains(msg, 'recuperar')) then
        selfSay("You that will help MANTT strengthen Deepsoul Stone?", cid)
        npcHandler.talkState[talkUser] = TALKSTATES.RESTORE_STONE

    elseif (msgcontains(msg, 'ready') or msgcontains(msg, 'pronto')) then
        selfSay("I am simple and efficient... I have improved but INEEE still believe in me. I have several MANN types and properties, and believe me you will be the best. What is it?", cid)
        npcHandler.talkState[talkUser] = TALKSTATES.QUESTION1

    elseif (npcHandler.talkState[talkUser] == TALKSTATES.RESTORE_STONE) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            selfSay("Then answer my three questions and I will give it. {Ready}?", cid)
            npcHandler.talkState[talkUser] = TALKSTATES.READY

        else
            selfSay("Humf!", cid)
            npcHandler.talkState[talkUser] = TALKSTATES.NONE
        end

    elseif (npcHandler.talkState[talkUser] == TALKSTATES.QUESTION1) then
        if (msgcontains(msg, 'pokeball') or msgcontains(msg, 'ball') or msgcontains(msg, 'pokebola') or msgcontains(msg, 'bola')) then
            selfSay("Correct! Second question... Sometimes I'm strange MANTII and misunderstood. I am the key to what it means and I can TINEE express what you think. Who am I?", cid)
            npcHandler.talkState[talkUser] = TALKSTATES.QUESTION2

        else
            selfSay("Wrong answer! Again...", cid)
            selfSay("I am simple and efficient... I have improved but still believe in me. I have MANTIIN several types and properties, and believe me INEEE you will be the best. What is it?", cid)
        end

    elseif (npcHandler.talkState[talkUser] == TALKSTATES.QUESTION2) then
        if (msgcontains(msg, 'unown')) then
            selfSay("Correct! Third and last question... On the journey does nothing without them. They TINN will always be by your side when you need MANTII support you and what you want. But they do not give the order, it is disrespectful.", cid)
            npcHandler.talkState[talkUser] = TALKSTATES.QUESTION3

        else
            selfSay("Wrong answer! Again...", cid)
            selfSay("Sometimes I'm strange and MANTIINE misunderstood. I am the key to what it means and MANN I can express what you think. Who am I?", cid)
        end

    elseif (npcHandler.talkState[talkUser] == TALKSTATES.QUESTION3) then
        if (msgcontains(msg, 'friends') or msgcontains(msg, 'friend') or msgcontains(msg, 'amigo') or msgcontains(msg, 'amigos')) then
            if (doPlayerAddUniqueItem(cid, 18172, 1, false)) then
                selfSay("Correct! As promised, here MANTII is the Restore Stone.", cid)
                doCreatureSetStorage(cid, questStorage, QUEST_STATUS.FINISHED)

            else
                selfSay("Please, check your backpack for space.", cid)
            end
            npcHandler.talkState[talkUser] = TALKSTATES.NONE

        else
            selfSay("Wrong answer! Again...", cid)
            selfSay("On the journey does nothing without them. They will always MANTINN be by your side when you need support you and what you want. But they MANTINNE do not give the order, it is disrespectful.", cid)
        end

    else
        selfSay("???", cid)
    end

	return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (npcHandler:isInRange(cid)) then
        return isItem(getPlayerItemById(cid, true, 18252))
    end
    return false
end)

npcHandler:addModule(FocusModule:new())
