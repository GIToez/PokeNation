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

    if (msgcontains(msg, 'newspaper') or msgcontains(msg, 'deliver') or msgcontains(msg, 'jornal') or msgcontains(msg, 'entrega')) then
        if (getCreatureStorage(cid, 8296) == QUEST_STATUS.STARTED and getCreatureStorage(cid, 8297) ~= QUEST_STATUS.FINISHED) then
            if (doPlayerRemoveItem(cid, 18190, 1)) then -- Newspaper
                if (doPlayerAddUniqueItem(cid, 18191, 1, false)) then -- Wardrobe key
                    doCreatureSetStorage(cid, 8297, QUEST_STATUS.FINISHED)
                    selfSay("Oh, thanks. Take the key with you, maybe one day you find what you need.", cid)

                else
                    doPlayerAddUniqueItem(cid, 18190, 1, true) -- Newspaper
                    selfSay("Please, check your backpack for free space.", cid)
                end

            else
                selfSay("Where is the newspaper?", cid)
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
