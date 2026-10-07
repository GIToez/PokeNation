local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local STATE_SAFFARI_ENTER = 1
local forbiddenItems = {12157, 12158, 12159, 12160, 12161, 12162, 12163, 12164, 12165, 12166, 12167, 12168,
    12169, 12170, 12171, 12172, 12173, 12174, 12175, 12176, 12177, 12178, 12179, 12180, 12181, 12182, 12183,
    12184, 12185, 12186, 12187, 12188, 1294, 13492, 13493, 13494, 13495, 14389, 14390, 14391, 14392, 14393,
    14394, 14395, 14396, 14397, 14398, 14399, 14400, 14401, 14402, 14403, 14404, 14405, 14406, 14407, 14408,
    14409, 14410, 14411, 14412, 18628, 18629, 18630, 18631, 19061, 19057, 19053, 19049, 19045, 19041, 19037,
    19033, 19029}
local safariZoneEntrancePrice = 1000
-- local enterInterval = 23 * 60 * 60

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if (msgcontains(msg, 'saffari') or msgcontains(msg, 'zone') or msgcontains(msg, 'safari') or msgcontains(msg, 'enter') or msgcontains(msg, 'zona') or msgcontains(msg, 'entrar')) then
		--[[local interval = (os.time() - getPlayerLastSafariZoneDate(cid))
        if (interval < enterInterval) then
            selfSay("You have visited the Safari recently, you must wait ".. table.concat(string.timediff(enterInterval - interval)) .." to enter again.", cid)
            talkState[talkUser] = 0

        else]]if (getPlayerLevel(cid) < 30) then
            selfSay("You need at least level 30 to enter the Safari Zone", cid)
            talkState[talkUser] = 0

        else
            selfSay(string.format(__L(cid, "Uh! The Safari Zone! I can take you there for %s dollars. Do you want?"), safariZoneEntrancePrice), cid)
            talkState[talkUser] = STATE_SAFFARI_ENTER
        end

	elseif ((msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) and talkState[talkUser] == STATE_SAFFARI_ENTER) then
        if (getPlayerMoney(cid)  >= safariZoneEntrancePrice) then
            local enter = true
            for i = 1, #forbiddenItems do
                if(getPlayerItemCount(cid, forbiddenItems[i]) > 0) then
                    enter = false
                    break
                end
            end

            if (enter) then
                enter = #getPlayerAllBallsWithPokemon(cid) == 0
            end

            if (not enter) then
                selfSay("Sorry, you can not enter in the Safari zone with any type of ball and small stones.", cid)
                talkState[talkUser] = 0
                return true
            end

            if (doTeleportThing(cid, SAFARI_START_POSITION, false)) then
                doPlayerRemoveMoney(cid, safariZoneEntrancePrice)
                setSafariZone(cid, true)
                doPlayerAddUniqueItem(cid, EMPTY_SAFARI_BALL_ID, 20, false) -- empty saffari balls
                doPlayerAddUniqueItem(cid, 14800, 10, false) -- safari bait
                doPlayerAddUniqueItem(cid, 14799, 200, false) -- safari cookie
                doPlayerAddUniqueItem(cid, 14798, 100, false) -- safari small stone
                doPlayerAddUniqueItem(cid, 14796, 10, false) -- safari trap
                setPlayerLastSafariZoneDate(cid, os.time())
                setPlayerSafariZonePass(cid, 2)
                doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.VISIT_KANTO_SAFARI, 1)
                setPlayerDisconnectAtExit(cid, false)
            end

	    else
			selfSay("You do not enough money.", cid)
            talkState[talkUser] = 0
		end

	else
		talkState[talkUser] = 0
		selfSay("Sorry?", cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
