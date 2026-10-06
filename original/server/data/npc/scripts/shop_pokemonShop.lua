setCreatureIcon(getNpcId(), CREATURE_ICONS.TRADE)

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local TALKSTATE_SELLING = 1
local TALKSTATE_SELL_ALL = 2
local cashIncreasedPerLevel = 5
local lastPokemon = {}
--[[
local prices = {
	["bulbasaur"] = 3000,
	["ivysaur"] = 5500,
	["venusaur"] = 8000,
	["charmander"] = 3000,
	["charmeleon"] = 5500,
	["charizard"] = 8000,
	["squirtle"] = 3000,
	["wartortle"] = 5500,
	["blastoise"] = 8000,
	["caterpie"] = 0,
	["metapod"] = 250,
	["butterfree"] = 1500,
	["weedle"] = 0,
	["kakuna"] = 250,
	["beedrill"] = 1500,
	["pidgey"] = 50,
	["pidgeotto"] = 1200,
	["pidgeot"] = 5500,
	["rattata"] = 0,
	["raticate"] = 850,
	["spearow"] = 90,
	["fearow"] = 4000,
	["ekans"] = 200,
	["arbok"] = 2000,
	["pikachu"] = 4000,
	["raichu"] = 6000,
	["sandshrew"] = 850,
	["sandslash"] = 5000,
	["nidorana"] = 250,
	["nidorina"] = 1500,
	["nidoqueen"] = 6000,
	["nidorano"] = 250,
	["nidorino"] = 1500,
	["nidoking"] = 6000,
	["clefairy"] = 3000,
	["clefable"] = 5000,
	["vulpix"] = 1200,
	["ninetales"] = 7500,
	["jigglypuff"] = 1500,
	["wigglytuff"] = 3500,
	["zubat"] = 50,
	["golbat"] = 1200,
	["oddish"] = 100,
	["gloom"] = 1500,
	["vileplume"] = 5000,
	["paras"] = 50,
	["parasect"] = 1800,
	["venonat"] = 1000,
	["venomoth"] = 3000,
	["diglett"] = 150,
	["dugtrio"] = 3000,
	["meowth"] = 800,
	["persian"] = 3000,
	["psyduck"] = 1000,
	["golduck"] = 6000,
	["mankey"] = 600,
	["primeape"] = 3000,
	["growlithe"] = 2000,
	["arcanine"] = 10000,
	["poliwag"] = 110,
	["poliwhirl"] = 2200,
	["poliwrath"] = 7000,
	["abra"] = 800,
	["kadabra"] = 6000,
	["alakazam"] = 12000,
	["machop"] = 850,
	["machoke"] = 3500,
	["machamp"] = 8000,
	["bellsprout"] = 100,
	["weepinbell"] = 1500,
	["victreebel"] = 5000,
	["tentacool"] = 350,
	["tentacruel"] = 7000,
	["geodude"] = 500,
	["graveler"] = 1600,
	["golem"] = 8000,
	["ponyta"] = 850,
	["rapidash"] = 4000,
	["slowpoke"] = 850,
	["slowbro"] = 4000,
	["magnemite"] = 600,
	["magneton"] = 2500,
	["farfetchd"] = 6000,
	["doduo"] = 650,
	["dodrio"] = 3000,
	["seel"] = 1500,
	["dewgong"] = 5500,
	["grimer"] = 600,
	["muk"] = 1800,
	["shellder"] = 600,
	["cloyster"] = 4000,
	["gastly"] = 2000,
	["haunter"] = 6000,
	["gengar"] = 12000,
	["onix"] = 3500,
	["drowzee"] = 1200,
	["hypno"] = 6500,
	["krabby"] = 135,
	["kingler"] = 2500,
	["voltorb"] = 450,
	["electrode"] = 2000,
	["exeggcute"] = 320,
	["exeggutor"] = 3500,
	["cubone"] = 1000,
	["marowak"] = 5000,
	["hitmonlee"] = 10000,
	["hitmonchan"] = 10000,
	["lickitung"] = 5000,
	["koffing"] = 500,
	["weezing"] = 2500,
	["rhyhorn"] = 1100,
	["rhydon"] = 4000,
	["chansey"] = 8000,
	["tangela"] = 3000,
	["kangaskhan"] = 8000,
	["horsea"] = 200,
	["seadra"] = 2500,
	["goldeen"] = 100,
	["seaking"] = 1500,
	["staryu"] = 600,
	["starmie"] = 3000,
	["mr. mime"] = 5000,
	["scyther"] = 8000,
	["jynx"] = 8000,
	["electabuzz"] = 10000,
	["magmar"] = 10000,
	["pinsir"] = 4000,
	["tauros"] = 2500,
	["magikarp"] = 0,
	["gyarados"] = 8000,
	["lapras"] = 8000,
	["ditto"] = 12000,
	["eevee"] = 8000,
	["vaporeon"] = 9000,
	["jolteon"] = 9000,
	["flareon"] = 9000,
	["porygon"] = 12000,
	["omanyte"] = 10000,
	["omastar"] = 20000,
	["kabuto"] = 10000,
	["kabutops"] = 20000,
	["aerodactyl"] = 15000,
	["snorlax"] = 10000,
	["articuno"] = 100000,
	["zapdos"] = 100000,
	["moltres"] = 100000,
	["dratini"] = 1000,
	["dragonair"] = 7000,
	["dragonite"] = 12000,
	["mewtwo"] = 100000,
	["mew"] = 100000
}

local balls = {
	balls["poke"].charged, balls["poke"].discharged,
	balls["great"].charged, balls["great"].discharged,
	balls["ultra"].charged, balls["ultra"].discharged,
	balls["safari"].charged, balls["safari"].discharged,
	balls["blue"].charged, balls["blue"].discharged,
	balls["red"].charged, balls["red"].discharged,
	balls["yellow"].charged, balls["yellow"].discharged,
	balls["dark"].charged, balls["dark"].discharged,
	balls["azure"].charged, balls["azure"].discharged,
	balls["brown"].charged, balls["brown"].discharged,
	balls["gold"].charged, balls["gold"].discharged,
	balls["green"].charged, balls["green"].discharged,
	balls["pink"].charged, balls["pink"].discharged,
	balls["lilac"].charged, balls["lilac"].discharged,
	balls["silver"].charged, balls["silver"].discharged,
	balls["sandwisp"].charged, balls["sandwisp"].discharged,
	balls["star"].charged, balls["star"].discharged,
	balls["yereblu"].charged, balls["yereblu"].discharged,
	balls["pumpkin"].charged, balls["pumpkin"].discharged,
	balls["skull"].charged, balls["skull"].discharged,
}
]]

