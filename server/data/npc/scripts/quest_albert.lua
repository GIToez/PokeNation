setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local timeStorage = 8217
local timeStorageDone = -2

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'flask') or msgcontains(msg, 'extraction') or msgcontains(msg, 'plant') or msgcontains(msg, 'frasco') or msgcontains(msg, 'extracao') or msgcontains(msg, 'planta')) then
        local value = getCreatureStorage(cid, timeStorage)
        if (value > 0) then -- Player waiting for extraction
            local diff = (value + 30 * 60) - os.time()
            if (diff <= 0) then
                if (doPlayerAddUniqueItem(cid, 18245, 1, false)) then
                    doCreatureSetStorage(cid, timeStorage, timeStorageDone)
                    selfSay("Oh! I finished the extraction, here is.", cid)
                else
                    selfSay("Please check your backpack for space.", cid)
                end

            else
                selfSay(string.format(__L(cid, "You still have to wait %s."), table.concat(string.timediff(diff, cid))),
                    cid)
            end

        else
            selfSay("Sorry?", cid)
        end

	else
		npcHandler.talkState[talkUser] = doQuestTalk(cid, "Albert", msg, npcHandler.talkState[talkUser])
    end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
