local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local lastMove = {}

local TALKSTATE_TYPE_MOVE = 1
local TALKSTATE_CONFIRM = 2

local REQUIRED_PALETTE = 2
local PALETTE_ITEMID = 17791

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)    npcHandler:onCreatureSay(cid, type, msg)      end
function onThink() npcHandler:onThink() end


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'reset') or msgcontains(msg, 'sketch') or msgcontains(msg, 'resetar')) then
        selfSay(string.format(__L(cid, "Yes, I can reset your Smeargle Sketch's. You must give me %sx Artist's Palette per move. Please, type the move name that you want to reset."), REQUIRED_PALETTE), cid)
        talkState[talkUser] = TALKSTATE_TYPE_MOVE

    elseif (talkState[talkUser] == TALKSTATE_TYPE_MOVE) then
        local ball = getPlayerBall(cid)
        if (not isItem(ball)) then
            selfSay("Please, first put a poke ball in your inventory slot.", cid)
            talkState[talkUser] = 0

        else
            msg = string.capitalise(msg)

            lastMove[talkUser] = msg
            talkState[talkUser] = TALKSTATE_CONFIRM
            selfSay(string.format(__L(cid, "So, you really want to reset your Smeargle %s? This will cost you %sx Artist's Pallete."), msg, REQUIRED_PALETTE), cid)
            return true
        end

    elseif (talkState[talkUser] == TALKSTATE_CONFIRM) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            local ball = getPlayerBall(cid)
            if (not isItem(ball)) then
                selfSay("Please, first put a poke ball in your inventory slot.", cid)

            elseif (#getBallSketchMoves(ball.uid) == 0) then
                selfSay("Your Pokemon didn't copied any move.", cid)

            elseif (getPlayerItemCount(cid, PALETTE_ITEMID) < REQUIRED_PALETTE) then
                selfSay(string.format(__L(cid, "You need at least %sx Artist's Pallete to do it."), REQUIRED_PALETTE), cid)

            else
                local sketchs = getBallSketchMoves(ball.uid)

                if (not table.find(sketchs, lastMove[talkUser])) then
                    selfSay("Your Pokemon didn't copied this move.", cid)

                else
                    sketchs[table.find(sketchs, lastMove[talkUser])] = "Sketch"
                    setBallSketchMoves(ball.uid, sketchs)
                    doPlayerUpdatePokemonMoves(cid, ball.uid)
                    doPlayerRemoveItem(cid, PALETTE_ITEMID, REQUIRED_PALETTE)
                    selfSay(__L(cid, "Done!"), cid)
                end
            end

        else
            selfSay("Ok buddy.", cid)
        end

        talkState[talkUser] = 0
        lastMove[talkUser] = nil

    else
        selfSay("Here you can {reset} Sketch moves that you your Smeargle copies!", cid)
    end
	return true
end)
--[[
npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (npcHandler:isInRange(cid)) then
        if (getPlayerOrangeArchipelagoAccess(cid) < 4) then
            selfSay("You do not have enough access to deal here!", cid)
            return false
        end
    end
    return true
end)
]]
npcHandler:addModule(FocusModule:new())
