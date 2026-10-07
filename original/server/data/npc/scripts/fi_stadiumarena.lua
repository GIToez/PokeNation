local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local TALKSTATES = {}
TALKSTATES.NONE = 0
TALKSTATES.GLADIATOR = 1
TALKSTATES.GLADIATOR_ACCEPT = 2
TALKSTATES.COOPERATIVE = 3
TALKSTATES.COOPERATIVE_CHOOSE = 4
TALKSTATES.COOPERATIVE_ELITE_ACCEPT = 5
TALKSTATES.COOPERATIVE_TITAN_ACCEPT = 6
TALKSTATES.SURVIVE = 7
TALKSTATES.SURVIVE_CHOOSE = 8
TALKSTATES.SURVIVE_CHALLENGE_ACCEPT = 9
TALKSTATES.SURVIVE_HARDCORE_ACCEPT = 10

local GLADIATOR_COST = 500
local COOPERATIVE_COST = 500
local SURVIVE_COST = 500

local GLADIATOR_LEVEL = 50
local COOPERATIVE_LEVEL = 50
local SURVIVE_LEVEL = 50

local function doPlayerCheck(cid)
    local items = {12244, 12245, 12246, 12247, 12248, 12249, 12250, 13653, 13819}
    for _, id in ipairs(items) do
        if (getPlayerItemCount(cid, id) > 0) then
            return false
        end
    end
    return true
