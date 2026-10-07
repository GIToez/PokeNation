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

local NAGUMO_FIRST_QUEST_STORAGE = 8673
local FIRST_QUEST_STORAGE = 8692
local SECOND_QUEST_STORAGE = 8693
local JAVY_DONES_DIAMOND_QUEST_STORAGE = 8687
local ED_BLACKHOOD_QUESTIONING_QUEST_STORAGE = 8699
local QUESTIONING_STATUS_STORAGE = 8708
local RUNE_STORAGE = 8709
local JACK_SPEAROW_LAST_QUEST_STORAGE = 8690

local TALK_SEQUENCE_STATE = {}

--[[ SEQUENCE DEFAULT ]]
local TALK_SEQUENCE_DEFAULT = {}
TALK_SEQUENCE_DEFAULT[#TALK_SEQUENCE_DEFAULT + 1] = {
    keywords = { 'nagumo' },
    onSay = function(cid)
        selfSay("So you have contact with Nagumo, I'm surprised, but I can only talk about it if you know the right words.", cid)
        return true
    end
}

TALK_SEQUENCE_DEFAULT[#TALK_SEQUENCE_DEFAULT + 1] = {
    keywords = { 'molor varghalis' },
    onSay = function(cid)
        npcHandler.talkState[cid] = doQuestTalk(cid, name, 'quest', npcHandler.talkState[cid])
        return true
    end
}

--[[ SEQUENCE QUESTIONING - ED BLACKHOOD QUEST ]]
local TALK_SEQUENCE_QUESTIONING = {}
TALK_SEQUENCE_QUESTIONING[#TALK_SEQUENCE_QUESTIONING + 1] = {
    keywords = { 'talk', 'falar' },
    onSay = function(cid)
        npcHandler:sayStory(string.createStory(__L(cid, "Hm, so you were spying on me, I understand, but I find your tone exaggerated. You should measure your words by stating absurd size, Ed Blackhood sent you, but that does not justify, he knows full well that our affairs should not be so exposed. But since you know everything, I'll tell you something. The truth is that I never liked the sea, as much as my brother, I was not old enough to know what would be best and I followed him thinking that this would be the best. I would have become a doctor or even a magician, for this was my dream, my brother took it from me. Then I looked for several ways to get rid of this life, until I met The Circle, which Ed must have already explained to him. Finally I was able to fulfill my dream, became a magician, an expert in the arts of darkness. Do not get me wrong, but my problem was with my brother, so deciding to study some old runes that promised things like eternal life or resurrection, I thought of using them somehow, but the price was too high, so I gave up using This to my benefit. I realized that when I tried to abandon my brother, I would be leaving behind the only friend I really had, my brother gave a new life to all these sailors and me too, I still feel sick with the sea, but I have my brother. I felt guilty for trying to leave him, so I filled Rum's face and hid myself in the hull of the ship, at a certain moment began the shouts, the shots, and when our ship was taken by the water, I do not know if it was the fear, the Rum, or that, but I noticed a symbol of a rune similar to the one I've been studying in the hull of the ship, and that's why I have so many runes written down, I've been looking for that symbol ever since. That's the truth, if you do not mind believing it, it's a problem of yours and Ed's. Now quit, I have to continue my research.")), cid)
        doCreatureSetStorage(cid, QUESTIONING_STATUS_STORAGE, QUEST_STATUS.FINISHED)
        return true
    end
}

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    if (getCreatureStorage(cid, ED_BLACKHOOD_QUESTIONING_QUEST_STORAGE) == QUEST_STATUS.STARTED) then
        local sequenceReturn, TALK_SEQUENCE_STATE = doTalkSequence(cid, msg, TALK_SEQUENCE_QUESTIONING, TALK_SEQUENCE_STATE)
        return true
    end

    if (getCreatureStorage(cid, ED_BLACKHOOD_QUESTIONING_QUEST_STORAGE) == QUEST_STATUS.FINISHED and
            getCreatureStorage(cid, RUNE_STORAGE) == QUEST_STATUS.UNSTARTED) then
        if (msgcontains(msg, 'ed')) then
            selfSay("Well, you're still spying on me, are not you? But I will cooperate, take, this was the symbol of the rune I saw before being swallowed by the sea ... Now I hope you leave me alone.", cid)
            doPlayerSafeAddItem(cid, 28163, 1, true, true)
            doCreatureSetStorage(cid, RUNE_STORAGE, QUEST_STATUS.FINISHED)
        else
            selfSay("You again, have not I told you everything? What more do you and {Ed} want?", cid)
        end
        return true
    end

    local firstQuest = getCreatureStorage(cid, FIRST_QUEST_STORAGE)
    if (firstQuest == QUEST_STATUS.FINISHED) then
        if (getCreatureStorage(cid, SECOND_QUEST_STORAGE) == QUEST_STATUS.UNSTARTED) then
            if (getCreatureStorage(cid, JAVY_DONES_DIAMOND_QUEST_STORAGE) == QUEST_STATUS.UNSTARTED) then
                selfSay("Music? No, I'm talking about the most dangerous pirate faction that ever existed, well, apparently you're delirious, you can not help me, when you know what I'm talking about, come back here.", cid)
                return true

            else
                if (msgcontains(msg, 'guns')) then
                    selfSay("Music? No, I'm talking about the most dangerous pirate {faction} that ever existed.", cid)
                elseif (msgcontains(msg, 'faction') or msgcontains(msg, 'faccao')) then
                    selfSay("That's right, well you already know how they are, and I'm in {debt} with them.", cid)
                elseif (msgcontains(msg, 'debt') or msgcontains(msg, 'divida')) then
                    npcHandler.talkState[cid] = doQuestTalk(cid, name, msg, npcHandler.talkState[cid])
                else
                    npcHandler.talkState[cid] = doQuestTalk(cid, name, msg, npcHandler.talkState[cid])
                end

                return true
            end
        end

    elseif (getCreatureStorage(cid, NAGUMO_FIRST_QUEST_STORAGE) == QUEST_STATUS.UNSTARTED) then
        selfSay("So if you do not know her, you can not help me, if you're curious who Nagumo is, search for the Sea Dragons faction, then maybe we can talk.", cid)
        return true

    elseif (firstQuest == QUEST_STATUS.UNSTARTED) then
        local sequenceReturn, TALK_SEQUENCE_STATE = doTalkSequence(cid, msg, TALK_SEQUENCE_DEFAULT, TALK_SEQUENCE_STATE)
        if (sequenceReturn) then
            return true
        end
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
    npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])

    return true
