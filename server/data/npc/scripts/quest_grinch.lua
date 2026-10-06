local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler, CONVERSATION_DEFAULT)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local npcBattle = NpcBattle:new(getNpcName(), 9306, 9706, npcHandler)
npcBattle:setPokemons({"Venusaur", "Charizard", "Blastoise", "Butterfree", "Beedrill", "Pidgeot", "Fearow", "Arbok", "Raichu", "Sandslash", "Nidoqueen", "Nidoking", "Clefable", "Ninetales", "Wigglytuff", "Vileplume", "Parasect", "Venomoth", "Dugtrio", "Primeape", "Arcanine", "Poliwrath", "Alakazam", "Machamp", "Victreebel", "Magneton", "Gengar", "Hitmonlee", "Hitmonchan", "Gyarados", "Ampharos", "Bellossom", "Azumarill", "Umbreon", "Steelix", "Donphan", "Porygon2", "Blissey"})
npcBattle:setOneWin(true)
npcBattle:setDifficulty(100)
npcBattle:setCustomPokemonLevel(function(cid)
    local level = getPlayerLevel(cid) - 5
    if (level > POKEMON_LEVEL_MAX) then
        level = POKEMON_LEVEL_MAX
    elseif (level <= 0) then
        level = 1
    end
    return level
end)
npcBattle:setBattleInterval(10 * 60)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, function(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end

    local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (getCreatureStorage(cid, 8571) == QUEST_STATUS.STARTED) then
        if (msgcontains(msg, 'ajuda') or msgcontains(msg, 'help')) then
            selfSay("I do not need your help, I said get out of here.", cid)

        elseif (msgcontains(msg, 'martha')) then
            selfSay("What? WHAT? May you talked to? As you know ?? ... heyy wait a minute, mm ... nuts strawberry, that smell, MAY? !! What's in your bag? A {cake}?!", cid)

        elseif (msgcontains(msg, 'cake') or msgcontains(msg, 'bolo')) then
            if (getCreatureStorage(cid, 8573) ~= QUEST_STATUS.FINISHED) then
                if (doPlayerRemoveItemByUnique(cid, 25258, 1)) then
                    doCreatureSetStorage(cid, 8573, QUEST_STATUS.FINISHED)
                else
                    selfSay("Where is it?", cid)
                    return true
                end
            end

            selfSay("HUMMM !! He is MAI is not it? Ughh that paiin, my chesstt, no, not again, not grow, not my color ... ... Oohh stopped ... but what else do you have there? {Lemonade}?!", cid)

        elseif (msgcontains(msg, 'lemonade') or msgcontains(msg, 'limonada')) then
            if (getCreatureStorage(cid, 8573) ~= QUEST_STATUS.FINISHED) then -- cake first
                selfSay("???", cid)
                return true
            end

            if (getCreatureStorage(cid, 8574) ~= QUEST_STATUS.FINISHED) then
                if (doPlayerRemoveItemByUnique(cid, 25259, 1)) then
                    doCreatureSetStorage(cid, 8574, QUEST_STATUS.FINISHED)
                else
                    selfSay("Where is it?", cid)
                    return true
                end
            end

            selfSay("Gulp! Gulp! Gulp! Gulp! Very good, ah !! Oh My, little person, the May and a sweet girl, the one who understands me, you seem to be a good person too, WHAT? what I'm saying, no I'm bad, I can not ... nooo, not again, stooopp, is growing, aaaah! {BOOTS}!", cid)

        elseif (msgcontains(msg, 'boot') or msgcontains(msg, 'sock') or msgcontains(msg, 'bota') or msgcontains(msg, 'meia') and getCreatureStorage(cid, 8571) == QUEST_STATUS.STARTED) then
            if (getCreatureStorage(cid, 8574) ~= QUEST_STATUS.FINISHED) then -- lemonade first
                selfSay("???", cid)
                return true
            end

            if (getCreatureStorage(cid, 8575) ~= QUEST_STATUS.FINISHED) then
                if (doPlayerRemoveItemByUnique(cid, 25256, 1)) then
                    doCreatureSetStorage(cid, 8575, QUEST_STATUS.FINISHED)
                else
                    selfSay("Where is it?", cid)
                    return true
                end
            end

            selfSay("Hey little person, give it to me please! Wow, she put up my name here, ah May, how special you are. AHHH! ...... Ufff! Oh no! A {letter}.", cid)

        elseif (msgcontains(msg, 'letter') or msgcontains(msg, 'carta')) then
            if (getCreatureStorage(cid, 8575) ~= QUEST_STATUS.FINISHED) then -- sock first
                selfSay("???", cid)
                return true
            end

            if (getCreatureStorage(cid, 8576) ~= QUEST_STATUS.FINISHED) then
                if (doPlayerRemoveItemByUnique(cid, 25257, 1)) then
                    doCreatureSetStorage(cid, 8576, QUEST_STATUS.FINISHED)
                else
                    selfSay("Where is it?", cid)
                    return true
                end
            end

            selfSay("A letter? She still loves me? You are waiting for me? She never forgot me? You feel lonely? How could I be so stupid, I need to see May ... but I can not, I did terrible things, destroying the home of so many children, I can only make May happy if I prove to her that I am a nice guy. Thank you little person, you helped me, I'm healed, my heart is overjoyed, but I need your help, I will prepare things here, let May that soon I will find it, find me in the Village Natalina, I'll be dressed as Santa Claus why I'm wanted, you know. Thank you little person, you helped me, I'm healed, my heart is overjoyed, but I need your help, I will prepare things here, warn May that soon I will find her, met me in the Christmas Village, I'll be dressed as Santa Claus because I'm wanted, you know.", cid)
            doCreatureSetStorage(cid, 8572, QUEST_STATUS.FINISHED)

        else
            selfSay("You again, GET OUT OF HERE, OUT OUT OUT OUT ...", cid)
        end

        return true
    end

    if (msgcontains(msg, 'fear') or msgcontains(msg, 'medo')) then
        selfSay("... ... ... WHAT YOU WANT? {LEAVE}!?", cid)

    elseif (msgcontains(msg, 'out') or msgcontains(msg, 'leave') or msgcontains(msg, 'sair')) then
        selfSay("You can only leave if you beat me in a {duel}.", cid)

    elseif (msgcontains(msg, 'letter') or msgcontains(msg,'carta')) then
        selfSay("Give me this letter was not for you to read it ... ... Oh! She was so beautiful, no no, I can not have a relapse ... ahhhhhh that painn, ahhh my chestt, no, can not be, not grow, any {help}.", cid)

    elseif (msgcontains(msg, 'ajuda') or msgcontains(msg, 'help')) then
        selfSay("Do not {see} this, get out of here.", cid)

    elseif (msgcontains(msg, 'see') or msgcontains(msg, 'ver') or msgcontains(msg, 'veja')) then
        local destionation = {x = 3918, y = 390, z = 7}
        doTeleportThing(cid, destionation)
        doSendMagicEffect(destionation, EFFECT_TELEPORT_DOWN)

        if (not doComparePositions(getNpcPos(), {x = 3930, y = 327, z = 10})) then
            doRemoveCreature(getNpcId())
        end

    elseif (msgcontains(msg, 'battle') or msgcontains(msg, 'fight') or msgcontains(msg, 'duel') or msgcontains(msg, 'batalha') or msgcontains(msg, 'duelar')) then
        talkState[talkUser] =  npcBattle:doTalkStart(getNpcId(), cid)

    elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        talkState[talkUser] =  npcBattle:doTalkEnd(getNpcId(), cid, talkState[talkUser])
    else
        selfSay("Ok..", cid)
    end
    return true
end)
npcHandler:addModule(FocusModule:new())

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (not npcHandler:isInRange(cid)) then
        return false
    end

    if (getCreatureStorage(cid, 8571) == QUEST_STATUS.STARTED) then
        selfSay("You again, GET OUT OF HERE, OUT OUT OUT OUT ...", cid)
        npcHandler:addFocus(cid)
        return false
    end

    if (getPlayerDefeatedNPC(cid, 9706)) then
        selfSay("You'll be stuck here forever. Hahahaha! Ouch, the {letter}.", cid)
        npcHandler:addFocus(cid)
        return false
    end

    if (getCreatureStorage(cid, 8642) ~= QUEST_STATUS.FINISHED) then -- This player dont read the letter yet
        selfSay("???", cid)
        return false
    end

    return true
end)