end

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)    npcHandler:onCreatureSay(cid, type, msg)      end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'frontier') or msgcontains(msg, 'island') or msgcontains(msg, 'ilha')) then
        selfSay("You're in the Frontier Island, an appropriate location to test for the continent's greatest Pokemon trainers. Prove your strength here and you will be rewarded.", cid)

    elseif (msgcontains(msg, 'stadium') or msgcontains(msg, 'arena')) then
        selfSay("I can offer you three challenges in the Stadium Arena: {Gladiator}, {Cooperative} and {Survive}.", cid)

    elseif (msgcontains(msg, 'gladiator')) then
        selfSay("In Gladiator mode you face several challenges in the best singleplayer mode. If you want this challenge, say 'enter'.", cid)
        talkState[talkUser] = TALKSTATES.GLADIATOR

    elseif (msgcontains(msg, 'cooperative')) then
        selfSay("In cooperative mode you face many challenges as a group, for this you need to be in a Party. If you want this challenge, say 'enter'.", cid)
        talkState[talkUser] = TALKSTATES.COOPERATIVE

    elseif (msgcontains(msg, 'survive')) then
        selfSay("In survive mode you face PvP games. If you want this challenge, say 'enter'.", cid)
        talkState[talkUser] = TALKSTATES.SURVIVE

    elseif (msgcontains(msg, 'enter') or msgcontains(msg, 'entrar')) then
        if (talkState[talkUser] == TALKSTATES.GLADIATOR) then
            selfSay(string.format(__L(cid, "Do you want to enter the Gladiator mode? This will cost you %s dollars."), GLADIATOR_COST), cid)
            talkState[talkUser] = TALKSTATES.GLADIATOR_ACCEPT

        elseif (talkState[talkUser] == TALKSTATES.COOPERATIVE) then
            selfSay("Right! What Cooperative mode you want? Your options are: {Elite}(4 players) and {Titan}(6 players).", cid)
            talkState[talkUser] = TALKSTATES.COOPERATIVE_CHOOSE

        elseif (talkState[talkUser] == TALKSTATES.SURVIVE) then
            selfSay(string.format(__L(cid, "What Survive mode you want? Your options are: {Challenge}(PvP - %s players) and {Hardcore}(PvP and PvE - %s players)."), SurviveChallenge.Config.REQUIRED_PLAYERS, SurviveHardcore.Config.REQUIRED_PLAYERS), cid)
            talkState[talkUser] = TALKSTATES.SURVIVE_CHOOSE
        end

    elseif (msgcontains(msg, 'elite') and talkState[talkUser] == TALKSTATES.COOPERATIVE_CHOOSE) then
        selfSay(string.format(__L(cid, "Do you want to enter the Cooperative Elite mode? This will cost you %s dollars."), COOPERATIVE_COST), cid)
        talkState[talkUser] = TALKSTATES.COOPERATIVE_ELITE_ACCEPT

    elseif (msgcontains(msg, 'titan') and talkState[talkUser] == TALKSTATES.COOPERATIVE_CHOOSE) then
        selfSay(string.format(__L(cid, "Do you want to enter the Cooperative Titan mode? This will cost you %s dollars."), COOPERATIVE_COST), cid)
        talkState[talkUser] = TALKSTATES.COOPERATIVE_TITAN_ACCEPT

    elseif (msgcontains(msg, 'challenge') and talkState[talkUser] == TALKSTATES.SURVIVE_CHOOSE) then
        selfSay(string.format(__L(cid, "Do you want to enter the Survive Challenge mode? This will cost you %s dollars."), SURVIVE_COST), cid)
        talkState[talkUser] = TALKSTATES.SURVIVE_CHALLENGE_ACCEPT

    elseif (msgcontains(msg, 'hardcore') and talkState[talkUser] == TALKSTATES.SURVIVE_CHOOSE) then
        selfSay(string.format(__L(cid, "Do you want to enter the Survive Hardcore mode? This will cost you %s dollars."), SURVIVE_COST), cid)
        talkState[talkUser] = TALKSTATES.SURVIVE_HARDCORE_ACCEPT

    elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        if (talkState[talkUser] == TALKSTATES.GLADIATOR_ACCEPT) then
            talkState[talkUser] = TALKSTATES.NONE

            local arena = Gladiator.getFreeArena()
            if (not arena) then
                selfSay("Sorry, there is no arena free now. Please, try again later.", cid)
                return true

            elseif (not doPlayerCheck(cid)) then
                selfSay("You can not enter the arena while carrying any type of potion!", cid)
                return true

            elseif (getPlayerLevel(cid) < GLADIATOR_LEVEL) then
                selfSay(string.format(__L(cid, "You need at least level %s to challenge this mode!"), GLADIATOR_LEVEL), cid)
                return true

            elseif (not isPremium(cid)) then
                selfSay("Sorry, only Premmium Accounts can join this challenge.", cid)
                return true

            elseif (not doPlayerRemoveMoney(cid, GLADIATOR_COST)) then
                selfSay("You do not have enough money.", cid)
                return true
            end

            if (not Gladiator.onStart(cid, arena)) then
                LOG(LOG_TYPES.ERROR, "fi_stadiumarena - Gladiator can't start.", getCreatureName(cid), arena)
                selfSay("Something got wrong, please try again later.", cid)
                return true
            end

        elseif (talkState[talkUser] == TALKSTATES.COOPERATIVE_ELITE_ACCEPT) then
            talkState[talkUser] = TALKSTATES.NONE

            local party = getPlayerParty(cid)
            if (not party) then
                selfSay("You aren't in a group! To participate in cooperative mode you first need to form a Party.", cid)
                return true

            elseif (party ~= cid) then
                selfSay("You are not the leader of your Party! Only the group leader who can enroll in cooperative mode.", cid)
                return true
            end

            local members = getPartyMembers(party)
            if (#members ~= 4) then
                selfSay("Your group haven't 4 members! You can only enroll in cooperative mode with 4 members in the Party.", cid)
                return true
            end

            local arena = CooperativeElite.getFreeArena()
            if (not arena) then
                selfSay("Sorry, there is no arena free now. Please, try again later.", cid)
                return true
            end

            for _, c in pairs(members) do
                if (getPlayerLevel(c) < COOPERATIVE_LEVEL) then
                    selfSay(string.format(__L(cid, "You can't enter while you or your Party members aren't at least level %s."), COOPERATIVE_LEVEL), cid)
                    return true

                elseif (not isPremium(c)) then
                    selfSay("You can't enter while you or your Party members haven't a Premium Account.", cid)
                    return true

                elseif (not doPlayerCheck(c)) then
                    selfSay("You can't enter while you or your Party members are carrying any type of potion!", cid)
                    return true

                elseif (getDistanceBetween(getCreaturePosition(c), getCreaturePosition(cid)) > 3) then
                    selfSay("You can't enter while one of your party members are too far from you!", cid)
                    return true
                end
            end

            if (not doPlayerRemoveMoney(cid, COOPERATIVE_COST)) then
                seflSay("You do not have the money to enroll your group!", cid)
                return true
            end

            if (not CooperativeElite.onStart(members, arena)) then
                LOG(LOG_TYPES.ERROR, "fi_stadiumarena - CooperativeElite can't start.", getCreatureName(cid), arena)
                selfSay("Something got wrong, please try again later.", cid)
                return true
            end

        elseif (talkState[talkUser] == TALKSTATES.COOPERATIVE_TITAN_ACCEPT) then
            talkState[talkUser] = TALKSTATES.NONE

            local party = getPlayerParty(cid)
            if (not party) then
                selfSay("You aren't in a group! To participate in cooperative mode you first need to form a Party.", cid)
                return true

            elseif (party ~= cid) then
                selfSay("You are not the leader of your Party! Only the group leader who can enroll in cooperative mode.", cid)
                return true
            end

            local members = getPartyMembers(party)
            if (#members ~= 6) then
                selfSay("Your group haven't 6 members! You can only enroll in cooperative mode with 4 members in the Party.", cid)
                return true
            end

            local arena = CooperativeTitan.getFreeArena()
            if (not arena) then
                selfSay("Sorry, there is no arena free now. Please, try again later.", cid)
                return true
            end

            for _, c in pairs(members) do
                if (getPlayerLevel(c) < COOPERATIVE_LEVEL) then
                    selfSay(string.format(__L(cid, "You can't enter while you or your Party members aren't at least level %s."), COOPERATIVE_LEVEL), cid)
                    return true

                elseif (not isPremium(c)) then
                    selfSay("You can't enter while you or your Party members haven't a Premium Account.", cid)
                    return true

                elseif (not doPlayerCheck(c)) then
                    selfSay("You can't enter while you or your Party members are carrying any type of potion!", cid)
                    return true

                elseif (getDistanceBetween(getCreaturePosition(c), getCreaturePosition(cid)) > 3) then
                    selfSay("You can't enter while one of your party members are too far from you!", cid)
                    return true
                end
            end

            if (not doPlayerRemoveMoney(cid, COOPERATIVE_COST)) then
                seflSay("You do not have the money to enroll your group!", cid)
                return true
            end

            if (not CooperativeTitan.onStart(members, arena)) then
                LOG(LOG_TYPES.ERROR, "fi_stadiumarena - CooperativeTitan can't start.", getCreatureName(cid), arena)
                selfSay("Something got wrong, please try again later.", cid)
                return true
            end

        elseif (talkState[talkUser] == TALKSTATES.SURVIVE_CHALLENGE_ACCEPT) then
            talkState[talkUser] = TALKSTATES.NONE

            if (not SurviveChallenge.getFreeArena()) then
                selfSay("Sorry, there is no arena free now. Please, try again later.", cid)
                return true

            elseif (not doPlayerCheck(cid)) then
                selfSay("You can not enter the arena while carrying any type of potion!", cid)
                return true

            elseif (getPlayerLevel(cid) < SURVIVE_LEVEL) then
                selfSay(string.format(__L(cid, "You need at least level %s to challenge this mode!"), SURVIVE_LEVEL), cid)
                return true

            elseif (not isPremium(cid)) then
                selfSay("Sorry, only Premmium Accounts can join this challenge.", cid)
                return true

            elseif (not doPlayerRemoveMoney(cid, SURVIVE_LEVEL)) then
                selfSay("You do not have enough money.", cid)
                return true

            elseif (not SurviveChallenge.joinPlayer(cid)) then
                doPlayerAddMoney(cid, SURVIVE_COST)
                selfSay("You can't join right now. Please try again later.", cid)
            end

        elseif (talkState[talkUser] == TALKSTATES.SURVIVE_HARDCORE_ACCEPT) then
            talkState[talkUser] = TALKSTATES.NONE

            if (not SurviveHardcore.getFreeArena()) then
                selfSay("Sorry, there is no arena free now. Please, try again later.", cid)
                return true

            elseif (not doPlayerCheck(cid)) then
                selfSay("You can not enter the arena while carrying any type of potion!", cid)
                return true

            elseif (getPlayerLevel(cid) < SURVIVE_LEVEL) then
                selfSay(string.format(__L(cid, "You need at least level %s to challenge this mode!"), SURVIVE_LEVEL), cid)
                return true

            elseif (not isPremium(cid)) then
                selfSay("Sorry, only Premmium Accounts can join this challenge.", cid)
                return true

            elseif (not doPlayerRemoveMoney(cid, SURVIVE_LEVEL)) then
                selfSay("You do not have enough money.", cid)
                return true

            elseif (not SurviveHardcore.joinPlayer(cid)) then
                doPlayerAddMoney(cid, SURVIVE_COST)
                selfSay("You can't join right now. Please try again later.", cid)
            end

        else
            selfSay("Sorry? I don't know what you are talking about.", cid)
        end

    else
        selfSay("Sorry?", cid)
    end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
