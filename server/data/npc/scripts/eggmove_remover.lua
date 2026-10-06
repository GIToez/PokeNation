local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local tmSlotChange = {}
local tmMoveChange = {}
local lastPlate = {}

local TALKSTATE_CONFIRM = 1
local TALKSTATE_MOVE_CHANGE = 2
local TALKSTATE_CONFIRM_CHANGE = 3
local TALKSTATE_GENERATE_ASK = 4
local TALKSTATE_TYPE_PLATE = 5
local TALKSTATE_GENERATE_CONFIRM = 6
local TALKSTATE_CONFIRM_PRE = 7
local TALKSTATE_RECOVER_ASK = 8
local TALKSTATE_RECOVER_ASK_FINAL = 9
local TALKSTATE_FIX_ASK = 10
local TALKSTATE_FIX_TYPE_PLATE = 11
local TALKSTATE_FIX_GENERATE_CONFIRM = 12

local TIME_BETWEEN_TRIES = 23 * 60 * 60
local RECOVER_COST = 100000

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end

function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end

function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink() npcHandler:onThink() end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if (not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (talkState[talkUser] == TALKSTATE_MOVE_CHANGE) then
        local ball = getPlayerBall(cid)
        if (not isItem(ball) or not getBallPokemonName(ball.uid)) then
            selfSay("Please, first put a poke ball in your inventory slot.", cid)
            talkState[talkUser] = 0

        else
            local moves = getPokemonSkills(getBallPokemonName(ball.uid), ball.uid)
            local moveSlot = table.find(moves, msg)
            if (not moveSlot or not moves[moveSlot]) then
                selfSay("Your Pokemon doesn't learned such move, please type again. Remember to type it name exactly!", cid)
                return true
            end

            if (not isString(getBallPokemonName(ball.uid)) or not getBallEggMove(ball.uid)) then
                selfSay("Sorry, not possible.", cid)
                return true
            end

            selfSay(string.format(__L(cid, "You really want to move the Egg Move %s from your %s to replace the move %s?"), getBallEggMove(ball.uid), getBallPokemonName(ball.uid), moves[moveSlot]), cid)

            talkState[talkUser] = TALKSTATE_CONFIRM_CHANGE
            tmMoveChange[talkUser] = moves[moveSlot]
            tmSlotChange[talkUser] = moveSlot
        end

    elseif (msgcontains(msg, 'remove') or msgcontains(msg, 'remover')) then
        selfSay("So, do you really want to remove your Pokemon Egg Move?", cid)
        talkState[talkUser] = TALKSTATE_CONFIRM_PRE

    elseif (msgcontains(msg, 'change') or msgcontains(msg, 'alterar') or msgcontains(msg, 'mover')) then
        selfSay("Yes, I can change the move that your Pokemon forgot to learn a Egg move. What is your Pokemon move that you want to replace with that Egg Move? Type the name exactly!", cid)
        talkState[talkUser] = TALKSTATE_MOVE_CHANGE

    elseif (msgcontains(msg, 'generate') or msgcontains(msg, 'gerar')) then
        selfSay("Here you can also generate an Egg Move to an old Pokemon from egg that you have. Do you want to do that?", cid)
        talkState[talkUser] = TALKSTATE_GENERATE_ASK

    elseif (msgcontains(msg, 'recover') or msgcontains(msg, 'recuperar')) then
        selfSay("Yes, you can recover an Egg Move that your Pokemon forgot. Do you want to do that?", cid)
        talkState[talkUser] = TALKSTATE_RECOVER_ASK

    elseif (msgcontains(msg, 'fix') or msgcontains(msg, 'corrigir')) then
        selfSay("Yes, I can fix an Egg Move lost due to PSoul update changes. In this case, you will generate a new Egg Move if your Pokemon can't use the currently generated. Do you want to do that?", cid)
        talkState[talkUser] = TALKSTATE_FIX_ASK

    elseif (talkState[talkUser] == TALKSTATE_RECOVER_ASK) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            selfSay(string.format(__L(cid, "This will cost you %s dollars, you are sure?"), RECOVER_COST), cid)
            talkState[talkUser] = TALKSTATE_RECOVER_ASK_FINAL

        else
            selfSay("Sure!", cid)
            talkState[talkUser] = nil
        end

    elseif (talkState[talkUser] == TALKSTATE_RECOVER_ASK_FINAL) then
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

            elseif (getPlayerMoney(cid) < RECOVER_COST) then
                selfSay("Sorry, you don't have enough money.", cid)

            elseif (getBallEggMoveSlot(ball.uid)) then
                selfSay("Your Pokemon already have an Egg Move!", cid)

            else
                doPlayerRemoveMoney(cid, RECOVER_COST)

                local eggMove = getBallEggMove(ball.uid)
                setBallEggMove(ball.uid, 2, eggMove)

                doBallUpdateDescription(ball.uid)
                doPlayerUpdatePokemonMoves(cid, ball.uid)

                selfSay(string.format(__L(cid, "Your %s recovered the egg move %s!"), getBallPokemonName(ball.uid), eggMove), cid)
            end

        else
            selfSay("Sure!", cid)
        end

        talkState[talkUser] = nil
        lastPlate[cid] = nil

    elseif (talkState[talkUser] == TALKSTATE_GENERATE_ASK) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            selfSay("Ya! First, put your Pokemon ball at the right ball slot. Ok, if you want to use a Plate to influence the generated Egg Move, type the Plate name. If you do not want to use a Plate, just type {none}.", cid)
            talkState[talkUser] = TALKSTATE_TYPE_PLATE

        else
            selfSay("Ok, maybe later.", cid)
            talkState[talkUser] = nil
        end

    elseif (talkState[talkUser] == TALKSTATE_FIX_ASK) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            selfSay("Ya! First, put your Pokemon ball at the right ball slot. Ok, if you want to use a Plate to influence the generated Egg Move, type the Plate name. If you do not want to use a Plate, just type {none}.", cid)
            talkState[talkUser] = TALKSTATE_FIX_TYPE_PLATE

        else
            selfSay("Ok, maybe later.", cid)
            talkState[talkUser] = nil
        end

    elseif (talkState[talkUser] == TALKSTATE_TYPE_PLATE) then
        local msg = string.lower(msg)
        if (getPlateItemIdByName(msg)) then
            lastPlate[cid] = getPlateItemIdByName(msg)
        end

        if (lastPlate[cid]) then
            selfSay(string.format(__L(cid, "Ok, be carefully now! DO YOU REALLY WANT TO TRY TO GENERATE AN EGG MOVE TO YOUR POKEMON USING A {%s} PLATE?"), string.upper(PLATE_NAME_BY_ITEMID[lastPlate[cid]])), cid)
        else
            selfSay("Ok, be carefully now! DO YOU REALLY WANT TO TRY TO GENERATE AN EGG MOVE TO YOUR POKEMON USING {NO} PLATE?", cid)
        end

        talkState[talkUser] = TALKSTATE_GENERATE_CONFIRM

    elseif (talkState[talkUser] == TALKSTATE_FIX_TYPE_PLATE) then
        local msg = string.lower(msg)
        if (getPlateItemIdByName(msg)) then
            lastPlate[cid] = getPlateItemIdByName(msg)
        end

        if (lastPlate[cid]) then
            selfSay(string.format(__L(cid, "Ok, be carefully now! DO YOU REALLY WANT TO TRY TO GENERATE AN EGG MOVE TO YOUR POKEMON USING A {%s} PLATE?"), string.upper(PLATE_NAME_BY_ITEMID[lastPlate[cid]])), cid)
        else
            selfSay("Ok, be carefully now! DO YOU REALLY WANT TO TRY TO GENERATE AN EGG MOVE TO YOUR POKEMON USING {NO} PLATE?", cid)
        end

        talkState[talkUser] = TALKSTATE_FIX_GENERATE_CONFIRM

    elseif (talkState[talkUser] == TALKSTATE_GENERATE_CONFIRM) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            local ball = getPlayerBall(cid)
            if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
                selfSay("You can not do it while you have a Pokemon out of the ball.", cid)

            elseif (not isItem(ball)) then
                selfSay("Please, put the poke ball at the ball slot!", cid)

            elseif (not isBallPokemonFromEgg(ball.uid)) then
                selfSay("This is not a Pokemon from egg!", cid)

            elseif (getBallReceivedEggMove(ball.uid)) then
                selfSay("Your Pokemon already received an Egg Move!", cid)

            elseif (lastPlate[cid] and getPlayerItemCount(cid, lastPlate[cid]) <= 0) then
                selfSay("You don't have the required plate!", cid)

                --[[elseif (((getBallLastEggMoveGenerationTry(ball.uid) + TIME_BETWEEN_TRIES) - getCurrentTimeInSeconds()) > 0) then
                    selfSay(string.format(__L(cid, "Your Pokemon already tried to generate an Egg Move recently, he must wait %s before try again."), table.concat(string.timediff(((getBallLastEggMoveGenerationTry(ball.uid) +
                            TIME_BETWEEN_TRIES) - getCurrentTimeInSeconds()), cid))), cid)

                elseif (getRandom(1, 150) <= 20) then]]
            else
                local eggMove = PokemonEgg.doGenerateEggMove(ball.uid, getBallPokemonName(ball.uid),
                    TYPE_BY_PLATE_ITEMID[lastPlate[cid]], true)
                if (eggMove) then
                    doPlayerRemoveItem(cid, lastPlate[cid], 1)
                    doBallUpdateDescription(ball.uid)
                    doPlayerUpdatePokemonMoves(cid, ball.uid)

                    selfSay(string.format(__L(cid, "Your %s received the egg move %s!"), getBallPokemonName(ball.uid), eggMove), cid)

                    doDatalogEggMoveGenerate(os.time(), getPlayerGUID(cid), getBallPokemonName(ball.uid),
                        getBallPokemonLevel(ball.uid), getBallPokemonExtraPoints(ball.uid), eggMove, false)

                else
                    selfSay("Your Pokemon can't receive an egg move!", cid)
                end
                --[[else
                    setBallLastEggMoveGenerationTry(ball.uid, getCurrentTimeInSeconds())
                    selfSay("Argh! Your Pokemon didn't generated an Egg Move now! Please try again later.", cid)]]
            end

        else
            selfSay("Sure!", cid)
        end

        talkState[talkUser] = nil
        lastPlate[cid] = nil

    elseif (talkState[talkUser] == TALKSTATE_FIX_GENERATE_CONFIRM) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            local ball = getPlayerBall(cid)
            if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
                selfSay("You can not do it while you have a Pokemon out of the ball.", cid)

            elseif (not isItem(ball)) then
                selfSay("Please, put the poke ball at the ball slot!", cid)

            elseif (not isBallPokemonFromEgg(ball.uid)) then
                selfSay("This is not a Pokemon from egg!", cid)

            elseif (lastPlate[cid] and getPlayerItemCount(cid, lastPlate[cid]) <= 0) then
                selfSay("You don't have the required plate!", cid)

            elseif (not getBallReceivedEggMove(ball.uid)) then
                selfSay("Your Pokemon doesn't have an Egg Move!", cid)

            elseif (not table.find(getPokemonDefaultSkills(getBallPokemonName(ball.uid)), getBallEggMove(ball.uid))) then
                selfSay("Your Pokemon is not eligible to be fixed.", cid)

            else
                local eggMove = PokemonEgg.doGenerateEggMove(ball.uid, getBallPokemonName(ball.uid),
                    TYPE_BY_PLATE_ITEMID[lastPlate[cid]], true)
                if (eggMove) then
                    doPlayerRemoveItem(cid, lastPlate[cid], 1)
                    doBallUpdateDescription(ball.uid)
                    doPlayerUpdatePokemonMoves(cid, ball.uid)

                    selfSay(string.format(__L(cid, "Your %s received the egg move %s!"), getBallPokemonName(ball.uid), eggMove), cid)

                    doDatalogEggMoveGenerate(os.time(), getPlayerGUID(cid), getBallPokemonName(ball.uid),
                        getBallPokemonLevel(ball.uid), getBallPokemonExtraPoints(ball.uid), eggMove, false)

                else
                    selfSay("Your Pokemon can't receive an egg move!", cid)
                end
            end

        else
            selfSay("Sure!", cid)
        end

        talkState[talkUser] = nil
        lastPlate[cid] = nil

    elseif (talkState[talkUser] == TALKSTATE_CONFIRM_PRE) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            selfSay("YOU REALLY WANT TO REMOVE YOUR POKEMON EGG MOVE? HE WILL NEVER BE ABLE TO LEARN ANOTHER EGG MOVE!", cid)
            doPlayerPopupFYI(cid, "YOU REALLY WANT TO REMOVE YOUR POKEMON EGG MOVE? HE WILL NEVER BE ABLE TO LEARN ANOTHER EGG MOVE!")
            talkState[talkUser] = TALKSTATE_CONFIRM
        else
            selfSay("Fine.", cid)
            talkState[talkUser] = nil
        end

    elseif (talkState[talkUser] == TALKSTATE_CONFIRM) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            local ball = getPlayerBall(cid)
            if (not isItem(ball)) then
                selfSay("Please, first put a poke ball in your inventory slot.", cid)

            else
                if (getItemUniqueOwner(ball.uid) ~= ITEM_UNIQUE_OWNER_NONE and
                        getItemUniqueOwner(ball.uid) ~= getPlayerGUID(cid)) then
                    selfSay("You aren't owner of this item.", cid)

                elseif (not getBallEggMoveSlot(ball.uid)) then
                    selfSay("Your Pokemon doesn't have any Egg Move.", cid)

                else
                    selfSay(__L(cid, "Done!"), cid)
                    setBallEggMove(ball.uid, nil, nil, true)
                    doBallUpdateDescription(ball.uid)
                    doPlayerUpdatePokemonMoves(cid, ball.uid)
                end
            end

        else
            selfSay("Ok buddy.", cid)
        end

        talkState[talkUser] = 0

    elseif (talkState[talkUser] == TALKSTATE_CONFIRM_CHANGE) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            local ball = getPlayerBall(cid)
            if (not isItem(ball)) then
                selfSay("Please, first put a poke ball in your inventory slot.", cid)

            else
                if (not getBallEggMoveSlot(ball.uid)) then
                    selfSay("Your Pokemon doesn't have any Egg Move.", cid)

                elseif (not PokemonEgg.canReplaceMove(getPokemonSkills(getBallPokemonName(ball.uid),
                    ball.uid)[tmSlotChange[talkUser]], tmSlotChange[talkUser], ball.uid)) then
                    selfSay("You cannot replace this move!", cid)

                else
                    selfSay(__L(cid, "Done!"), cid)

                    local eggMove = getBallEggMove(ball.uid)
                    setBallEggMove(ball.uid, nil, nil, true) -- Reset first
                    setBallEggMove(ball.uid, tmSlotChange[talkUser], eggMove)
                    doBallUpdateDescription(ball.uid)
                    doPlayerUpdatePokemonMoves(cid, ball.uid)
                end
            end

        else
            selfSay("Ok buddy.", cid)
        end

        talkState[talkUser] = 0
        tmSlotChange[talkUser] = nil
        tmMoveChange[talkUser] = nil

    else
        selfSay("Here you can {remove}, {change} and {recover} Egg move from your Pokemon!", cid)
    end
    return true
end)

npcHandler:addModule(FocusModule:new())