end)

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (getCreatureStorage(cid, JACK_SPEAROW_LAST_QUEST_STORAGE) ~= QUEST_STATUS.FINISHED) then
        selfSay("Go talk to my brother!", cid)
        return false
    end

    if (getCreatureStorage(cid, ED_BLACKHOOD_QUESTIONING_QUEST_STORAGE) == QUEST_STATUS.STARTED) then
        selfSay("Sorry, I'm busy, if it's something important to {talk} about, be brief.", cid)
        npcHandler:addFocus(cid)
        return false
    end

    if (getCreatureStorage(cid, ED_BLACKHOOD_QUESTIONING_QUEST_STORAGE) == QUEST_STATUS.FINISHED and
            getCreatureStorage(cid, RUNE_STORAGE) == QUEST_STATUS.UNSTARTED) then
        selfSay("You again, have not I told you everything? What more do you and {Ed} want?", cid)
        npcHandler:addFocus(cid)
        return false
    end

    if (getCreatureStorage(cid, FIRST_QUEST_STORAGE) == QUEST_STATUS.FINISHED and getCreatureStorage(cid, SECOND_QUEST_STORAGE) == QUEST_STATUS.UNSTARTED) then
        selfSay("Well, you did everything right. Do you know {Guns and Roses}?", cid)
        npcHandler:addFocus(cid)
        return false
    end

    return true
end)

npcHandler:addModule(FocusModule:new())
