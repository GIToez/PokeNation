--[[ Config ]]
local MASTERY = MASTERYID_VOLTAGIC
local FIRST_RANK = VOCATIONID_VOLTAGICSTARTER
local ASSISTANT = "West"
local MASTERY_NAME = "Voltagic"

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local TALKSTATE_NONE = 0
local TALKSTATE_JOIN = 1
local TALKSTATE_JOIN_2 = 2
local TALKSTATE_NEXT = 3
local TALKSTATE_NEXT_2 = 4
local TALKSTATE_DUNGEON = 5
local TALKSTATE_JOIN_CONFIRM = 6
local TALKSTATE_LEAVE = 7

local function getRequiredStonesMessage()
    local out = ""
    for i, stone in ipairs(getMasteryRequiredStones(MASTERY)) do
        out = out .. getItemNameById(stone.itemid) .. " (" .. getMasteryPlatePoints(stone.itemid) .. " points)"
        if (i+1 == #getMasteryRequiredStones(MASTERY)) then
            out = out .. " or "
        elseif (i < #getMasteryRequiredStones(MASTERY)) then
            out = out .. ", "
        end
    end
    return out .. " until you reach " .. MASTERY_REQUIRED_PLATE_POINTS .. " points"
end
local requiredStoneMessage = getRequiredStonesMessage()
getRequiredStonesMessage = nil

local function checkPlayerRequiredStones(cid)
    local points = 0
    local i, stone
    for i, stone in ipairs(getMasteryRequiredStones(MASTERY)) do
        points = points + (getPlayerItemCount(cid, stone.itemid) * getMasteryPlatePoints(stone.itemid))
    end
    return points >= MASTERY_REQUIRED_PLATE_POINTS
end

local function removePlayerRequiredStones(cid)
    local points = MASTERY_REQUIRED_PLATE_POINTS
    local i, stone
    for i, stone in ipairs(getMasteryRequiredStones(MASTERY)) do
        if (points <= 0) then
            break
        end

        local count = getPlayerItemCount(cid, stone.itemid)
        while (count > 0 and points > 0) do
            doPlayerRemoveItem(cid, stone.itemid, 1)
            points = points - getMasteryPlatePoints(stone.itemid)
            count = count - 1
        end
    end
end

local function getRequiredTokensToNextRank(cid)
    return getMasteryRankRequiredTokens(MASTERY, getMasteryRankNext(MASTERY, getPlayerMasteryRank(cid)))
end

local function checkPlayerPokemon(cid)
    local i, ball
    for i, ball in ipairs(getPlayerAllBallsWithPokemon(cid)) do
        local name = getBallPokemonName(ball.uid)
        if (name == "Ditto") then
            return false
        end

        local found = false
        for j, type in ipairs(getPokemonTypes(nil, name)) do
            if (isInArray(getMasteryElements(MASTERY), type)) then
                found = true
                break
            end
        end
        if (not found) then
            return false
        end
    end
    return true
end

function creatureSayCallback(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'join') or msgcontains(msg, 'enter') or msgcontains(msg, MASTERY_NAME) or msgcontains(msg, 'entrar')) then
        local mastery = getPlayerMastery(cid)
        if (not mastery) then
            selfSay(string.format(__L(cid, "Do you want to join into the %s Mastery?"), MASTERY_NAME), cid)
            talkState[talkUser] = TALKSTATE_JOIN
        elseif (mastery ~= MASTERY) then
            selfSay('You already has a mastery, if you want to join here first you need to dismiss with your mastery leader.', cid)
            talkState[talkUser] = TALKSTATE_NONE
        elseif (not getMasteryRankNext(MASTERY, getPlayerMasteryRank(cid))) then
            selfSay("You're already at the last level of this mastery.", cid)
            talkState[talkUser] = TALKSTATE_NONE
        else
            selfSay("Are you ready to the next level?", cid)
            talkState[talkUser] = TALKSTATE_NEXT
        end

    elseif (msgcontains(msg, 'dungeon') or msgcontains(msg, 'calabouco')) then
        selfSay("Are you ready to the dungeon?", cid)
        talkState[talkUser] = TALKSTATE_DUNGEON

    elseif (msgcontains(msg, 'dismiss') or msgcontains(msg, 'leave') or msgcontains(msg, 'sair')) then
        local mastery = getPlayerMastery(cid)
        if (not mastery) then
            selfSay("You do not have a mastery.", cid)
            talkState[talkUser] = TALKSTATE_NONE
        elseif (mastery ~= MASTERY) then
            selfSay("You need to dismiss with your mastery leader, not here.", cid)
            talkState[talkUser] = TALKSTATE_NONE
        else
            selfSay("Do you really want to leave the mastery?", cid)
            talkState[talkUser] = TALKSTATE_LEAVE
        end

    elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        if (talkState[talkUser] == TALKSTATE_JOIN) then
            if (getPlayerLevel(cid) < getMasteryRequiredLevel(MASTERY)) then
                selfSay(string.format(__L(cid, "You need at least level %s to join here."), getMasteryRequiredLevel(MASTERY)), cid)
                talkState[talkUser] = TALKSTATE_NONE

            elseif (not isPremium(cid)) then
                selfSay("Your account must be with the premium days to join here.", cid)
                talkState[talkUser] = TALKSTATE_NONE

            elseif (getPlayerDefeatedNPC(cid, ASSISTANT)) then
                selfSay(string.format(__L(cid, "Do you really want to join into the %s Mastery?"), MASTERY_NAME), cid)
                talkState[talkUser] = TALKSTATE_JOIN_CONFIRM

            elseif (getPlayerMasteryStonesPayed(cid, MASTERY)) then
                selfSay(string.format(__L(cid, "You have already paid the necessary plates, now you need to win my assistant %s."), ASSISTANT), cid)
                talkState[talkUser] = TALKSTATE_NONE

            else
                selfSay(string.format(__L(cid, "To join into %s Mastery you will need %s. You're with them?"), MASTERY_NAME, requiredStoneMessage), cid)
                talkState[talkUser] = TALKSTATE_JOIN_2
            end

        elseif (talkState[talkUser] == TALKSTATE_JOIN_2) then
            if (getPlayerMasteryStonesPayed(cid, MASTERY)) then
                selfSay(string.format(__L(cid, "You have already paid the necessary plates, now you need to win my assistant %s."), ASSISTANT), cid)
            elseif (checkPlayerRequiredStones(cid)) then
                removePlayerRequiredStones(cid)
                setPlayerMasteryStonesPayed(cid, MASTERY, masteryRank)
                selfSay(string.format(__L(cid, "To complete your initiation, you must win a battle with my assistant %s."), ASSISTANT), cid)
            else
                selfSay(string.format(__L(cid, "You do not have the necessary plates, come back here when you're with them. Remember that you must achieve %s points through our element plates."), MASTERY_REQUIRED_PLATE_POINTS), cid)
            end
            talkState[talkUser] = TALKSTATE_NONE

        elseif (talkState[talkUser] == TALKSTATE_JOIN_CONFIRM) then
            setPlayerMasteryRank(cid, MASTERY, FIRST_RANK)
            selfSay(string.format(__L(cid, "Congratulations! You are now part of %s Mastery! Honor your Mastery!"), MASTERY_NAME), cid)
            talkState[talkUser] = TALKSTATE_NONE

        elseif (talkState[talkUser] == TALKSTATE_NEXT) then
            if (getPlayerMasteryRankDungeonDone(cid, MASTERY, getMasteryRankNext(MASTERY, getPlayerMasteryRank(cid)))) then
                setPlayerMasteryRank(cid, MASTERY, getMasteryRankNext(MASTERY, getPlayerMasteryRank(cid)))
                selfSay(string.format(__L(cid, "Congratulations! You were promoted in %s Mastery!"), MASTERY_NAME), cid)
                talkState[talkUser] = TALKSTATE_NONE
            elseif (getPlayerLevel(cid) < getMasteryRankRequiredLevel(MASTERY, getMasteryRankNext(MASTERY, getPlayerMasteryRank(cid)))) then
                selfSay(string.format(__L(cid, "You need at least level %s to advance."), getMasteryRankRequiredLevel(MASTERY, getMasteryRankNext(MASTERY, getPlayerMasteryRank(cid)))), cid)
                talkState[talkUser] = TALKSTATE_NONE
            elseif (getPlayerMasteryRankTokensPayed(cid, MASTERY, getPlayerMasteryRank(cid))) then
                selfSay("You have already paid the necessary tokens, now you need to win the {dungeon}.", cid)
                talkState[talkUser] = TALKSTATE_NONE
            elseif (getMasteryRankNext(MASTERY, getPlayerMasteryRank(cid))) then
                selfSay(string.format(__L(cid, "To advance in rank within the Mastery you need to prove that you're dominating it, joining %s tokens, you can get them by completing missions with the inhabitants of this base. You are already with the %s %s tokens?"), MASTERY_NAME, getRequiredTokensToNextRank(cid), MASTERY_NAME), cid)
                talkState[talkUser] = TALKSTATE_NEXT_2
            else
                selfSay("You're already at the last level of this mastery.", cid)
                talkState[talkUser] = TALKSTATE_NONE
            end

        elseif (talkState[talkUser] == TALKSTATE_NEXT_2) then
            if (getPlayerItemCount(cid, getMasteryToken(MASTERY)) >= getRequiredTokensToNextRank(cid)) then
                doPlayerRemoveItem(cid, getMasteryToken(MASTERY), getRequiredTokensToNextRank(cid))
                setPlayerMasteryRankTokensPayed(cid, MASTERY, getPlayerMasteryRank(cid))
                selfSay("Now you're ready to make the {dungeon} and prove that you are able to advance. When you are ready come talk to me.", cid)
            else
                selfSay("You do not have the necessary tokens, come back here when you're with them.", cid)
            end
            talkState[talkUser] = TALKSTATE_NONE

        elseif (talkState[talkUser] == TALKSTATE_DUNGEON) then
            if (not getPlayerMastery(cid) or getPlayerMastery(cid) ~= MASTERY) then
                selfSay("You are not in this mastery, you must first {join} us.", cid)
            elseif (not getMasteryRankNext(MASTERY, getPlayerMasteryRank(cid))) then
                selfSay("You're already at the last level of this mastery.", cid)
            elseif (not getPlayerMasteryRankTokensPayed(cid, MASTERY, getPlayerMasteryRank(cid))) then
                selfSay("Before to this dungeon you need pay the necessary tokens.", cid)
            elseif (#getMasteryDungeonsFree(MASTERY) == 0) then
                selfSay("There is no dungeon avaiable, please try again later.", cid)
            elseif (not checkPlayerPokemon(cid)) then
                selfSay(string.format(__L(cid, "You can only enter the dungeon carrying Pokemon with Mastery %s types and without Ditto!"), MASTERY_NAME), cid)
            else
                local diff =  (getPlayerLastDungeonDate(cid) + 24 * 60 * 60) - os.time()
                if (diff > 0) then
                    selfSay(string.format(__L(cid, "You must wait %s minutes to do a dungeon again."), math.ceil(diff / 60)), cid)
                elseif (not doMasteryDungeonStart(MASTERY, getMasteryRankNext(MASTERY, getPlayerMasteryRank(cid)), cid)) then
                    selfSay("You can't do the dungeon right now, please try again later.", cid)
                end
            end

            talkState[talkUser] = TALKSTATE_NONE
            return true

        elseif (talkState[talkUser] == TALKSTATE_LEAVE) then
            doPlayerMasteryReset(cid, MASTERY)
            doPlayerEraseDefeatedNpc(cid, ASSISTANT)
            selfSay("It's done!", cid)
            talkState[talkUser] = TALKSTATE_NONE

        else
            selfSay("What?", cid)
            talkState[talkUser] = TALKSTATE_NONE
        end

    else
        selfSay("Ok...", cid)
        talkState[talkUser] = TALKSTATE_NONE
    end
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