local REQUIREMENTS = {}
-- Valencia

-- Pummelo

-- Pinkan

-- Tarroco

-- Hamlin

-- Kumquat

-- Butwal

-- Navel

-- Mandarin North
REQUIREMENTS["Joel Morris"] = function(cid) return getPlayerOrangeArchipelagoAccess(cid) >= 4 end

-- Ascorbia

-- Seven Grapefruit

-- Moro

-- Shamouti

-- Murcott

-- Mandarin South

local function isSellable(ball)
    return getBallTm(ball, 1) == TM_IDS.NONE and getBallTm(ball, 2) == TM_IDS.NONE
end

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	msg = string.lower(msg)
	msg = string.capitalise(msg)

	if (msgcontains(msg, 'pokemon') or msgcontains(msg, 'pokemons')) then
		selfSay("Yes, I can buy your Pokemon, show me your offerts. Say {sell}.", cid)

	elseif (msgcontains(msg, 'sell') or msgcontains(msg, 'vender')) then
		selfSay("Alright, what Pokemon that you want to sell? If you want to sell all your Pokemon, say {all}.", cid)
		talkState[talkUser] = TALKSTATE_SELLING

	elseif (msgcontains(msg, 'yes') or msgcontains(msg, 'sim')) then
        if (isPokemonOnline(cid) or getPlayerMounted(cid) or isEvolving(cid)) then
            selfSay("You can not do it while you have a Pokemon out of the ball.", cid)
            return true
        end

        if (lastPokemon[talkUser] ~= nil) then
            local found = false
            for _, ball in pairs(getPlayerAllBallsWithPokemon(cid)) do
                if (getItemUniqueOwner(ball.uid) == ITEM_UNIQUE_OWNER_NONE and
                        getBallPokemonName(ball.uid) == lastPokemon[talkUser]) then
                    if (not isSellable(ball.uid)) then
                        selfSay("You can not sell a Pokemon that has learned a TM, first remove it!", cid)
                        lastPokemon[talkUser] = nil
                        talkState[talkUser] = nil
                        return true
                    end

                    doPlayerAddMoney(cid, getPokemonPrice(lastPokemon[talkUser]) +
                            (getBallPokemonLevel(ball.uid) * cashIncreasedPerLevel))
					doRemoveItem(ball.uid)
                    doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.SELL_POKEMON, 1)
					selfSay("Oh, thanks!", cid)
                    found = true
					break
                end
            end

            if (not found) then
                selfSay("You haven't this Pokemon!", cid)
            end

            lastPokemon[talkUser] = nil
            talkState[talkUser] = nil

        elseif (talkState[talkUser] == TALKSTATE_SELL_ALL) then
            local amount = 0
            for _, ball in pairs(getPlayerAllBallsWithPokemon(cid)) do
                if (not isSellable(ball.uid)) then
                    selfSay("You can not sell a Pokemon that has learned a TM, first remove it!", cid)

                elseif (getItemUniqueOwner(ball.uid) == ITEM_UNIQUE_OWNER_NONE) then
                    local newAmount = amount + (getPokemonPrice(getBallPokemonName(ball.uid)) +
                            (getBallPokemonLevel(ball.uid) * cashIncreasedPerLevel))

                    if (doRemoveItem(ball.uid)) then
                        amount = newAmount
                        doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.SELL_POKEMON, 1)
                    end
                end
            end

            if (amount > 0) then
                doPlayerAddMoney(cid, amount)
                selfSay("Oh, thanks!", cid)
            end

            talkState[talkUser] = nil

		else
			selfSay("Hum?", cid)
		end

	elseif ((msgcontains(msg, 'no') or msgcontains(msg, 'nao')) and lastPokemon[talkUser] ~= nil) then
		selfSay("Ok... So what Pokemon do you want to sell?", cid)
		talkState[talkUser] = TALKSTATE_SELLING
        lastPokemon[talkUser] = nil

    elseif (talkState[talkUser] == TALKSTATE_SELLING) then
        if (msgcontains(msg, 'all') or msgcontains(msg, 'todos')) then
            local offert = {}
            local amount = 0
            for _, ball in pairs(getPlayerAllBallsWithPokemon(cid)) do
                if (getItemUniqueOwner(ball.uid) == ITEM_UNIQUE_OWNER_NONE) then
                    offert[#offert + 1] = getBallPokemonName(ball.uid)
                    offert[#offert + 1] = " (Level "
                    offert[#offert + 1] = getBallPokemonLevel(ball.uid)
                    offert[#offert + 1] = ") [+"
                    offert[#offert + 1] = getBallPokemonExtraPoints(ball.uid)
                    offert[#offert + 1] = "]"
                    offert[#offert + 1] = ", "
                    amount = amount + (getPokemonPrice(getBallPokemonName(ball.uid)) + (getBallPokemonLevel(ball.uid)
                            * cashIncreasedPerLevel))
                end
            end

            if (amount == 0) then
                selfSay("You aren't carrying any sellable Pokemon!", cid)
                return true
            end

            offert[#offert] = "."
            offert = table.concat(offert)

            selfSay(string.format(__L(cid, "Do you want to sell: %s For %s dollars?"), offert, amount), cid)
            doPlayerPopupFYI(cid, "ATTENTION! If you say YES you will sell all the Pokemon that you're carrying! Be sure before confirm.")
            talkState[talkUser] = TALKSTATE_SELL_ALL
            lastPokemon[talkUser] = nil

        elseif (isPokemonName(msg)) then
            selfSay(string.format(__L(cid, "Do you want to sell your %s for %s dollars plus %s dollars for each level?"), msg, getPokemonPrice(msg), cashIncreasedPerLevel), cid)
		    lastPokemon[talkUser] = msg

        else
            selfSay("If you want to sell a Pokemon, you must say {sell}.", cid)
        end

	else
		selfSay("If you want to sell a Pokemon, you must say {sell}.", cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

npcHandler:setCallback(CALLBACK_GREET, function(cid)
    if (npcHandler:isInRange(cid)) then
        if (REQUIREMENTS[getNpcName()] and not REQUIREMENTS[getNpcName()](cid)) then
            selfSay("You do not have enough access to deal here!", cid)
            return false
        end
	end
	lastPokemon[cid] = nil
    return true
end)
