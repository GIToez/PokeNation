setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)			npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)			npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()					npcHandler:onThink()					end

local QUEST_STORAGE = getNpcQuests("Maurice")[1].storage
local TALKSTATE_BUY = 100

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if ((msgcontains(msg, 'mission') or msgcontains(msg, 'tv') or msgcontains(msg, 'camera') or msgcontains(msg, 'missao')) and
            getCreatureStorage(cid, QUEST_STORAGE) == QUEST_STATUS.FINISHED) then -- Quest finished
            selfSay("You already done this mission. If you need I can sell you another TV Camera for 1000 dollars, do you want?", cid)
            npcHandler.talkState[talkUser] = TALKSTATE_BUY

	elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and npcHandler.talkState[talkUser] == TALKSTATE_BUY) then
            if (getPlayerItemCount(cid, 14359) > 0) then
                selfSay("You already have a TV Camera.", cid)

            elseif (getPlayerMoney(cid) < 1000) then
                selfSay("You do not have enough money.", cid)

            else
                local camera = doPlayerAddItem(cid, 14359, 1, false)
                if (camera) then
                    doPlayerRemoveMoney(cid, 1000)
                    setItemUniqueOwner(camera, cid)
                    selfSay("Here is.", cid)
                end
            end
            npcHandler.talkState[talkUser] = 0

	else
		npcHandler.talkState[talkUser] = doQuestTalk(cid, "Maurice", msg, npcHandler.talkState[talkUser])
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
