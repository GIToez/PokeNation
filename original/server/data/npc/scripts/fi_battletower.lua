local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local TALKSTATES = {}
TALKSTATES.NONE = 0
TALKSTATES.TWENTY = 1
TALKSTATES.TWENTY_ACCEPT = 2
TALKSTATES.FIFTEEN = 3
TALKSTATES.FIFTEEN_ACCEPT = 4
TALKSTATES.TEN = 5
TALKSTATES.TEN_ACCEPT = 6

local TWENTY_COST = 1000
local FIFTEEN_COST = 1000
local TEN_COST = 1000

local TWENTY_POS = {x = 5054, y = 147, z = 8}
local FIFTEEN_POS = {x = 5075, y = 148, z = 8}
local TEN_POS = {x = 5066, y = 128, z = 7}

local TWENTY_LEVEL = 75
local FIFTEEN_LEVEL = 85
local TEN_LEVEL = 95

local ENTRANCE_INTERVAL = 23 * 60 * 60

local PKS = {
    -- Normal, Flying
    PK1 = {"Pidgeot", "Fearow", "Clefable", "Wigglytuff", "Dodrio", "Kangaskhan", "Tauros", "Noctowl", "Granbull", "Ursaring" },
    -- Fire, Fight
    PK2 = {"Charizard", "Ninetales", "Arcanine", "Rapidash", "Typhlosion", "Magcargo", "Houndoom", "Primeape", "Machamp" },
    -- Water, Psychic
    PK3 = {"Blastoise", "Poliwrath", "Tentacruel", "Slowbro", "Dewgong", "Cloyster", "Kingler", "Kingdra", "Lapras", "Gyarados", "Feraligatr", "Lanturn", "Azumarill", "Politoed", "Octillery", "Alakazam", "Hypno" },
    -- Electric, Ghost
    PK4 = {"Raichu", "Magneton", "Ampharos", "Gengar"},
    -- Grass, Bug, Poison
    PK5 = {"Venusaur", "Vileplume", "Parasect", "Victreebel", "Exeggutor", "Tangela", "Meganium", "Bellossom", "Jumpluff", "Sunflora", "Butterfree", "Beedrill", "Scizor", "Ariados", "Ledian", "Heracross" },
    -- Rock, Ground
    PK6 = {"Golem", "Rhydon", "Shuckle", "Sandslash", "Nidoqueen", "Nidoking", "Dugtrio", "Marowak", "Rhydon", "Quagsire", "Steelix", "Piloswine", "Donphan"}
}

local function doPlayerCheck(cid)
    local items = {12244, 12245, 12246, 12247, 12248, 12249, 12250, 13653, 13819, 13182, 13183, 13184, 13185, 14766, 13186, 14767, 14768, 14769, 14770}
    for _, id in ipairs(items) do
        if (getPlayerItemCount(cid, id) > 0) then
            return false
        end
    end
    return true
end

