local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

--
setCreatureIcon(getNpcId(), CREATURE_ICONS.QUEST)

local battleNpcName = "Flanagan"
local flanaganBattle = NpcBattle:new(battleNpcName, 9287, 9687, npcHandler)
flanaganBattle:setPokemons({"Poliwag"})
flanaganBattle:setOneWin(true)
flanaganBattle:setDifficulty(5)
flanaganBattle:setRequired(function(cid) return getCreatureStorage(cid, 8492) == QUEST_STATUS.STARTED end)
flanaganBattle:setOnEnd(
    function(cid)
        flanaganBattle:setPlayerLastBattleTimeWithNpc(cid, 0) -- Prevent waiting time if loss

        if (not isPokemonOnline(cid)) then
            for _, ball in pairs(getPlayerAllBallsWithPokemon(cid)) do
                doBallHeal(cid, ball) -- Heal the Pokemon if the player lose
            end
        end
    end
)

local function doExitPlayer(cid)
    if (isPokemonOnline(cid)) then -- Try to call Pokemon back
        doPlayerUseBallOnSlot(cid)
    end

    if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
        selfSay("You can not do it while you have a Pokemon out of the ball.", cid)
        return
    end

    for _, item in pairs(getPlayerAllBallsWithPokemon(cid)) do
        doRemoveItem(item.uid)
    end

    local destination = {x = 3337, y = 812, z = 6}
    doTeleportThing(cid, destination)
    doSendMagicEffect(destination, EFFECT_TELEPORT)
    doPlayerSetTown(cid, 32) -- Pallet
end

local TALKSTATE_SKIP = 400

local function doHandleSkip(cid, msg)
    if (msgcontains(msg, 'skip') or msgcontains(msg, 'pular')) then
        npcHandler.talkState[cid] = TALKSTATE_SKIP
        selfSay("You really want to skip the tutorial?", cid)
        return true

    elseif (npcHandler.talkState[cid] == TALKSTATE_SKIP) then
        if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            selfSay("Here you go!", cid)
            doExitPlayer(cid)
        else
            selfSay("Ok, so let's move on.", cid)
        end

        npcHandler.talkState[cid] = nil
        return true
    end

    return false
end

local NPCS = {}

-- First NPC
NPCS["Biff"] = function(cid, type, msg)
    if (msgcontains(msg, 'continue') or msgcontains(msg, 'continuar')) then
        if (getPlayerUsingOtClient(cid)) then
            selfSay("Okay, that's a start. All quest NPCs will be indicated by a balloon with a exclamation mark (!). Then we go to our first mission. Remember that you can {SKIP} this tutorial whenever you want. Now, let's start your first mission? Just say {YES}.", cid)
        else
            selfSay("Okay, that's a start. Then we go to our first mission. Remember that if you can {SKIP} this tutorial whenever you want. Now, let's start your first mission? Just say {YES}.", cid)
        end

    elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        selfSay("Go through that door and \"Use\" to open it. You can do it using Shift + Click to open the context menu for interaction and click on \"Use\", or you can select the option to use the \"Classic Control\" menu to simply use the right mouse button. Once you open it, speak with the second NPC, Flanagan.", cid)
        doPlayerSendTip(cid, TIP_IDS.OPEN_DOOR)

    else
        selfSay("Some dialogs will contain blue words, you just need to repeat them to {CONTINUE} the dialogue.", cid)
    end
end

-- Daycare Helper
NPCS["Carlton"] = function(cid, type, msg)
    if (msgcontains(msg, 'daycare')) then
        npcHandler:sayStory(string.createStory("The Pokemon Daycare is a place where you can leave your Pokemon to gain experience without it being in your current team. This place was designed for trainers who do not have much time or want to train other Pokemon besides the six that carries. You can leave two Pokemon in the Daycare what gives a second use for the system. If a trainer leave a female and a male Pokemon at the Daycare, which are compatible to relate, there is the possibility of generating a Pokemon Egg. If you generate an Egg, you must make he born. Once the process is finished you will have a very good Pokemon in your hands as well. To learn more, look for other players and also the Help or Wiki Chat channels. Good luck trainer!"), cid)

    else
        selfSay("You know the {POKEMON DAYCARE}?", cid)
    end
end

