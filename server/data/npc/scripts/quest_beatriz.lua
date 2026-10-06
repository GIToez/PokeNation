setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	if (msgcontains(msg, 'letter') or msgcontains(msg, 'message') or msgcontains(msg, 'quest') or msgcontains(msg, 'carta') or msgcontains(msg, 'mensagem') or msgcontains(msg, 'missao')) then
        if (getCreatureStorage(cid, 8317) == QUEST_STATUS.STARTED) then
            if (doPlayerRemoveItem(cid, 18306, 1)) then
                doCreatureSetStorage(cid, 8318, QUEST_STATUS.FINISHED)
                selfSay("Oh! My dear Courts Ted writes me? Great, tell also that I miss him.", cid)

            else
                selfSay("Where is the letter?", cid)
            end

        else
            selfSay("Sorry, I can't help you.", cid)
        end

    else
        selfSay("I don't know what you're talking about.", cid)
    end

	return true
end)

npcHandler:addModule(FocusModule:new())
