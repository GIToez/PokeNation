local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local TALKSTATES = {}
TALKSTATES.NONE = 0
TALKSTATES.WAVEARENA = 1
TALKSTATES.WAVEARENA_ACCEPT = 2

local WAVEARENA_LEVEL = 20
local PLAYER_CACHE_MAX = 5
local PLAYER_CACHE = {}

local function getArenaCost(playerLevel)
    if (playerLevel >= 90) then
        return 50000
    elseif (playerLevel >= 80) then
        return 40000
    elseif (playerLevel >= 70) then
        return 30000
    elseif (playerLevel >= 60) then
        return 20000
    elseif (playerLevel >= 50) then
        return 10000
    elseif (playerLevel >= 40) then
        return 5000
    elseif (playerLevel >= 30) then
        return 3000
    elseif (playerLevel >= 20) then
        return 1000
    end
    return 100
end

local function getPlayerAccountPlayedToday(cid)
    local dbResult = db.getResult("SELECT 1 FROM datalog_colosseum_arena WHERE account_id = ".. getPlayerAccountId(cid) .." AND DATEDIFF(NOW(), FROM_UNIXTIME(`date`)) < 1 ORDER BY `date` DESC LIMIT 1;")
    if dbResult:getID() == -1 then
        return false
    end
    dbResult:free()
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

    if (msgcontains(msg, 'colosseum') or msgcontains(msg, 'arena')) then
        selfSay("Here you can face the Colosseum Arena, a singleplayer mode game that will test your trainer skills. If you want this challenge, say 'enter'.", cid)
        talkState[talkUser] = TALKSTATES.WAVEARENA

    elseif (msgcontains(msg, 'enter') or msgcontains(msg, 'entrar')) then
        if (talkState[talkUser] == TALKSTATES.WAVEARENA) then
            selfSay(string.format(__L(cid, "Do you want to enter the Colosseum Arena? This will cost you %s dollars."), getArenaCost(getPlayerLevel(cid))), cid)
            talkState[talkUser] = TALKSTATES.WAVEARENA_ACCEPT
        end

    elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        if (talkState[talkUser] == TALKSTATES.WAVEARENA_ACCEPT) then
            talkState[talkUser] = TALKSTATES.NONE

            if (PLAYER_CACHE[cid] and PLAYER_CACHE[cid] >= PLAYER_CACHE_MAX) then
                selfSay(string.format(__L(cid, "You have reached the maximum daily attempt of %s times! Try again tomorrow."), PLAYER_CACHE_MAX), cid)
                return true
            else
                PLAYER_CACHE[cid] = 0
            end

            local arena = WaveArena.getFreeArena()
            if (not arena) then
                selfSay("Sorry, there is no arena free now. Please, try again later.", cid)
                return true

            elseif (getPlayerLevel(cid) < WAVEARENA_LEVEL) then
                selfSay(string.format(__L(cid, "You need at least level %s to challenge this game!"), WAVEARENA_LEVEL), cid)
                return true

            elseif (not isPremium(cid)) then
                selfSay("Sorry, only Premmium Accounts can join this game.", cid)
                return true

            elseif (not getPlayerColosseumArenaPaid(cid) and not doPlayerRemoveMoney(cid, getArenaCost(getPlayerLevel(cid)))) then
                selfSay("You do not have enough money.", cid)
                return true

            elseif (getPlayerAccountPlayedToday(cid)) then
                selfSay("One of your account character's already played the Colosseum Arena today! Please try again tomorrow.", cid)
                return true
            end

            if (not WaveArena.onStart(cid, arena)) then
                LOG(LOG_TYPES.ERROR, "wavearena - Can't start.", getCreatureName(cid), arena)
                selfSay("Something got wrong, please try again later.", cid)
                return true

            else
                setPlayerColosseumArenaPaid(cid, true)
                PLAYER_CACHE[cid] = PLAYER_CACHE[cid] + 1
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
