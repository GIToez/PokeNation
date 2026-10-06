local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local questTalking = {}

local TM_STORAGE = 8399
local function giveTm(cid)
    doCreatureSetStorage(cid, TM_STORAGE, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 17347, 1, true, false, true) -- TM 11 Bubblebeam
end

local npcBattle = NpcBattle:new(getNpcName(), 9102, 9537, npcHandler)
npcBattle:setPokemons({"Golduck", "Cloyster", "Seaking", "Seadra", "Blastoise", "Poliwrath", "Dewgong", "Vaporeon"})
npcBattle:setRewardBaseExp(5000)
npcBattle:setRewardBadge(BADGES.CASCADE)
npcBattle:setRewardRespect(2)
npcBattle:setPayRespect(10)
npcBattle:setOneWin(true)
npcBattle:setDifficulty(35)
npcBattle:setRequiredMessage("You must first defeat the GYM trainers before battle against me.")
npcBattle:setRequired(function(cid)
                        return getPlayerDefeatedNPC(cid, "Melisa Atkin") and
                                getPlayerDefeatedNPC(cid, "Eve Morelock") and
                                getPlayerDefeatedNPC(cid, "Jami Stainback") and
                                getPlayerDefeatedNPC(cid, "Tabatha Elizalde") and
                                getPlayerDefeatedNPC(cid, "Saundra Goucher") and
                                getPlayerDefeatedNPC(cid, "Christian Tone") and
                                getPlayerDefeatedNPC(cid, "Mathew Crecelius")
                        end)
npcBattle:setOnWin(function(cid)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.CASCADE_BADGE)
    giveTm(cid)
end)
npcBattle:setPokemonDefeatExperienced(true)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if (msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel')) then
		talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

    elseif (msgcontains(msg, 'mission') or msgcontains(msg, 'task') or msgcontains(msg, 'help') or
            msgcontains(msg, 'quest')) then
        talkState[talkUser] = doQuestTalkStart(cid, "Misty")
        questTalking[talkUser] = true

	elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
		if (questTalking[talkUser]) then
            talkState[talkUser] = doQuestTalkEnd(cid, "Misty", talkState[talkUser])
            questTalking[talkUser] = nil
        else
            talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, talkState[talkUser])
        end

    elseif (msgcontains(msg, 'tm')) then
        if (not getPlayerDefeatedNPC(cid, getNpcName())) then
            selfSay("You must defeat me before receive your reward.", cid)

        elseif (getCreatureStorage(cid, TM_STORAGE) == QUEST_STATUS.FINISHED) then
            selfSay("You already got this reward.", cid)

        else
            giveTm(cid)
            selfSay("Oh, here is!", cid)
        end

	else
		questTalking[talkUser] = nil
        selfSay("Ok..", cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, function(cid)
  if (getSamePosition(getNpcPos(), {x = 5525, y = 234, z = 6})) then
    return false
  end

	if (not npcHandler:isInRange(cid)) then
		return false
	end

	return true
end)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
