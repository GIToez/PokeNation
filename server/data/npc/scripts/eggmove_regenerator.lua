local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local TALKSTATE_REGENERATE = 1
local TALKSTATE_RESULT = 2
local TALKSTATE_ACCEPT_CONFIRM = 3
local TALKSTATE_REJECT_CONFIRM = 4

local REGENERATE_COST = 25000
local TIME_BETWEEN_TRIES = 23 * 60 * 60

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    -- Checks: ball enabled, cooldown elapsed / Confirm
    -- Shows the possible Egg Moves / Confirm
    -- Generates one from the list and updates the ball's list; if no moves are left, disables the ball / Confirm
    -- If accepted, updates the Egg Move and disables the ball / Finish

    if (msgcontains(msg, 'regenerate')) then
        local ball = getPlayerBall(cid)
        if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
            selfSay("You can not do it while you have a Pokemon out of the ball.", cid)

        elseif (not isItem(ball)) then
            selfSay("Please, put the poke ball at the ball slot!", cid)

        elseif (not isBallPokemonFromEgg(ball.uid)) then
            selfSay("This is not a Pokemon from egg!", cid)

        elseif (not getBallReceivedEggMove(ball.uid)) then
            selfSay("Your Pokemon does not have an Egg Move!", cid)

        elseif (not getBallEggMoveRegenerateEnabled(ball.uid)) then
            selfSay("Your Pokemon is not able to regenerate an Egg Move! You must first use an Egg Move Capsule on him.", cid)

        elseif (((getBallLastEggMoveRegenerationTry(ball.uid) + TIME_BETWEEN_TRIES) - getCurrentTimeInSeconds()) > 0) then
            selfSay(string.format(__L(cid, "Your Pokemon already tried to regenerate an Egg Move recently, he must wait %s before try again."), table.concat(string.timediff(((getBallLastEggMoveRegenerationTry(ball.uid) +
                    TIME_BETWEEN_TRIES) - getCurrentTimeInSeconds()), cid))), cid)

        else
            local eggMoves = table.deepcopy(getPokemonEggMoves(getBallPokemonName(ball.uid)))
            local regeneratedEggMoves = getBallRegeneratedEggMoves(ball.uid)

            for _, v in pairs(regeneratedEggMoves) do
                table.removeValue(eggMoves, v, false)
            end
            table.removeValue(eggMoves, getBallEggMove(ball.uid), false)

            if (#eggMoves <= 0) then -- Bug fixing - already regenerated all possible egg moves, its starting again
                eggMoves = table.deepcopy(getPokemonEggMoves(getBallPokemonName(ball.uid)))
            end

            local eggMovesMessage = {}
            for k, v in pairs(eggMoves) do
                eggMovesMessage[#eggMovesMessage + 1] = v
                eggMovesMessage[#eggMovesMessage + 1] = ', '
            end
            eggMovesMessage[#eggMovesMessage] = nil
            eggMovesMessage = table.concat(eggMovesMessage)

            selfSay(string.format(__L(cid, "Your %s is able to regenerate one of these Egg Moves: %s. This will cost you %s dollars, do you want to continue?"), getBallPokemonName(ball.uid), eggMovesMessage, REGENERATE_COST), cid)
        end

        talkState[talkUser] = TALKSTATE_REGENERATE

    elseif (talkState[talkUser] == TALKSTATE_REGENERATE) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            local ball = getPlayerBall(cid)
            if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
                selfSay("You can not do it while you have a Pokemon out of the ball.", cid)

            elseif (not isItem(ball)) then
                selfSay("Please, put the poke ball at the ball slot!", cid)

            elseif (not isBallPokemonFromEgg(ball.uid)) then
                selfSay("This is not a Pokemon from egg!", cid)

            elseif (not getBallReceivedEggMove(ball.uid)) then
                selfSay("Your Pokemon does not have an Egg Move!", cid)

            elseif (not getBallEggMoveRegenerateEnabled(ball.uid)) then
                selfSay("Your Pokemon is not able to regenerate an Egg Move! You must first use an Egg Move Capsule on him.", cid)

            elseif (((getBallLastEggMoveRegenerationTry(ball.uid) + TIME_BETWEEN_TRIES) - getCurrentTimeInSeconds()) > 0) then
                selfSay(string.format(__L(cid, "Your Pokemon already tried to regenerate an Egg Move recently, he must wait %s before try again."), table.concat(string.timediff(((getBallLastEggMoveRegenerationTry(ball.uid) +
                        TIME_BETWEEN_TRIES) - getCurrentTimeInSeconds()), cid))), cid)

            elseif (not doPlayerRemoveMoney(cid, REGENERATE_COST)) then
                selfSay("Sorry, you don't have enough money.", cid)

            else
                local eggMove = PokemonEgg.doRegenerateEggMove(ball.uid)
                if (eggMove) then
                    setBallLastEggMoveRegenerationTry(ball.uid, getCurrentTimeInSeconds())
                    selfSay(string.format(__L(cid, "... ... ...! Your %s regenerated the egg move %s! Do you want to {ACCEPT} or {REJECT} this Egg Move? Remember, you will not be able to regenerate this Egg Move again!"), getBallPokemonName(ball.uid), eggMove), cid)
                    talkState[talkUser] = TALKSTATE_RESULT

                else
                    selfSay("Your Pokemon can't receive an egg move!", cid)
                    talkState[talkUser] = nil
                end
            end

        else
            selfSay("Sure!", cid)
            talkState[talkUser] = nil
        end

    elseif (talkState[talkUser] == TALKSTATE_RESULT) then
        local ball = getPlayerBall(cid)
        if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
            selfSay("You can not do it while you have a Pokemon out of the ball.", cid)

        elseif (not isItem(ball)) then
            selfSay("Please, put the poke ball at the ball slot!", cid)

        elseif (not isBallPokemonFromEgg(ball.uid)) then
            selfSay("This is not a Pokemon from egg!", cid)

        elseif (not getBallLastEggMoveRegenerated(ball.uid)) then
            selfSay("Your Pokemon doesn't have regenerated an Egg Move!", cid)

        elseif (msgcontains(msg, 'accept') or msgcontains(msg, 'aceitar')) then
            selfSay(string.format(__L(cid, "Do you really want to accept the regenerated Egg Move %s? If you accept, your Pokemon will forget your current Egg Move and will learn the Egg Move %s. You can only start the process again if you use another Egg Move Capsule."), getBallLastEggMoveRegenerated(ball.uid), getBallLastEggMoveRegenerated(ball.uid)), cid)
            talkState[talkUser] = TALKSTATE_ACCEPT_CONFIRM

        elseif (msgcontains(msg, 'reject') or msgcontains(msg, 'rejeitar')) then
            selfSay(string.format(__L(cid, "Do you really want to reject the regenerated Egg Move %s? If you reject, your Pokemon will will not be able to learn the Egg Move %s. You can only start the process again if you use another Egg Move Capsule."), getBallLastEggMoveRegenerated(ball.uid), getBallLastEggMoveRegenerated(ball.uid)), cid)
            talkState[talkUser] = TALKSTATE_REJECT_CONFIRM

        else
            selfSay("I din't understand. Do you want to {ACCEPT} or {REJECT} the regenerated Egg Move?", cid)
        end

    elseif (talkState[talkUser] == TALKSTATE_ACCEPT_CONFIRM) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            local ball = getPlayerBall(cid)
            if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
                selfSay("You can not do it while you have a Pokemon out of the ball.", cid)

            elseif (not isItem(ball)) then
                selfSay("Please, put the poke ball at the ball slot!", cid)

            elseif (not isBallPokemonFromEgg(ball.uid)) then
                selfSay("This is not a Pokemon from egg!", cid)

            elseif (not getBallLastEggMoveRegenerated(ball.uid)) then
                selfSay("Your Pokemon doesn't have regenerated an Egg Move!", cid)

            else
                local eggMove = getBallLastEggMoveRegenerated(ball.uid)
                setBallEggMove(ball.uid, PokemonEgg.getBallAvailableSlot(ball.uid), eggMove)
                doBallUpdateDescription(ball.uid)
                doPlayerUpdatePokemonMoves(cid, ball.uid)
                setBallEggMoveRegenerateEnabled(ball.uid, false)
                setBallEggMovesRegenerated(ball.uid, nil) -- Reseting

                selfSay(string.format(__L(cid, "Your %s received the egg move %s!"), getBallPokemonName(ball.uid), eggMove), cid)
                doDatalogEggMoveRegenerate(os.time(), getPlayerGUID(cid), getBallPokemonName(ball.uid), getBallPokemonLevel(ball.uid), getBallPokemonExtraPoints(ball.uid), eggMove)

                talkState[talkUser] = nil
            end

        else
            selfSay("Ok, so do you want to {ACCEPT} or {REJECT} the regenerated Egg Move?", cid)
            talkState[talkUser] = TALKSTATE_RESULT
        end

    elseif (talkState[talkUser] == TALKSTATE_REJECT_CONFIRM) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            local ball = getPlayerBall(cid)
            if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
                selfSay("You can not do it while you have a Pokemon out of the ball.", cid)

            elseif (not isItem(ball)) then
                selfSay("Please, put the poke ball at the ball slot!", cid)

            elseif (not isBallPokemonFromEgg(ball.uid)) then
                selfSay("This is not a Pokemon from egg!", cid)

            elseif (not getBallLastEggMoveRegenerated(ball.uid)) then
                selfSay("Your Pokemon doesn't have regenerated an Egg Move!", cid)

            else
                selfSay("Alright! It's done! You can try to regenerate another Egg Move for this Pokemon tomorrow.", cid)
                talkState[talkUser] = nil
            end

        else
            selfSay("Ok, so do you want to {ACCEPT} or {REJECT} the regenerated Egg Move?", cid)
            talkState[talkUser] = TALKSTATE_RESULT
        end

    else
        selfSay("Here you can {regenerate} an Egg move from your Pokemon!", cid)
    end

    return true
end)

npcHandler:addModule(FocusModule:new())
