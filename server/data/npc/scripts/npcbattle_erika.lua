local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local TM_STORAGE = 8402
local function giveTm(cid)
    doCreatureSetStorage(cid, TM_STORAGE, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 17356, 1, true, false, true) -- TM 20 Mega Drain
end

local npcBattle = NpcBattle:new(getNpcName(), 9104, 9518, npcHandler)
npcBattle:setPokemons({"Victreebel", "Tangela", "Vileplume", "Vileplume", "Venusaur", "Exeggutor"})
npcBattle:setRewardBaseExp(5000)
npcBattle:setRewardBadge(BADGES.RAINBOW)
npcBattle:setRewardRespect(2)
npcBattle:setPayRespect(30)
npcBattle:setOneWin(true)
npcBattle:setDifficulty(55)
npcBattle:setRequiredMessage("You must first defeat the GYM trainers before battle against me.")
npcBattle:setRequired(function(cid)
                        return getPlayerDefeatedNPC(cid, "Max Mcgeorge") and
                                getPlayerDefeatedNPC(cid, "Max Tippins") and
                                getPlayerDefeatedNPC(cid, "Clayton Bibeau") and
                                getPlayerDefeatedNPC(cid, "Cody Tschida") and
                                getPlayerDefeatedNPC(cid, "Kenya Madere") and
                                getPlayerDefeatedNPC(cid, "Liza Zamor") and
                                getPlayerDefeatedNPC(cid, "Carlene Nulph")
                        end)
npcBattle:setOnWin(function(cid)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.RAINBOW_BADGE)
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
