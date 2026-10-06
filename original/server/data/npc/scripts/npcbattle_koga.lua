local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local TM_STORAGE = 8404
local function giveTm(cid)
    doCreatureSetStorage(cid, TM_STORAGE, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 17365, 1, true, true, true) -- TM 29 Double Team
end

local npcBattle = NpcBattle:new(getNpcName(), 9105, 9529, npcHandler)
npcBattle:setPokemons({"Arbok", "Muk", "Weezing", "Nidoqueen", "Nidoking", "Golbat", "Venusaur", "Vileplume"})
npcBattle:setRewardBaseExp(5000)
npcBattle:setRewardBadge(BADGES.SOUL)
npcBattle:setRewardRespect(2)
npcBattle:setPayRespect(40)
npcBattle:setOneWin(true)
npcBattle:setDifficulty(65)
--[[
npcBattle:setRequiredMessage("You must first defeat the GYM trainers before battle against me.")
npcBattle:setRequired(function(cid)
                        return getPlayerDefeatedNPC(cid, "Tyrone Reetz") and
                                getPlayerDefeatedNPC(cid, "Lonnie Wooton") and
                                getPlayerDefeatedNPC(cid, "Clinton Shuttleworth") and
                                getPlayerDefeatedNPC(cid, "Jamie Pals") and
                                getPlayerDefeatedNPC(cid, "Kelly Klemm") and
                                getPlayerDefeatedNPC(cid, "Erik Torrain") and
                                getPlayerDefeatedNPC(cid, "Nannie Frerichs")
                        end)]]
npcBattle:setOnWin(function(cid)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.SOUL_BADGE)
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

    if (msgcontains(msg, 'tm')) then
        if (not getPlayerDefeatedNPC(cid, getNpcName())) then
            selfSay("You must defeat me before receive your reward.", cid)

        elseif (getCreatureStorage(cid, TM_STORAGE) == QUEST_STATUS.FINISHED) then
            selfSay("You already got this reward.", cid)

        else
            giveTm(cid)
            selfSay("Oh, here is!", cid)
        end

    elseif (getPlayerDefeatedNPC(cid, getNpcName())) then
        npcHandler.talkState[talkUser] = doQuestTalk(cid, getNpcName(), msg, npcHandler.talkState[talkUser])

    elseif (msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel')) then
        talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

    elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, talkState[talkUser])

    else
        selfSay("Ok..", cid)
    end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
