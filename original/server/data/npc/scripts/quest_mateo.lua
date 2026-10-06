setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local questStorage = 8224
local statueStorage = 8225

local TALKSTATES = {}
TALKSTATES.NONE = 0
TALKSTATES.BUYING = 10

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'crystal') or msgcontains(msg, 'statue') or msgcontains(msg, 'estatua')) then
        if (getCreatureStorage(cid, questStorage == QUEST_STATUS.STARTED) and
            getCreatureStorage(cid, statueStorage) ~= QUEST_STATUS.FINISHED) then
            selfSay("Hey, I can sell you one Crystal Statue for 4000 dollars. Do you want it?", cid)
            npcHandler.talkState[talkUser] = TALKSTATES.BUYING

        else
            selfSay("Sorry, I can't help you.", cid)
        end

    elseif (npcHandler.talkState[talkUser] == TALKSTATES.BUYING) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            if (doPlayerRemoveMoney(cid, 4000)) then
                if (doPlayerAddUniqueItem(cid, 18166, 1, false)) then
                    doCreatureSetStorage(cid, statueStorage, QUEST_STATUS.FINISHED)
                    selfSay("Here is! When you finish what you're doing, come talk to me!", cid)
                else
                    doPlayerAddMoney(cid, 4000)
                    selfSay("I can't sell you this right now, please check your backpack", cid)
                end

            else
                selfSay("You don't have enough money!", cid)
            end

        else
            selfSay("Maybe next time!", cid)
        end

        npcHandler.talkState[talkUser] = TALKSTATES.NONE

    else
		npcHandler.talkState[talkUser] = doQuestTalk(cid, "Mateo", msg, npcHandler.talkState[talkUser])
    end

	return true
end)

npcHandler:addModule(FocusModule:new())
