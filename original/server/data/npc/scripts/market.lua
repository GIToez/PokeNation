local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local lastMove = {}

local TALKSTATE_CONFIRM = 1

local REQUIRED_COUNT = 1
local REQUIRED_ITEMID = 6500

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)    npcHandler:onCreatureSay(cid, type, msg)      end
function onThink() npcHandler:onThink() end


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'market') or msgcontains(msg, 'mercado')) then
        if (not getPlayerUsingOtClient(cid)) then
            selfSay("Unfortunately your client version has no support to the Market system. Try to use the 'beta' version of PSoul client!", cid)
            return true
        end

        doPlayerSendMarketEnter(cid)
    end
	return true
end)

npcHandler:addModule(FocusModule:new())
