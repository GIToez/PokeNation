local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

npcHandler:addModule(FocusModule:new())

local STATES = {}
STATES.CHALLENGE = 1

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'elite')) then
        selfSay("Oh, you think that you are ready to challenge the Elite Four?", cid)
        npcHandler.talkState[talkUser] = STATES.CHALLENGE

    elseif (npcHandler.talkState[talkUser] == STATES.CHALLENGE) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            local ret = EliteFour.doCheckPlayerEntrance(cid)
            if (not isBoolean(ret)) then
                selfSay(ret, cid)
            else
                EliteFour.doPlayerEnter(cid)
            end

        else
            selfSay("Yes, yes. Maybe when you get ready.", cid)
        end
        
        npcHandler.talkState[talkUser] = 0
    end

    return true
end)