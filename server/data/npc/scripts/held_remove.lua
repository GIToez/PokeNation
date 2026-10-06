local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local lastMove = {}

local TALKSTATE_CONFIRM = 1

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)    npcHandler:onCreatureSay(cid, type, msg)      end
function onThink() npcHandler:onThink() end


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (msgcontains(msg, 'remove') or msgcontains(msg, 'held') or msgcontains(msg, 'remover')) then
        selfSay("I can {remove} your Pokemon held! Do you want that? {Your Pokemon Held Item level will be reseted if you do that.}", cid)
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

            elseif (not getBallHeld(ball.uid)) then
                selfSay("Your Pokemon didn't have any Held.", cid)

            else
                doPlayerSafeAddItem(cid, PokemonHeldItem.getHeldItemId(getBallHeld(ball.uid)), 1, true)
                PokemonHeldItem.doResetBall(ball, cid)
                selfSay(__L(cid, "Done!"), cid)
            end

        else
            selfSay("Ok.", cid)
        end

        talkState[talkUser] = 0
        lastMove[talkUser] = nil

    else
        selfSay("I can {remove} your Pokemon Held.", cid)
    end
	return true
end)

npcHandler:addModule(FocusModule:new())
