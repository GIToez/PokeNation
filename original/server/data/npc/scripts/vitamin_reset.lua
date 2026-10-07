local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local lastMove = {}

local TALKSTATE_CONFIRM = 1

local REQUIRED_COUNT = 1
local REQUIRED_ITEMID = 6500

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)    npcHandler:onCreatureSay(cid, type, msg)      end
function onThink() npcHandler:onThink() end


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'reset') or msgcontains(msg, 'vitamin') or msgcontains(msg, 'resetar') or msgcontains(msg, 'vitamina')) then
        selfSay(string.format(__L(cid, "I can reset your Pokemon vitamin's. Do you want that? This will cost %s soul coin."), REQUIRED_COUNT), cid)
        talkState[talkUser] = TALKSTATE_CONFIRM

    elseif (talkState[talkUser] == TALKSTATE_CONFIRM) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
                selfSay("You can not do it while you have a Pokemon out of the ball.", cid)
                return true
            end

            local ball = getPlayerBall(cid)
            if (not isItem(ball)) then
                selfSay("Please, first put a poke ball in your inventory slot.", cid)

            elseif (getBallTotalVitamins(ball.uid) == 0) then
                selfSay("Your Pokemon didn't have any vitamin.", cid)

            elseif (getPlayerItemCount(cid, REQUIRED_ITEMID) < REQUIRED_COUNT) then
                selfSay(string.format(__L(cid, "You need at least %sx Soul Coin to do it."), REQUIRED_COUNT), cid)

            else
                doPlayerRemoveItem(cid, REQUIRED_ITEMID, REQUIRED_COUNT)
                Vitamin.doResetBall(ball)
                selfSay(__L(cid, "Done!"), cid)
                doDatalogCoinUse(os.time(), getPlayerGUID(cid), 10, REQUIRED_COUNT) -- Datalog Soul Coin vitamin use
            end

        else
            selfSay("Ok.", cid)
        end

        talkState[talkUser] = 0
        lastMove[talkUser] = nil

    else
        selfSay("I can {reset} your Pokemon vitamins.", cid)
    end
	return true
end)

npcHandler:addModule(FocusModule:new())
