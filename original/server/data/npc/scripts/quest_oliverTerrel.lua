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
local tmRewardStorage = 8354

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (getCreatureStorage(cid, 8350) == QUEST_STATUS.FINISHED and
            getCreatureStorage(cid, tmRewardStorage) ~= QUEST_STATUS.FINISHED) then
        local tmItemId = 0
        if (msgcontains(msg, '05')) then
            tmItemId = 17341
        elseif (msgcontains(msg, '25')) then
            tmItemId = 17361
        elseif (msgcontains(msg, '37')) then
            tmItemId = 17373
        end

        if (tmItemId == 0) then
            selfSay("What reward you want? Your options are: {TM 05} (Mega Kick), {TM 25} (Earthquake) and {TM 37} (Skull Bash).", cid)
            return true
        end

        if (doPlayerSafeAddItem(cid, tmItemId, 1, true)) then
            doCreatureSetStorage(cid, tmRewardStorage, QUEST_STATUS.FINISHED)
            selfSay("Great choice! Here is.", cid)
        end

    else
        npcHandler.talkState[talkUser] = doQuestTalk(cid, name, msg, npcHandler.talkState[talkUser])
    end

	return true
end)

npcHandler:setCallback(CALLBACK_CREATURE_SAY, function(cid, class, msg)
    if (npcHandler:isInRange(cid)) then
        return getTilePzInfo(getCreaturePosition(cid))
    end
    return false
end)

npcHandler:addModule(FocusModule:new())
