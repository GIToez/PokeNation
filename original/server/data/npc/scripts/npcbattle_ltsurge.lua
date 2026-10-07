local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local TM_STORAGE = 8405
local function giveTm(cid)
    doCreatureSetStorage(cid, TM_STORAGE, QUEST_STATUS.FINISHED)
    doPlayerSafeAddItem(cid, 17359, 1, true, false, true) -- TM 23 Thunderbolt
end

local npcBattle = NpcBattle:new(getNpcName(), 9103, 9533, npcHandler)
npcBattle:setPokemons({"Raichu", "Magneton", "Raichu", "Electrode", "Magneton", "Electabuzz"})
npcBattle:setRewardBaseExp(5000)
npcBattle:setRewardBadge(BADGES.THUNDER)
npcBattle:setRewardRespect(2)
npcBattle:setPayRespect(20)
npcBattle:setOneWin(true)
npcBattle:setDifficulty(45)
npcBattle:setRequiredMessage("You must first defeat the GYM trainers before battle against me.")
npcBattle:setRequired(function(cid)
                        return getPlayerDefeatedNPC(cid, "Neil Plath") and
                                getPlayerDefeatedNPC(cid, "Clayton Giltner") and
                                getPlayerDefeatedNPC(cid, "Kurt Bufford") and
                                getPlayerDefeatedNPC(cid, "Earnestine Veale") and
                                getPlayerDefeatedNPC(cid, "Alana Montesano") and
                                getPlayerDefeatedNPC(cid, "Serena Martinek") and
                                getPlayerDefeatedNPC(cid, "Karina Rook")
                        end)
npcBattle:setOnWin(function(cid)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.THUNDER_BADGE)
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
