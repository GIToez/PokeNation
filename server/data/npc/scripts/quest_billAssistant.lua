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
TALKSTATES.TRADUTOR = 1
TALKSTATES.TRADUTOR_CONFIRM = 2

local QUEST_STORAGE = 8355

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (getCreatureStorage(cid, QUEST_STORAGE) == QUEST_STATUS.FINISHED or
            getCreatureStorage(cid, 8242) == QUEST_STATUS.UNSTARTED) then -- Prophet Slowking Quest
        selfSay("Hey, how are you? I'm busy now, maybe we talk later...", cid)
        return true
    end

	if (msgcontains(msg, 'tradutor') or msgcontains(msg, 'machine') or msgcontains(msg, 'translator') or msgcontains(msg, 'máquina')) then
        selfSay("How do you know about my secret artifact? Look it does not matter... want to help me to test it?", cid)
        npcHandler.talkState[talkUser] = TALKSTATES.TRADUTOR

    elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        if (npcHandler.talkState[talkUser] == TALKSTATES.TRADUTOR) then
            selfSay("It will cost you a bit. Hehe... 100,000 dollars. I need money to fund my research... Do you want?", cid)
            npcHandler.talkState[talkUser] = TALKSTATES.TRADUTOR_CONFIRM

        elseif (npcHandler.talkState[talkUser] == TALKSTATES.TRADUTOR_CONFIRM) then
            if (doPlayerRemoveMoney(cid, 100000)) then
                if (doPlayerAddUniqueItem(cid, 18252, 1, false)) then
                    selfSay("Take good advantage of it. But it will only work with Pokemon that have an average level of intelligence. I developed this prototype for Pokemon living in society. I can see the results here, go ahead!", cid)
                    doCreatureSetStorage(cid, QUEST_STORAGE, QUEST_STATUS.FINISHED)

                else
                    doPlayerAddMoney(cid, 100000)
                    selfSay("Please, check your backpack for space.", cid)
                end

            else
                selfSay("You don't have enough money.", cid)
            end

        else
            selfSay("Sorry?", cid)
        end

    elseif (msgcontains(msg, 'no') or msgcontains(msg, 'nao')) then
        selfSay("Ok.", cid)
        npcHandler.talkState[talkUser] = TALKSTATES.NONE

    else
        selfSay("Sorry?", cid)
    end

	return true
end)

npcHandler:addModule(FocusModule:new())
