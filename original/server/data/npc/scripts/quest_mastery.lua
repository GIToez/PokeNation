setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function sayStory(...) return npcHandler:sayStory(...) end

local NPCS = {}
NPCS["Aila"] = {quest = getNpcRandomQuest("Aila"), mastery = MASTERYID_BLAZE}
NPCS["Beau"] = {quest = getNpcRandomQuest("Beau"), mastery = MASTERYID_VITAL}
NPCS["Cayl"] = {quest = getNpcRandomQuest("Cayl"), mastery = MASTERYID_HURRICANE}
NPCS["Demetrius"] = {quest = getNpcRandomQuest("Demetrius"), mastery = MASTERYID_HEREMIT}
NPCS["Eden"] = {quest = getNpcRandomQuest("Eden"), mastery = MASTERYID_HURRICANE}
NPCS["Farrel"] = {quest = getNpcRandomQuest("Farrel"), mastery = MASTERYID_HURRICANE}
NPCS["Gerry"] = {quest = getNpcRandomQuest("Gerry"), mastery = MASTERYID_GAIA}
NPCS["Gurtab"] = {quest = getNpcRandomQuest("Gurtab"), mastery = MASTERYID_BLAZE}
NPCS["Harley"] = {quest = getNpcRandomQuest("Harley"), mastery = MASTERYID_GAIA}
NPCS["Jett"] = {quest = getNpcRandomQuest("Jett"), mastery = MASTERYID_GAIA}
NPCS["Ozias"] = {quest = getNpcRandomQuest("Ozias"), mastery = MASTERYID_VOLTAGIC}
NPCS["Ozy"] = {quest = getNpcRandomQuest("Ozy"), mastery = MASTERYID_ZEN}
NPCS["Rakin"] = {quest = getNpcRandomQuest("Rakin"), mastery = MASTERYID_ZEN}
NPCS["Reese"] = {quest = getNpcRandomQuest("Reese"), mastery = MASTERYID_AVALANCHE}
NPCS["Rukia"] = {quest = getNpcRandomQuest("Rukia"), mastery = MASTERYID_HEREMIT}
NPCS["Ryne"] = {quest = getNpcRandomQuest("Ryne"), mastery = MASTERYID_VOLTAGIC}
NPCS["Sakura"] = {quest = getNpcRandomQuest("Sakura"), mastery = MASTERYID_SPECTRUM}
NPCS["Samira"] = {quest = getNpcRandomQuest("Samira"), mastery = MASTERYID_VITAL}
NPCS["Satya"] = {quest = getNpcRandomQuest("Satya"), mastery = MASTERYID_VITAL}
NPCS["Susie"] = {quest = getNpcRandomQuest("Susie"), mastery = MASTERYID_HEREMIT}
NPCS["Tate"] = {quest = getNpcRandomQuest("Tate"), mastery = MASTERYID_VOLTAGIC}
NPCS["Taya"] = {quest = getNpcRandomQuest("Taya"), mastery = MASTERYID_SPECTRUM}
NPCS["Tucker"] = {quest = getNpcRandomQuest("Tucker"), mastery = MASTERYID_AVALANCHE}
NPCS["Xyler"] = {quest = getNpcRandomQuest("Xyler"), mastery = MASTERYID_AVALANCHE}
NPCS["Noah"] = {quest = getNpcRandomQuest("Noah"), mastery = MASTERYID_BLAZE}
NPCS["Mikko"] = {quest = getNpcRandomQuest("Mikko"), mastery = MASTERYID_ZEN}
NPCS["Kane"] = {quest = getNpcRandomQuest("Kane"), mastery = MASTERYID_SPECTRUM}

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

    if (getPlayerMastery(cid) ~= NPCS[getNpcName()].mastery) then
        selfSay("Sorry, you do not have the requirements to make my missions.", cid)
        return true
    end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	npcHandler.talkState[talkUser] = doQuestTalk(cid, getNpcName(), msg, npcHandler.talkState[talkUser],
        NPCS[getNpcName()].quest)

	return true
end)

npcHandler:addModule(FocusModule:new())
