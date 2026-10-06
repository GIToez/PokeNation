local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local TM_STORAGE = 8401
local function giveTm(cid)
    doCreatureSetStorage(cid, TM_STORAGE, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 18929, 1, true, false, true) -- TM 65 Fire Punch
end

local npcBattle = NpcBattle:new("Blaine", 9107, 9504, npcHandler)
npcBattle:setPokemons({"Arcanine", "Charizard", "Rapidash", "Ninetales", "Magmar", "Flareon"})
npcBattle:setRewardBaseExp(5000)
npcBattle:setRewardBadge(BADGES.VOLCANO)
npcBattle:setRewardRespect(2)
npcBattle:setPayRespect(150)
npcBattle:setOneWin(true)
npcBattle:setDifficulty(75)
npcBattle:setRequiredMessage("You must first defeat the GYM trainers before battle against me.")
npcBattle:setRequired(function(cid)
                        return getPlayerDefeatedNPC(cid, "Cody Strackbein") and
                                getPlayerDefeatedNPC(cid, "Guy Choquette") and
                                getPlayerDefeatedNPC(cid, "Hugh Taff") and
                                getPlayerDefeatedNPC(cid, "Lance Trevathan") and
                                getPlayerDefeatedNPC(cid, "Alana Linscott") and
                                getPlayerDefeatedNPC(cid, "Hambly") and
                                getPlayerDefeatedNPC(cid, "Neva Klawitter")
                        end)
npcBattle:setOnWin(function(cid)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.VOLCANO_BADGE)
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

	if(msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel') or msgcontains(msg, 'batalha') or msgcontains(msg, 'duelar')) then
		talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

	elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
		talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, talkState[talkUser])

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
		selfSay("Ok..", cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