-- Pokémon Helper
NPCS["Cletis"] = function(cid, type, msg)
    if (msgcontains(msg, 'tm')) then
        npcHandler:sayStory(string.createStory("The TM (Technical Machine) are able to teach your Pokemon a new move that he did not learn normally. All you need to do is find a TM like this one besides me and use it at the Pokemon Poke Ball. After that, you will choose a move to replace by the TM move. Again remembering that the PSoul follows in fact the official data of Pokemon universe, and therefore this system also has some rules."), cid)

    elseif (msgcontains(msg, 'vitamin') or msgcontains(msg, 'vitamina')) then
        npcHandler:sayStory(string.createStory("Vitamins are designed to increase the Stats of your Pokemon. The Stats are: HP, Attack, Defense, Special Attack, Special Defese and Speed. Each Pokemon has a limit to Stat that can be modified by vitamins. Each Pokemon has a limit of 10 total vitamins and a 3 per vitamin. To learn more, visit the Help and Wiki Chat channels."), cid)

    else
        selfSay("You know the {TMS} or {VITAMINS}?", cid)
    end
end

-- Berry Helper
NPCS["Tracy"] = function(cid, type, msg)
    if (msgcontains(msg, 'berries')) then
        npcHandler:sayStory(string.createStory("Berries are plants that any trainer can have at home. They are of different species and with different effects. There is a cooldown between each use, even in tournament battles! To plant a Berry, you need some tools like these behind me and use on a fertile land, normally found in homes or rental locations. You find these spaces by PSoul world. The tools are also found within shop NPCs in the cities."), cid)

    else
        selfSay("Looking to know about {BERRIES}?", cid)
    end
end

-- Ranger Helper
NPCS["Gray"] = function(cid, type, msg)
    if (msgcontains(msg, 'frontier')) then
        npcHandler:sayStory(string.createStory("The Frontier Island gives trainers the opportunity to test their ability as a Pokemon Master with some challenges. It can be accessed directly from the Trading Area, its a place to visit with friends. There you can earn Frontier Tokens, which opens the possibility to purchase some unique items at the island."), cid)

    elseif (msgcontains(msg, 'ranger')) then
        npcHandler:sayStory(string.createStory("The Ranger Club is a place for trainers that seeks adventures. At the Ranger Club you will have the opportunity to advance on Ranks and be a successful Ranger. There you will have several missions that give you points to move up in ranks. Each mission will give you rewards and the possibility of facing a Pokemon Boss. What you are waiting for? Each city has a representative of the Ranger Club!"), cid)

    else
        selfSay("You want to hear about the {FRONTIER ISLAND} or the {RANGER CLUB}?", cid)
    end
end

-- Soul Coin Trader
NPCS["Jimi"] = function(cid, type, msg)
    if (msgcontains(msg, 'soul')) then
        npcHandler:sayStory(string.createStory("These are the game virtual currency. With them you can make your Premium Account account to have access to various locations on the map and also the full use of your Pokemon. They are not required to play, but if you want a total experience for the game be sure to have them. You can buy directly from other players or by donating to the project through the official site. It is a symbolic way to keep PSoul online and your enjoyment. There are several uses for it, so if you want to see more detail visit the Wiki Chat or Game Help channels."), cid)

    else
        selfSay("Do you know what is a {SOUL COIN}?", cid)
    end
end

-- End
NPCS["Oak's Assistant Brenny"] = function(cid, type, msg)
    if (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        npcHandler:sayStory(string.createStory("Now I will take you to the laboratory of one of the greatest Pokemon researchers who have trod this land. There he will instruct you on how to do different things and you also have the possibility to receive your first Pokemon. Remembering that you are very vulnerable without a Pokemon, so perform the QUEST to begin your journey on the right foot. When {READY} take you to his lab, it will not take long. Just close your eyes..."), cid)

    elseif (msgcontains(msg, 'ready') or msgcontains(msg, 'pronto')) then
        selfSay("There you go! Good luck!", cid)
        doExitPlayer(cid)

    else
        selfSay("It's fine.", cid)
    end
end
--

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

    if (doHandleSkip(cid, msg)) then
        return true
    end

    local npcName = getNpcName()

    if (npcName == battleNpcName and getCreatureStorage(cid, 8492) == QUEST_STATUS.STARTED and
            not getPlayerDefeatedNPC(cid, battleNpcName)) then
        if (msgcontains(msg, 'battle') or msgcontains(msg, 'batalha')) then
            npcHandler.talkState[talkUser] =  flanaganBattle:doTalkStart(getNpcId(), cid)

        elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
            npcHandler.talkState[talkUser] =  flanaganBattle:doTalkEnd(getNpcId(), cid,
                npcHandler.talkState[talkUser])

        else
            selfSay("Do you mean {BATTLE}?", cid)
        end

        return true
    end

    if (getNpcQuests(npcName)) then
        npcHandler.talkState[talkUser] = doQuestTalk(cid, npcName, msg, npcHandler.talkState[talkUser])
        return true
    end

    if (NPCS[npcName]) then
        NPCS[npcName](cid, type, msg)
    end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