local function startChallenge(cid, startPos, level)
    local balls = {}
    for _, pks in pairs(PKS) do
        local ball = doCreatePokemonBall(cid, "frontier", table.random(pks), level, nil, nil, level, cid, nil,
            nil, nil, nil, nil, nil, nil, nil, nil, false, nil)
        if (ball) then
            balls[#balls + 1] = ball
        else
            for _, uid in pairs(balls) do
                doRemoveItem(uid, 1)
            end
            return false
        end
    end

    if (doTeleportThing(cid, startPos)) then
        setPlayerFrontierIsland(cid, true)
        doCreatureSay(cid, __L(cid, "hi"), TALKTYPE_SAY)
        return true
    end
    return false
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

    elseif (msgcontains(msg, 'battle') or msgcontains(msg, 'tower') or msgcontains(msg, 'batalha') or msgcontains(msg, 'torre')) then
        selfSay("I can offer you three challenges in the Battle Tower: {Twenty}, {Fifteen} and {Ten}.", cid)

    elseif (msgcontains(msg, 'twenty')) then
        selfSay("In Twenty mode you face several Pokemon trainers. If you want this challenge, say 'enter'.", cid)
        talkState[talkUser] = TALKSTATES.TWENTY

    elseif (msgcontains(msg, 'fifteen')) then
        selfSay("In Fifteen mode you face several Pokemon trainers. If you want this challenge, say 'enter'.", cid)
        talkState[talkUser] = TALKSTATES.FIFTEEN

    elseif (msgcontains(msg, 'ten')) then
        selfSay("In Ten mode you face several Pokemon trainers. If you want this challenge, say 'enter'.", cid)
        talkState[talkUser] = TALKSTATES.TEN

    elseif (msgcontains(msg, 'enter') or msgcontains(msg, 'entrar')) then
        if (talkState[talkUser] == TALKSTATES.TWENTY) then
            selfSay(string.format(__L(cid, "Do you want to enter the Twenty mode? This will cost you %s dollars."), TWENTY_COST), cid)
            talkState[talkUser] = TALKSTATES.TWENTY_ACCEPT

        elseif (talkState[talkUser] == TALKSTATES.FIFTEEN) then
            selfSay(string.format(__L(cid, "Do you want to enter the Fifteen mode? This will cost you %s dollars."), FIFTEEN_COST), cid)
            talkState[talkUser] = TALKSTATES.FIFTEEN_ACCEPT

        elseif (talkState[talkUser] == TALKSTATES.TEN) then
            selfSay(string.format(__L(cid, "Do you want to enter the Ten mode? This will cost you %s dollars."), TEN_COST), cid)
            talkState[talkUser] = TALKSTATES.TEN_ACCEPT
        end

    elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        if (talkState[talkUser] == TALKSTATES.TWENTY_ACCEPT) then
            talkState[talkUser] = TALKSTATES.NONE

            local interval = (os.time() - getPlayerLastBattleTowerTwenty(cid))
            if (interval < ENTRANCE_INTERVAL) then
                selfSay(string.format(__L(cid, "You have visited the Twenty tower recently, you must wait %s to enter again."), table.concat(string.timediff(ENTRANCE_INTERVAL - interval, cid))), cid)
                return true

            elseif (#getPlayerAllBallsWithPokemon(cid) > 0) then
                selfSay("You can not enter the arena while carrying any Pokemon!", cid)
                return true

            elseif (not doPlayerCheck(cid)) then
                selfSay("You can not enter the arena while carrying any type of potion or berries!", cid)
                return true

            elseif (getPlayerLevel(cid) < (TWENTY_LEVEL - 5)) then
                selfSay(string.format(__L(cid, "You need at least level %s to challenge this mode!"), (TWENTY_LEVEL - 5)), cid)
                return true

            elseif (not doPlayerRemoveMoney(cid, TWENTY_COST)) then
                selfSay("You do not have enough money.", cid)
                return true
            end

            if (startChallenge(cid, TWENTY_POS, TWENTY_LEVEL)) then
                setPlayerLastBattleTowerTwenty(cid, os.time())
            else
                doPlayerAddMoney(cid, TWENTY_COST)
                doPlayerRemoveFrontierBalls(cid) -- Just to be sure
                selfSay("You do not have enough space to receive Pokemon! Check your backpack.", cid)
            end

        elseif (talkState[talkUser] == TALKSTATES.FIFTEEN_ACCEPT) then
            talkState[talkUser] = TALKSTATES.NONE

            local interval = (os.time() - getPlayerLastBattleTowerFifteen(cid))
            if (interval < ENTRANCE_INTERVAL) then
                selfSay(string.format(__L(cid, "You have visited the Fifteen tower recently, you must wait %s to enter again."), table.concat(string.timediff(ENTRANCE_INTERVAL - interval, cid))), cid)
                return true

            elseif (#getPlayerAllBallsWithPokemon(cid) > 0) then
                selfSay("You can not enter the arena while carrying any Pokemon!", cid)
                return true

            elseif (not doPlayerCheck(cid)) then
                selfSay("You can not enter the arena while carrying any type of potion or berries!", cid)
                return true

            elseif (getPlayerLevel(cid) < (FIFTEEN_LEVEL - 5)) then
                selfSay(string.format(__L(cid, "You need at least level %s to challenge this mode!"), (FIFTEEN_LEVEL - 5)), cid)
                return true

            elseif (not doPlayerRemoveMoney(cid, FIFTEEN_COST)) then
                selfSay("You do not have enough money.", cid)
                return true
            end

            if (startChallenge(cid, FIFTEEN_POS, FIFTEEN_LEVEL)) then
                setPlayerLastBattleTowerFifteen(cid, os.time())
            else
                doPlayerAddMoney(cid, FIFTEEN_COST)
                doPlayerRemoveFrontierBalls(cid) -- Just to be sure
                selfSay("You do not have enough space to receive Pokemon! Check your backpack.", cid)
            end

        elseif (talkState[talkUser] == TALKSTATES.TEN_ACCEPT) then
            talkState[talkUser] = TALKSTATES.NONE

            local interval = (os.time() - getPlayerLastBattleTowerTen(cid))
            if (interval < ENTRANCE_INTERVAL) then
                selfSay(string.format(__L(cid, "You have visited the Ten tower recently, you must wait %s to enter again."), table.concat(string.timediff(ENTRANCE_INTERVAL - interval, cid))), cid)
                return true

            elseif (#getPlayerAllBallsWithPokemon(cid) > 0) then
                selfSay("You can not enter the arena while carrying any Pokemon!", cid)
                return true

            elseif (not doPlayerCheck(cid)) then
                selfSay("You can not enter the arena while carrying any type of potion or berries!", cid)
                return true

            elseif (getPlayerLevel(cid) < (TEN_LEVEL - 5)) then
                selfSay(string.format(__L(cid, "You need at least level %s to challenge this mode!"), (TEN_LEVEL - 5)), cid)
                return true

            elseif (not doPlayerRemoveMoney(cid, TEN_COST)) then
                selfSay("You do not have enough money.", cid)
                return true
            end

            if (startChallenge(cid, TEN_POS, TEN_LEVEL)) then
                setPlayerLastBattleTowerTen(cid, os.time())
            else
                doPlayerAddMoney(cid, TEN_COST)
                doPlayerRemoveFrontierBalls(cid) -- Just to be sure
                selfSay("You do not have enough space to receive Pokemon! Check your backpack.", cid)
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
