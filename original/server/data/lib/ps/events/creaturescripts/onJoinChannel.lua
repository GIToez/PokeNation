local function chooseMaxPokemon(cid, maxPokemon)
	if (#getPlayerAllBallsWithPokemon(cid) < maxPokemon) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You have less than %s Pokemon with you!"), maxPokemon))
	else
		setPlayerLastMaxPokemon(cid, maxPokemon)
		doPlayerSendChannelsDialog(cid, {CHANNEL_1X1_PLAYER, CHANNEL_2X2_PLAYER, CHANNEL_3X3_PLAYER, CHANNEL_4X4_PLAYER, CHANNEL_5X5_PLAYER, CHANNEL_6X6_PLAYER})
	end
end

local function chooseMaxMembers(cid, maxMembers)
	local lastOpponent = getPlayerLastOpponent(cid)
	if (not isPlayer(lastOpponent)) then
		doPlayerSendCancel(cid, "Your opponent seems to be offline.")
	else
        setPlayerLastMaxMembers(cid, maxMembers)
        doPlayerSendChannelsDialog(cid, {CHANNEL_DUEL_WITHOUT_BET, CHANNEL_DUEL_WITH_BET})
	end
end

local function chooseBet(cid, bet)
    local lastOpponent = getPlayerLastOpponent(cid)
    if (not isPlayer(lastOpponent)) then
        doPlayerSendCancel(cid, "Your opponent seems to be offline.")
    elseif (bet) then
        doPlayerWriteItem(cid, getPlayerSlotItem(cid, PLAYER_SLOT_DUEL).uid)
    else
        doPartyDuelCreate(cid, getPlayerLastMaxMembers(cid), getPlayerLastMaxPokemon(cid), 0)
        doPartyDuelInvite(cid, lastOpponent)
    end
end
--[[
local CHANNELS = {}
CHANNELS[CHANNEL_1_POKEMON] = function(cid)
    chooseMaxPokemon(cid, 1)
end

CHANNELS[CHANNEL_2_POKEMON] = function(cid)
    chooseMaxPokemon(cid, 2)
end

CHANNELS[CHANNEL_3_POKEMON] = function(cid)
    chooseMaxPokemon(cid, 3)
end

CHANNELS[CHANNEL_4_POKEMON] = function(cid)
    chooseMaxPokemon(cid, 4)
end

CHANNELS[CHANNEL_5_POKEMON] = function(cid)
    chooseMaxPokemon(cid, 5)
end

CHANNELS[CHANNEL_6_POKEMON] = function(cid)
    chooseMaxPokemon(cid, 6)
end

CHANNELS[CHANNEL_1X1_PLAYER] = function(cid)
    chooseMaxMembers(cid, 1)
end

CHANNELS[CHANNEL_2X2_PLAYER] = function(cid)
    chooseMaxMembers(cid, 2)
end

CHANNELS[CHANNEL_3X3_PLAYER] = function(cid)
    chooseMaxMembers(cid, 3)
end

CHANNELS[CHANNEL_4X4_PLAYER] = function(cid)
    chooseMaxMembers(cid, 4)
end

CHANNELS[CHANNEL_5X5_PLAYER] = function(cid)
    chooseMaxMembers(cid, 5)
end

CHANNELS[CHANNEL_6X6_PLAYER] = function(cid)
    chooseMaxMembers(cid, 6)
end
]]
function onJoinChannel(cid, channel, users)
    if (channel == CHANNEL_HELP) then
        addEvent(function(cid)
            if (isCreature(cid)) then
                doPlayerSendChannelMessage(cid, "", "Procurando ajuda? Acesse nosso site: http://www.pokenordic.com/blogCategories/1-tutorials / Looking for help? Access our site: http://www.pokenordic.com/blogCategories/1-tutorials", TALKTYPE_CHANNEL_RN, channel)
                doPlayerSendChannelMessage(cid, "", "Digite /commands para visualizar os comandos. / Type /commands to view the commands.", TALKTYPE_CHANNEL_RN, channel)
                doPlayerSendChannelMessage(cid, "", "Antes de perguntar, pesquise no canal Wiki Chat! / Before asking, take a look at the Wiki Chat!", TALKTYPE_CHANNEL_RN, channel)
                --
                if (not isTutor(cid)) then
                    local msg = {}
                    msg[1] = "Online tutors: "

                    for guid, _ in pairs(ONLINE_TUTORS) do
                        msg[#msg +1] = getPlayerNameByGUID(guid, false, false)
                        msg[#msg +1] = ", "
                    end

                    if (#msg == 1) then
                        msg[2] = "None."
                    else
                        msg[#msg] = "."
                    end

                    doPlayerSendChannelMessage(cid, "", table.concat(msg), TALKTYPE_CHANNEL_RN, channel)
                end
            end
        end, 1000, cid)
        return true
    end

    if (channel >= CHANNEL_1_POKEMON and channel <= CHANNEL_PACIFIDLOG and
            (channel < CHANNEL_PVP_ARENA_FIRST or channel > CHANNEL_PVP_ARENA_LAST)) then
        if (channel == CHANNEL_1_POKEMON) then
            chooseMaxPokemon(cid, 1)
        elseif (channel == CHANNEL_2_POKEMON) then
            chooseMaxPokemon(cid, 2)
        elseif (channel == CHANNEL_3_POKEMON) then
            chooseMaxPokemon(cid, 3)
        elseif (channel == CHANNEL_4_POKEMON) then
            chooseMaxPokemon(cid, 4)
        elseif (channel == CHANNEL_5_POKEMON) then
            chooseMaxPokemon(cid, 5)
        elseif (channel == CHANNEL_6_POKEMON) then
            chooseMaxPokemon(cid, 6)
        elseif (channel == CHANNEL_1X1_PLAYER) then
            chooseMaxMembers(cid, 1)
        elseif (channel == CHANNEL_2X2_PLAYER) then
            chooseMaxMembers(cid, 2)
        elseif (channel == CHANNEL_3X3_PLAYER) then
            chooseMaxMembers(cid, 3)
        elseif (channel == CHANNEL_4X4_PLAYER) then
            chooseMaxMembers(cid, 4)
        elseif (channel == CHANNEL_5X5_PLAYER) then
            chooseMaxMembers(cid, 5)
        elseif (channel == CHANNEL_6X6_PLAYER) then
            chooseMaxMembers(cid, 6)
        elseif (channel == CHANNEL_HIGHSCORES) then
            doPlayerSendChannelsDialog(cid, {CHANNEL_LEVEL, CHANNEL_DUEL_WIN, CHANNEL_DUEL_LOSS, CHANNEL_BATTLE_WIN,
                CHANNEL_BATTLE_LOSS, CHANNEL_HEADBUTTING, CHANNEL_CATCHING, CHANNEL_FISHING,
                CHANNEL_HIGHSCORETOURNAMENT, CHANNEL_FRONTIER_ISLAND, CHANNEL_ACHIEVEMENTS, CHANNEL_RANGER_CLUB})
        elseif (channel == CHANNEL_DUEL_WIN) then
            doPlayerPopupFYI(cid, getHighscoreString(PLAYER_SKILL_DUEL_WIN))
        elseif (channel == CHANNEL_DUEL_LOSS) then
            doPlayerPopupFYI(cid, getHighscoreString(PLAYER_SKILL_DUEL_LOSS))
        elseif (channel == CHANNEL_BATTLE_WIN) then
            doPlayerPopupFYI(cid, getHighscoreString(PLAYER_SKILL_BATTLE_WIN))
        elseif (channel == CHANNEL_BATTLE_LOSS) then
            doPlayerPopupFYI(cid, getHighscoreString(PLAYER_SKILL_BATTLE_LOSS))
        elseif (channel == CHANNEL_HEADBUTTING) then
            doPlayerPopupFYI(cid, getHighscoreString(PLAYER_SKILL_HEADBUTTING))
        elseif (channel == CHANNEL_CATCHING) then
            doPlayerPopupFYI(cid, getHighscoreString(PLAYER_SKILL_CATCHING))
        elseif (channel == CHANNEL_FISHING) then
            doPlayerPopupFYI(cid, getHighscoreString(PLAYER_SKILL_FISHING))
		elseif (channel == CHANNEL_HIGHSCORETOURNAMENT) then
            doPlayerPopupFYI(cid, getTournamentHighscoreText())
        elseif (channel == CHANNEL_LEVEL) then
            doPlayerPopupFYI(cid, getHighscoreString(SKILL__LEVEL))
        elseif (channel == CHANNEL_CAUGHTS) then
            doPlayerSendChannelsDialog(cid, {CHANNEL_TOTALCAUGHTS,CHANNEL_CAUGHT_SPECIES,CHANNEL_BULBASAUR,CHANNEL_IVYSAUR,CHANNEL_VENUSAUR,CHANNEL_CHARMANDER,CHANNEL_CHARMELEON,CHANNEL_CHARIZARD,CHANNEL_SQUIRTLE,CHANNEL_WARTORTLE,CHANNEL_BLASTOISE,CHANNEL_CATERPIE,CHANNEL_METAPOD,CHANNEL_BUTTERFREE,CHANNEL_WEEDLE,CHANNEL_KAKUNA,CHANNEL_BEEDRILL,CHANNEL_PIDGEY,CHANNEL_PIDGEOTTO,CHANNEL_PIDGEOT,CHANNEL_RATTATA,CHANNEL_RATICATE,CHANNEL_SPEAROW,CHANNEL_FEAROW,CHANNEL_EKANS,CHANNEL_ARBOK,CHANNEL_PIKACHU,CHANNEL_RAICHU,CHANNEL_SANDSHREW,CHANNEL_SANDSLASH,CHANNEL_NIDORANA,CHANNEL_NIDORINA,CHANNEL_NIDOQUEEN,CHANNEL_NIDORANO,CHANNEL_NIDORINO,CHANNEL_NIDOKING,CHANNEL_CLEFAIRY,CHANNEL_CLEFABLE,CHANNEL_VULPIX,CHANNEL_NINETALES,CHANNEL_JIGGLYPUFF,CHANNEL_WIGGLYTUFF,CHANNEL_ZUBAT,CHANNEL_GOLBAT,CHANNEL_ODDISH,CHANNEL_GLOOM,CHANNEL_VILEPLUME,CHANNEL_PARAS,CHANNEL_PARASECT,CHANNEL_VENONAT,CHANNEL_VENOMOTH,CHANNEL_DIGLETT,CHANNEL_DUGTRIO,CHANNEL_MEOWTH,CHANNEL_PERSIAN,CHANNEL_PSYDUCK,CHANNEL_GOLDUCK,CHANNEL_MANKEY,CHANNEL_PRIMEAPE,CHANNEL_GROWLITHE,CHANNEL_ARCANINE,CHANNEL_POLIWAG,CHANNEL_POLIWHIRL,CHANNEL_POLIWRATH,CHANNEL_ABRA,CHANNEL_KADABRA,CHANNEL_ALAKAZAM,CHANNEL_MACHOP,CHANNEL_MACHOKE,CHANNEL_MACHAMP,CHANNEL_BELLSPROUT,CHANNEL_WEEPINBELL,CHANNEL_VICTREEBEL,CHANNEL_TENTACOOL,CHANNEL_TENTACRUEL,CHANNEL_GEODUDE,CHANNEL_GRAVELER,CHANNEL_GOLEM,CHANNEL_PONYTA,CHANNEL_RAPIDASH,CHANNEL_SLOWPOKE,CHANNEL_SLOWBRO,CHANNEL_MAGNEMITE,CHANNEL_MAGNETON,CHANNEL_FARFETCHD,CHANNEL_DODUO,CHANNEL_DODRIO,CHANNEL_SEEL,CHANNEL_DEWGONG,CHANNEL_GRIMER,CHANNEL_MUK,CHANNEL_SHELLDER,CHANNEL_CLOYSTER,CHANNEL_GASTLY,CHANNEL_HAUNTER,CHANNEL_GENGAR,CHANNEL_ONIX,CHANNEL_DROWZEE,CHANNEL_HYPNO,CHANNEL_KRABBY,CHANNEL_KINGLER,CHANNEL_VOLTORB,CHANNEL_ELECTRODE,CHANNEL_EXEGGCUTE,CHANNEL_EXEGGUTOR,CHANNEL_CUBONE,CHANNEL_MAROWAK,CHANNEL_HITMONLEE,CHANNEL_HITMONCHAN,CHANNEL_LICKITUNG,CHANNEL_KOFFING,CHANNEL_WEEZING,CHANNEL_RHYHORN,CHANNEL_RHYDON,CHANNEL_CHANSEY,CHANNEL_TANGELA,CHANNEL_KANGASKHAN,CHANNEL_HORSEA,CHANNEL_SEADRA,CHANNEL_GOLDEEN,CHANNEL_SEAKING,CHANNEL_STARYU,CHANNEL_STARMIE,CHANNEL_MRMIME,CHANNEL_SCYTHER,CHANNEL_JYNX,CHANNEL_ELECTABUZZ,CHANNEL_MAGMAR,CHANNEL_PINSIR,CHANNEL_TAUROS,CHANNEL_MAGIKARP,CHANNEL_GYARADOS,CHANNEL_LAPRAS,CHANNEL_DITTO,CHANNEL_EEVEE,CHANNEL_VAPOREON,CHANNEL_JOLTEON,CHANNEL_FLAREON,CHANNEL_PORYGON,CHANNEL_OMANYTE,CHANNEL_OMASTAR,CHANNEL_KABUTO,CHANNEL_KABUTOPS,CHANNEL_AERODACTYL,CHANNEL_SNORLAX,CHANNEL_ARTICUNO,CHANNEL_ZAPDOS,CHANNEL_MOLTRES,CHANNEL_DRATINI,CHANNEL_DRAGONAIR,CHANNEL_DRAGONITE,CHANNEL_MEWTWO,CHANNEL_MEW,CHANNEL_CHIKORITA,CHANNEL_BAYLEEF,CHANNEL_MEGANIUM,CHANNEL_CYNDAQUIL,CHANNEL_QUILAVA,CHANNEL_TYPHLOSION,CHANNEL_TOTODILE,CHANNEL_CROCONAW,CHANNEL_FERALIGATR,CHANNEL_SENTRET,CHANNEL_FURRET,CHANNEL_HOOTHOOT,CHANNEL_NOCTOWL,CHANNEL_LEDYBA,CHANNEL_LEDIAN,CHANNEL_SPINARAK,CHANNEL_ARIADOS,CHANNEL_CROBAT,CHANNEL_CHINCHOU,CHANNEL_LANTURN,CHANNEL_PICHU,CHANNEL_CLEFFA,CHANNEL_IGGLYBUFF,CHANNEL_TOGEPI,CHANNEL_TOGETIC,CHANNEL_NATU,CHANNEL_XATU,CHANNEL_MAREEP,CHANNEL_FLAAFFY,CHANNEL_AMPHAROS,CHANNEL_BELLOSSOM,CHANNEL_MARILL,CHANNEL_AZUMARILL,CHANNEL_SUDOWOODO,CHANNEL_POLITOED,CHANNEL_HOPPIP,CHANNEL_SKIPLOOM,CHANNEL_JUMPLUFF,CHANNEL_AIPOM,CHANNEL_SUNKERN,CHANNEL_SUNFLORA,CHANNEL_YANMA,CHANNEL_WOOPER,CHANNEL_QUAGSIRE,CHANNEL_ESPEON,CHANNEL_UMBREON,CHANNEL_MURKROW,CHANNEL_SLOWKING,CHANNEL_MISDREAVUS,CHANNEL_UNOWN,CHANNEL_WOBBUFFET,CHANNEL_GIRAFARIG,CHANNEL_PINECO,CHANNEL_FORRETRESS,CHANNEL_DUNSPARCE,CHANNEL_GLIGAR,CHANNEL_STEELIX,CHANNEL_SNUBBULL,CHANNEL_GRANBULL,CHANNEL_QWILFISH,CHANNEL_SCIZOR,CHANNEL_SHUCKLE,CHANNEL_HERACROSS,CHANNEL_SNEASEL,CHANNEL_TEDDIURSA,CHANNEL_URSARING,CHANNEL_SLUGMA,CHANNEL_MAGCARGO,CHANNEL_SWINUB,CHANNEL_PILOSWINE,CHANNEL_CORSOLA,CHANNEL_REMORAID,CHANNEL_OCTILLERY,CHANNEL_DELIBIRD,CHANNEL_MANTINE,CHANNEL_SKARMORY,CHANNEL_HOUNDOUR,CHANNEL_HOUNDOOM,CHANNEL_KINGDRA,CHANNEL_PHANPY,CHANNEL_DONPHAN,CHANNEL_PORYGON2,CHANNEL_STANTLER,CHANNEL_SMEARGLE,CHANNEL_TYROGUE,CHANNEL_HITMONTOP,CHANNEL_SMOOCHUM,CHANNEL_ELEKID,CHANNEL_MAGBY,CHANNEL_MILTANK,CHANNEL_BLISSEY,CHANNEL_RAIKOU,CHANNEL_ENTEI,CHANNEL_SUICUNE,CHANNEL_LARVITAR,CHANNEL_PUPITAR,CHANNEL_TYRANITAR,CHANNEL_LUGIA,CHANNEL_HOOH,CHANNEL_CELEBI,CHANNEL_LOTAD,CHANNEL_WYNAUT,CHANNEL_SHELGON,CHANNEL_SCEPTILE,CHANNEL_WINGULL,CHANNEL_HUNTAIL,CHANNEL_TAILLOW,CHANNEL_MAWILE,CHANNEL_MIGHTYENA,CHANNEL_FLYGON,CHANNEL_FEEBAS,CHANNEL_METANG,CHANNEL_WURMPLE,CHANNEL_SEALEO,CHANNEL_GULPIN,CHANNEL_SALAMENCE,CHANNEL_LUDICOLO,CHANNEL_CAMERUPT,CHANNEL_SWAMPERT,CHANNEL_BANETTE,CHANNEL_CLAMPERL,CHANNEL_BAGON,CHANNEL_SURSKIT,CHANNEL_SWELLOW,CHANNEL_MEDITITE,CHANNEL_BALTOY,CHANNEL_NUZLEAF,CHANNEL_MUDKIP,CHANNEL_LATIAS,CHANNEL_CRADILY,CHANNEL_SHARPEDO,CHANNEL_REGISTEEL,CHANNEL_CASCOON,CHANNEL_NOSEPASS,CHANNEL_SHROOMISH,CHANNEL_WHISMUR,CHANNEL_AZURILL,CHANNEL_SPOINK,CHANNEL_RAYQUAZA,CHANNEL_EXPLOUD,CHANNEL_CARVANHA,CHANNEL_GARDEVOIR,CHANNEL_SEVIPER,CHANNEL_MARSHTOMP,CHANNEL_METAGROSS,CHANNEL_MAKUHITA,CHANNEL_SABLEYE,CHANNEL_LAIRON,CHANNEL_DUSTOX,CHANNEL_SILCOON,CHANNEL_SLAKING,CHANNEL_DELCATTY,CHANNEL_ARON,CHANNEL_TRAPINCH,CHANNEL_TROPIUS,CHANNEL_LOMBRE,CHANNEL_MASQUERAIN,CHANNEL_WAILMER,CHANNEL_GOREBYSS,CHANNEL_BRELOOM,CHANNEL_JIRACHI,CHANNEL_SHUPPET,CHANNEL_BELDUM,CHANNEL_BLAZIKEN,CHANNEL_LATIOS,CHANNEL_BEAUTIFLY,CHANNEL_CHIMECHO,CHANNEL_LUNATONE,CHANNEL_POOCHYENA,CHANNEL_GRUMPIG,CHANNEL_CACNEA,CHANNEL_SNORUNT,CHANNEL_SHEDINJA,CHANNEL_WALREIN,CHANNEL_NINJASK,CHANNEL_MANECTRIC,CHANNEL_VIGOROTH,CHANNEL_ELECTRIKE,CHANNEL_NUMEL,CHANNEL_CORPHISH,CHANNEL_TREECKO,CHANNEL_LINOONE,CHANNEL_CACTURNE,CHANNEL_COMBUSKEN,CHANNEL_VOLBEAT,CHANNEL_SHIFTRY,CHANNEL_ALTARIA,CHANNEL_ARMALDO,CHANNEL_PELIPPER,CHANNEL_KIRLIA,CHANNEL_ANORITH,CHANNEL_GLALIE,CHANNEL_SOLROCK,CHANNEL_SLAKOTH,CHANNEL_TORCHIC,CHANNEL_ROSELIA,CHANNEL_RELICANTH,CHANNEL_GROUDON,CHANNEL_HARIYAMA,CHANNEL_ZANGOOSE,CHANNEL_SKITTY,CHANNEL_KYOGRE,CHANNEL_REGICE,CHANNEL_WHISCASH,CHANNEL_ZIGZAGOON,CHANNEL_TORKOAL,CHANNEL_LUVDISC,CHANNEL_DEOXYS,CHANNEL_DUSCLOPS,CHANNEL_SPHEAL,CHANNEL_ABSOL,CHANNEL_LOUDRED,CHANNEL_DUSKULL,CHANNEL_GROVYLE,CHANNEL_KECLEON,CHANNEL_CASTFORM,CHANNEL_VIBRAVA,CHANNEL_LILEEP,CHANNEL_CLAYDOL,CHANNEL_SEEDOT,CHANNEL_BARBOACH,CHANNEL_CRAWDAUNT,CHANNEL_AGGRON,CHANNEL_SWALOT,CHANNEL_SWABLU,CHANNEL_MEDICHAM,CHANNEL_MILOTIC,CHANNEL_SPINDA,CHANNEL_REGIROCK,CHANNEL_WAILORD,CHANNEL_ILLUMISE,CHANNEL_MINUN,CHANNEL_PLUSLE,CHANNEL_NINCADA,CHANNEL_RALTS})
        elseif (channel == CHANNEL_TOTALCAUGHTS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT))
        elseif (channel == CHANNEL_CAUGHT_SPECIES) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_INDIVIDUAL))
        elseif (channel == CHANNEL_BULBASAUR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BULBASAUR))
        elseif (channel == CHANNEL_IVYSAUR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_IVYSAUR))
        elseif (channel == CHANNEL_VENUSAUR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_VENUSAUR))
        elseif (channel == CHANNEL_CHARMANDER) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CHARMANDER))
        elseif (channel == CHANNEL_CHARMELEON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CHARMELEON))
        elseif (channel == CHANNEL_CHARIZARD) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CHARIZARD))
        elseif (channel == CHANNEL_SQUIRTLE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SQUIRTLE))
        elseif (channel == CHANNEL_WARTORTLE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WARTORTLE))
        elseif (channel == CHANNEL_BLASTOISE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BLASTOISE))
        elseif (channel == CHANNEL_CATERPIE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CATERPIE))
        elseif (channel == CHANNEL_METAPOD) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_METAPOD))
        elseif (channel == CHANNEL_BUTTERFREE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BUTTERFREE))
        elseif (channel == CHANNEL_WEEDLE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WEEDLE))
        elseif (channel == CHANNEL_KAKUNA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_KAKUNA))
        elseif (channel == CHANNEL_BEEDRILL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BEEDRILL))
        elseif (channel == CHANNEL_PIDGEY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PIDGEY))
        elseif (channel == CHANNEL_PIDGEOTTO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PIDGEOTTO))
        elseif (channel == CHANNEL_PIDGEOT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PIDGEOT))
        elseif (channel == CHANNEL_RATTATA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_RATTATA))
        elseif (channel == CHANNEL_RATICATE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_RATICATE))
        elseif (channel == CHANNEL_SPEAROW) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SPEAROW))
        elseif (channel == CHANNEL_FEAROW) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_FEAROW))
        elseif (channel == CHANNEL_EKANS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_EKANS))
        elseif (channel == CHANNEL_ARBOK) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ARBOK))
        elseif (channel == CHANNEL_PIKACHU) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PIKACHU))
        elseif (channel == CHANNEL_RAICHU) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_RAICHU))
        elseif (channel == CHANNEL_SANDSHREW) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SANDSHREW))
        elseif (channel == CHANNEL_SANDSLASH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SANDSLASH))
        elseif (channel == CHANNEL_NIDORANA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NIDORANA))
        elseif (channel == CHANNEL_NIDORINA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NIDORINA))
        elseif (channel == CHANNEL_NIDOQUEEN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NIDOQUEEN))
        elseif (channel == CHANNEL_NIDORANO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NIDORANO))
        elseif (channel == CHANNEL_NIDORINO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NIDORINO))
        elseif (channel == CHANNEL_NIDOKING) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NIDOKING))
        elseif (channel == CHANNEL_CLEFAIRY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CLEFAIRY))
        elseif (channel == CHANNEL_CLEFABLE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CLEFABLE))
        elseif (channel == CHANNEL_VULPIX) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_VULPIX))
        elseif (channel == CHANNEL_NINETALES) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NINETALES))
        elseif (channel == CHANNEL_JIGGLYPUFF) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_JIGGLYPUFF))
        elseif (channel == CHANNEL_WIGGLYTUFF) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WIGGLYTUFF))
        elseif (channel == CHANNEL_ZUBAT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ZUBAT))
        elseif (channel == CHANNEL_GOLBAT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GOLBAT))
        elseif (channel == CHANNEL_ODDISH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ODDISH))
        elseif (channel == CHANNEL_GLOOM) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GLOOM))
        elseif (channel == CHANNEL_VILEPLUME) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_VILEPLUME))
        elseif (channel == CHANNEL_PARAS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PARAS))
        elseif (channel == CHANNEL_PARASECT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PARASECT))
        elseif (channel == CHANNEL_VENONAT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_VENONAT))
        elseif (channel == CHANNEL_VENOMOTH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_VENOMOTH))
        elseif (channel == CHANNEL_DIGLETT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DIGLETT))
        elseif (channel == CHANNEL_DUGTRIO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DUGTRIO))
        elseif (channel == CHANNEL_MEOWTH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MEOWTH))
        elseif (channel == CHANNEL_PERSIAN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PERSIAN))
        elseif (channel == CHANNEL_PSYDUCK) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PSYDUCK))
        elseif (channel == CHANNEL_GOLDUCK) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GOLDUCK))
        elseif (channel == CHANNEL_MANKEY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MANKEY))
        elseif (channel == CHANNEL_PRIMEAPE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PRIMEAPE))
        elseif (channel == CHANNEL_GROWLITHE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GROWLITHE))
        elseif (channel == CHANNEL_ARCANINE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ARCANINE))
        elseif (channel == CHANNEL_POLIWAG) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_POLIWAG))
        elseif (channel == CHANNEL_POLIWHIRL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_POLIWHIRL))
        elseif (channel == CHANNEL_POLIWRATH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_POLIWRATH))
        elseif (channel == CHANNEL_ABRA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ABRA))
        elseif (channel == CHANNEL_KADABRA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_KADABRA))
        elseif (channel == CHANNEL_ALAKAZAM) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ALAKAZAM))
        elseif (channel == CHANNEL_MACHOP) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MACHOP))
        elseif (channel == CHANNEL_MACHOKE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MACHOKE))
        elseif (channel == CHANNEL_MACHAMP) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MACHAMP))
        elseif (channel == CHANNEL_BELLSPROUT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BELLSPROUT))
        elseif (channel == CHANNEL_WEEPINBELL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WEEPINBELL))
        elseif (channel == CHANNEL_VICTREEBEL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_VICTREEBEL))
        elseif (channel == CHANNEL_TENTACOOL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TENTACOOL))
        elseif (channel == CHANNEL_TENTACRUEL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TENTACRUEL))
        elseif (channel == CHANNEL_GEODUDE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GEODUDE))
        elseif (channel == CHANNEL_GRAVELER) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GRAVELER))
        elseif (channel == CHANNEL_GOLEM) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GOLEM))
        elseif (channel == CHANNEL_PONYTA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PONYTA))
        elseif (channel == CHANNEL_RAPIDASH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_RAPIDASH))
        elseif (channel == CHANNEL_SLOWPOKE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SLOWPOKE))
        elseif (channel == CHANNEL_SLOWBRO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SLOWBRO))
        elseif (channel == CHANNEL_MAGNEMITE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MAGNEMITE))
        elseif (channel == CHANNEL_MAGNETON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MAGNETON))
        elseif (channel == CHANNEL_FARFETCHD) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_FARFETCHD))
        elseif (channel == CHANNEL_DODUO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DODUO))
        elseif (channel == CHANNEL_DODRIO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DODRIO))
        elseif (channel == CHANNEL_SEEL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SEEL))
        elseif (channel == CHANNEL_DEWGONG) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DEWGONG))
        elseif (channel == CHANNEL_GRIMER) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GRIMER))
        elseif (channel == CHANNEL_MUK) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MUK))
        elseif (channel == CHANNEL_SHELLDER) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SHELLDER))
        elseif (channel == CHANNEL_CLOYSTER) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CLOYSTER))
        elseif (channel == CHANNEL_GASTLY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GASTLY))
        elseif (channel == CHANNEL_HAUNTER) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HAUNTER))
        elseif (channel == CHANNEL_GENGAR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GENGAR))
        elseif (channel == CHANNEL_ONIX) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ONIX))
        elseif (channel == CHANNEL_DROWZEE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DROWZEE))
        elseif (channel == CHANNEL_HYPNO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HYPNO))
        elseif (channel == CHANNEL_KRABBY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_KRABBY))
        elseif (channel == CHANNEL_KINGLER) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_KINGLER))
        elseif (channel == CHANNEL_VOLTORB) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_VOLTORB))
        elseif (channel == CHANNEL_ELECTRODE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ELECTRODE))
        elseif (channel == CHANNEL_EXEGGCUTE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_EXEGGCUTE))
        elseif (channel == CHANNEL_EXEGGUTOR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_EXEGGUTOR))
        elseif (channel == CHANNEL_CUBONE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CUBONE))
        elseif (channel == CHANNEL_MAROWAK) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MAROWAK))
        elseif (channel == CHANNEL_HITMONLEE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HITMONLEE))
        elseif (channel == CHANNEL_HITMONCHAN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HITMONCHAN))
        elseif (channel == CHANNEL_LICKITUNG) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LICKITUNG))
        elseif (channel == CHANNEL_KOFFING) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_KOFFING))
        elseif (channel == CHANNEL_WEEZING) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WEEZING))
        elseif (channel == CHANNEL_RHYHORN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_RHYHORN))
        elseif (channel == CHANNEL_RHYDON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_RHYDON))
        elseif (channel == CHANNEL_CHANSEY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CHANSEY))
        elseif (channel == CHANNEL_TANGELA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TANGELA))
        elseif (channel == CHANNEL_KANGASKHAN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_KANGASKHAN))
        elseif (channel == CHANNEL_HORSEA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HORSEA))
        elseif (channel == CHANNEL_SEADRA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SEADRA))
        elseif (channel == CHANNEL_GOLDEEN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GOLDEEN))
        elseif (channel == CHANNEL_SEAKING) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SEAKING))
        elseif (channel == CHANNEL_STARYU) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_STARYU))
        elseif (channel == CHANNEL_STARMIE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_STARMIE))
        elseif (channel == CHANNEL_MRMIME) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MRMIME))
        elseif (channel == CHANNEL_SCYTHER) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SCYTHER))
        elseif (channel == CHANNEL_JYNX) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_JYNX))
        elseif (channel == CHANNEL_ELECTABUZZ) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ELECTABUZZ))
        elseif (channel == CHANNEL_MAGMAR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MAGMAR))
        elseif (channel == CHANNEL_PINSIR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PINSIR))
        elseif (channel == CHANNEL_TAUROS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TAUROS))
        elseif (channel == CHANNEL_MAGIKARP) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MAGIKARP))
        elseif (channel == CHANNEL_GYARADOS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GYARADOS))
        elseif (channel == CHANNEL_LAPRAS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LAPRAS))
        elseif (channel == CHANNEL_DITTO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DITTO))
        elseif (channel == CHANNEL_EEVEE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_EEVEE))
        elseif (channel == CHANNEL_VAPOREON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_VAPOREON))
        elseif (channel == CHANNEL_JOLTEON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_JOLTEON))
        elseif (channel == CHANNEL_FLAREON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_FLAREON))
        elseif (channel == CHANNEL_PORYGON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PORYGON))
        elseif (channel == CHANNEL_OMANYTE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_OMANYTE))
        elseif (channel == CHANNEL_OMASTAR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_OMASTAR))
        elseif (channel == CHANNEL_KABUTO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_KABUTO))
        elseif (channel == CHANNEL_KABUTOPS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_KABUTOPS))
        elseif (channel == CHANNEL_AERODACTYL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_AERODACTYL))
        elseif (channel == CHANNEL_SNORLAX) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SNORLAX))
        elseif (channel == CHANNEL_ARTICUNO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ARTICUNO))
        elseif (channel == CHANNEL_ZAPDOS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ZAPDOS))
        elseif (channel == CHANNEL_MOLTRES) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MOLTRES))
        elseif (channel == CHANNEL_DRATINI) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DRATINI))
        elseif (channel == CHANNEL_DRAGONAIR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DRAGONAIR))
        elseif (channel == CHANNEL_DRAGONITE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DRAGONITE))
        elseif (channel == CHANNEL_MEWTWO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MEWTWO))
        elseif (channel == CHANNEL_MEW) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MEW))
        elseif (channel == CHANNEL_CHIKORITA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CHIKORITA))
        elseif (channel == CHANNEL_BAYLEEF) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BAYLEEF))
        elseif (channel == CHANNEL_MEGANIUM) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MEGANIUM))
        elseif (channel == CHANNEL_CYNDAQUIL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CYNDAQUIL))
        elseif (channel == CHANNEL_QUILAVA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_QUILAVA))
        elseif (channel == CHANNEL_TYPHLOSION) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TYPHLOSION))
        elseif (channel == CHANNEL_TOTODILE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TOTODILE))
        elseif (channel == CHANNEL_CROCONAW) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CROCONAW))
        elseif (channel == CHANNEL_FERALIGATR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_FERALIGATR))
        elseif (channel == CHANNEL_SENTRET) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SENTRET))
        elseif (channel == CHANNEL_FURRET) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_FURRET))
        elseif (channel == CHANNEL_HOOTHOOT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HOOTHOOT))
        elseif (channel == CHANNEL_NOCTOWL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NOCTOWL))
        elseif (channel == CHANNEL_LEDYBA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LEDYBA))
        elseif (channel == CHANNEL_LEDIAN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LEDIAN))
        elseif (channel == CHANNEL_SPINARAK) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SPINARAK))
        elseif (channel == CHANNEL_ARIADOS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ARIADOS))
        elseif (channel == CHANNEL_CROBAT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CROBAT))
        elseif (channel == CHANNEL_CHINCHOU) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CHINCHOU))
        elseif (channel == CHANNEL_LANTURN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LANTURN))
        elseif (channel == CHANNEL_PICHU) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PICHU))
        elseif (channel == CHANNEL_CLEFFA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CLEFFA))
        elseif (channel == CHANNEL_IGGLYBUFF) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_IGGLYBUFF))
        elseif (channel == CHANNEL_TOGEPI) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TOGEPI))
        elseif (channel == CHANNEL_TOGETIC) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TOGETIC))
        elseif (channel == CHANNEL_NATU) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NATU))
        elseif (channel == CHANNEL_XATU) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_XATU))
        elseif (channel == CHANNEL_MAREEP) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MAREEP))
        elseif (channel == CHANNEL_FLAAFFY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_FLAAFFY))
        elseif (channel == CHANNEL_AMPHAROS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_AMPHAROS))
        elseif (channel == CHANNEL_BELLOSSOM) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BELLOSSOM))
        elseif (channel == CHANNEL_MARILL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MARILL))
        elseif (channel == CHANNEL_AZUMARILL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_AZUMARILL))
        elseif (channel == CHANNEL_SUDOWOODO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SUDOWOODO))
        elseif (channel == CHANNEL_POLITOED) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_POLITOED))
        elseif (channel == CHANNEL_HOPPIP) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HOPPIP))
        elseif (channel == CHANNEL_SKIPLOOM) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SKIPLOOM))
        elseif (channel == CHANNEL_JUMPLUFF) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_JUMPLUFF))
        elseif (channel == CHANNEL_AIPOM) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_AIPOM))
        elseif (channel == CHANNEL_SUNKERN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SUNKERN))
        elseif (channel == CHANNEL_SUNFLORA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SUNFLORA))
        elseif (channel == CHANNEL_YANMA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_YANMA))
        elseif (channel == CHANNEL_WOOPER) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WOOPER))
        elseif (channel == CHANNEL_QUAGSIRE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_QUAGSIRE))
        elseif (channel == CHANNEL_ESPEON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ESPEON))
        elseif (channel == CHANNEL_UMBREON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_UMBREON))
        elseif (channel == CHANNEL_MURKROW) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MURKROW))
        elseif (channel == CHANNEL_SLOWKING) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SLOWKING))
        elseif (channel == CHANNEL_MISDREAVUS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MISDREAVUS))
        elseif (channel == CHANNEL_UNOWN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_UNOWN))
        elseif (channel == CHANNEL_WOBBUFFET) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WOBBUFFET))
        elseif (channel == CHANNEL_GIRAFARIG) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GIRAFARIG))
        elseif (channel == CHANNEL_PINECO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PINECO))
        elseif (channel == CHANNEL_FORRETRESS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_FORRETRESS))
        elseif (channel == CHANNEL_DUNSPARCE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DUNSPARCE))
        elseif (channel == CHANNEL_GLIGAR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GLIGAR))
        elseif (channel == CHANNEL_STEELIX) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_STEELIX))
        elseif (channel == CHANNEL_SNUBBULL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SNUBBULL))
        elseif (channel == CHANNEL_GRANBULL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GRANBULL))
        elseif (channel == CHANNEL_QWILFISH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_QWILFISH))
        elseif (channel == CHANNEL_SCIZOR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SCIZOR))
        elseif (channel == CHANNEL_SHUCKLE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SHUCKLE))
        elseif (channel == CHANNEL_HERACROSS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HERACROSS))
        elseif (channel == CHANNEL_SNEASEL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SNEASEL))
        elseif (channel == CHANNEL_TEDDIURSA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TEDDIURSA))
        elseif (channel == CHANNEL_URSARING) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_URSARING))
        elseif (channel == CHANNEL_SLUGMA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SLUGMA))
        elseif (channel == CHANNEL_MAGCARGO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MAGCARGO))
        elseif (channel == CHANNEL_SWINUB) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SWINUB))
        elseif (channel == CHANNEL_PILOSWINE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PILOSWINE))
        elseif (channel == CHANNEL_CORSOLA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CORSOLA))
        elseif (channel == CHANNEL_REMORAID) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_REMORAID))
        elseif (channel == CHANNEL_OCTILLERY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_OCTILLERY))
        elseif (channel == CHANNEL_DELIBIRD) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DELIBIRD))
        elseif (channel == CHANNEL_MANTINE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MANTINE))
        elseif (channel == CHANNEL_SKARMORY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SKARMORY))
        elseif (channel == CHANNEL_HOUNDOUR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HOUNDOUR))
        elseif (channel == CHANNEL_HOUNDOOM) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HOUNDOOM))
        elseif (channel == CHANNEL_KINGDRA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_KINGDRA))
        elseif (channel == CHANNEL_PHANPY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PHANPY))
        elseif (channel == CHANNEL_DONPHAN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DONPHAN))
        elseif (channel == CHANNEL_PORYGON2) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PORYGON2))
        elseif (channel == CHANNEL_STANTLER) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_STANTLER))
        elseif (channel == CHANNEL_SMEARGLE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SMEARGLE))
        elseif (channel == CHANNEL_TYROGUE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TYROGUE))
        elseif (channel == CHANNEL_HITMONTOP) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HITMONTOP))
        elseif (channel == CHANNEL_SMOOCHUM) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SMOOCHUM))
        elseif (channel == CHANNEL_ELEKID) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ELEKID))
        elseif (channel == CHANNEL_MAGBY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MAGBY))
        elseif (channel == CHANNEL_MILTANK) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MILTANK))
        elseif (channel == CHANNEL_BLISSEY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BLISSEY))
        elseif (channel == CHANNEL_RAIKOU) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_RAIKOU))
        elseif (channel == CHANNEL_ENTEI) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ENTEI))
        elseif (channel == CHANNEL_SUICUNE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SUICUNE))
        elseif (channel == CHANNEL_LARVITAR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LARVITAR))
        elseif (channel == CHANNEL_PUPITAR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PUPITAR))
        elseif (channel == CHANNEL_TYRANITAR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TYRANITAR))
        elseif (channel == CHANNEL_LUGIA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LUGIA))
        elseif (channel == CHANNEL_HOOH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HOOH))
        elseif (channel == CHANNEL_CELEBI) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CELEBI))
        elseif (channel == CHANNEL_LOTAD) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LOTAD))
        elseif (channel == CHANNEL_WYNAUT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WYNAUT))
        elseif (channel == CHANNEL_SHELGON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SHELGON))
        elseif (channel == CHANNEL_SCEPTILE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SCEPTILE))
        elseif (channel == CHANNEL_WINGULL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WINGULL))
        elseif (channel == CHANNEL_HUNTAIL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HUNTAIL))
        elseif (channel == CHANNEL_TAILLOW) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TAILLOW))
        elseif (channel == CHANNEL_MAWILE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MAWILE))
        elseif (channel == CHANNEL_MIGHTYENA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MIGHTYENA))
        elseif (channel == CHANNEL_FLYGON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_FLYGON))
        elseif (channel == CHANNEL_FEEBAS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_FEEBAS))
        elseif (channel == CHANNEL_METANG) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_METANG))
        elseif (channel == CHANNEL_WURMPLE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WURMPLE))
        elseif (channel == CHANNEL_SEALEO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SEALEO))
        elseif (channel == CHANNEL_GULPIN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GULPIN))
        elseif (channel == CHANNEL_SALAMENCE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SALAMENCE))
        elseif (channel == CHANNEL_LUDICOLO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LUDICOLO))
        elseif (channel == CHANNEL_CAMERUPT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CAMERUPT))
        elseif (channel == CHANNEL_SWAMPERT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SWAMPERT))
        elseif (channel == CHANNEL_BANETTE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BANETTE))
        elseif (channel == CHANNEL_CLAMPERL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CLAMPERL))
        elseif (channel == CHANNEL_BAGON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BAGON))
        elseif (channel == CHANNEL_SURSKIT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SURSKIT))
        elseif (channel == CHANNEL_SWELLOW) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SWELLOW))
        elseif (channel == CHANNEL_MEDITITE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MEDITITE))
        elseif (channel == CHANNEL_BALTOY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BALTOY))
        elseif (channel == CHANNEL_NUZLEAF) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NUZLEAF))
        elseif (channel == CHANNEL_MUDKIP) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MUDKIP))
        elseif (channel == CHANNEL_LATIAS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LATIAS))
        elseif (channel == CHANNEL_CRADILY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CRADILY))
        elseif (channel == CHANNEL_SHARPEDO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SHARPEDO))
        elseif (channel == CHANNEL_REGISTEEL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_REGISTEEL))
        elseif (channel == CHANNEL_CASCOON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CASCOON))
        elseif (channel == CHANNEL_NOSEPASS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NOSEPASS))
        elseif (channel == CHANNEL_SHROOMISH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SHROOMISH))
        elseif (channel == CHANNEL_WHISMUR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WHISMUR))
        elseif (channel == CHANNEL_AZURILL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_AZURILL))
        elseif (channel == CHANNEL_SPOINK) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SPOINK))
        elseif (channel == CHANNEL_RAYQUAZA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_RAYQUAZA))
        elseif (channel == CHANNEL_EXPLOUD) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_EXPLOUD))
        elseif (channel == CHANNEL_CARVANHA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CARVANHA))
        elseif (channel == CHANNEL_GARDEVOIR) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GARDEVOIR))
        elseif (channel == CHANNEL_SEVIPER) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SEVIPER))
        elseif (channel == CHANNEL_MARSHTOMP) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MARSHTOMP))
        elseif (channel == CHANNEL_METAGROSS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_METAGROSS))
        elseif (channel == CHANNEL_MAKUHITA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MAKUHITA))
        elseif (channel == CHANNEL_SABLEYE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SABLEYE))
        elseif (channel == CHANNEL_LAIRON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LAIRON))
        elseif (channel == CHANNEL_DUSTOX) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DUSTOX))
        elseif (channel == CHANNEL_SILCOON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SILCOON))
        elseif (channel == CHANNEL_SLAKING) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SLAKING))
        elseif (channel == CHANNEL_DELCATTY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DELCATTY))
        elseif (channel == CHANNEL_ARON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ARON))
        elseif (channel == CHANNEL_TRAPINCH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TRAPINCH))
        elseif (channel == CHANNEL_TROPIUS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TROPIUS))
        elseif (channel == CHANNEL_LOMBRE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LOMBRE))
        elseif (channel == CHANNEL_MASQUERAIN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MASQUERAIN))
        elseif (channel == CHANNEL_WAILMER) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WAILMER))
        elseif (channel == CHANNEL_GOREBYSS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GOREBYSS))
        elseif (channel == CHANNEL_BRELOOM) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BRELOOM))
        elseif (channel == CHANNEL_JIRACHI) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_JIRACHI))
        elseif (channel == CHANNEL_SHUPPET) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SHUPPET))
        elseif (channel == CHANNEL_BELDUM) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BELDUM))
        elseif (channel == CHANNEL_BLAZIKEN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BLAZIKEN))
        elseif (channel == CHANNEL_LATIOS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LATIOS))
        elseif (channel == CHANNEL_BEAUTIFLY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BEAUTIFLY))
        elseif (channel == CHANNEL_CHIMECHO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CHIMECHO))
        elseif (channel == CHANNEL_LUNATONE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LUNATONE))
        elseif (channel == CHANNEL_POOCHYENA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_POOCHYENA))
        elseif (channel == CHANNEL_GRUMPIG) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GRUMPIG))
        elseif (channel == CHANNEL_CACNEA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CACNEA))
        elseif (channel == CHANNEL_SNORUNT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SNORUNT))
        elseif (channel == CHANNEL_SHEDINJA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SHEDINJA))
        elseif (channel == CHANNEL_WALREIN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WALREIN))
        elseif (channel == CHANNEL_NINJASK) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NINJASK))
        elseif (channel == CHANNEL_MANECTRIC) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MANECTRIC))
        elseif (channel == CHANNEL_VIGOROTH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_VIGOROTH))
        elseif (channel == CHANNEL_ELECTRIKE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ELECTRIKE))
        elseif (channel == CHANNEL_NUMEL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NUMEL))
        elseif (channel == CHANNEL_CORPHISH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CORPHISH))
        elseif (channel == CHANNEL_TREECKO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TREECKO))
        elseif (channel == CHANNEL_LINOONE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LINOONE))
        elseif (channel == CHANNEL_CACTURNE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CACTURNE))
        elseif (channel == CHANNEL_COMBUSKEN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_COMBUSKEN))
        elseif (channel == CHANNEL_VOLBEAT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_VOLBEAT))
        elseif (channel == CHANNEL_SHIFTRY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SHIFTRY))
        elseif (channel == CHANNEL_ALTARIA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ALTARIA))
        elseif (channel == CHANNEL_ARMALDO) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ARMALDO))
        elseif (channel == CHANNEL_PELIPPER) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PELIPPER))
        elseif (channel == CHANNEL_KIRLIA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_KIRLIA))
        elseif (channel == CHANNEL_ANORITH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ANORITH))
        elseif (channel == CHANNEL_GLALIE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GLALIE))
        elseif (channel == CHANNEL_SOLROCK) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SOLROCK))
        elseif (channel == CHANNEL_SLAKOTH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SLAKOTH))
        elseif (channel == CHANNEL_TORCHIC) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TORCHIC))
        elseif (channel == CHANNEL_ROSELIA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ROSELIA))
        elseif (channel == CHANNEL_RELICANTH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_RELICANTH))
        elseif (channel == CHANNEL_GROUDON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GROUDON))
        elseif (channel == CHANNEL_HARIYAMA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_HARIYAMA))
        elseif (channel == CHANNEL_ZANGOOSE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ZANGOOSE))
        elseif (channel == CHANNEL_SKITTY) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SKITTY))
        elseif (channel == CHANNEL_KYOGRE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_KYOGRE))
        elseif (channel == CHANNEL_REGICE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_REGICE))
        elseif (channel == CHANNEL_WHISCASH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WHISCASH))
        elseif (channel == CHANNEL_ZIGZAGOON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ZIGZAGOON))
        elseif (channel == CHANNEL_TORKOAL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_TORKOAL))
        elseif (channel == CHANNEL_LUVDISC) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LUVDISC))
        elseif (channel == CHANNEL_DEOXYS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DEOXYS))
        elseif (channel == CHANNEL_DUSCLOPS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DUSCLOPS))
        elseif (channel == CHANNEL_SPHEAL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SPHEAL))
        elseif (channel == CHANNEL_ABSOL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ABSOL))
        elseif (channel == CHANNEL_LOUDRED) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LOUDRED))
        elseif (channel == CHANNEL_DUSKULL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_DUSKULL))
        elseif (channel == CHANNEL_GROVYLE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_GROVYLE))
        elseif (channel == CHANNEL_KECLEON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_KECLEON))
        elseif (channel == CHANNEL_CASTFORM) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CASTFORM))
        elseif (channel == CHANNEL_VIBRAVA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_VIBRAVA))
        elseif (channel == CHANNEL_LILEEP) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_LILEEP))
        elseif (channel == CHANNEL_CLAYDOL) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CLAYDOL))
        elseif (channel == CHANNEL_SEEDOT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SEEDOT))
        elseif (channel == CHANNEL_BARBOACH) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_BARBOACH))
        elseif (channel == CHANNEL_CRAWDAUNT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_CRAWDAUNT))
        elseif (channel == CHANNEL_AGGRON) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_AGGRON))
        elseif (channel == CHANNEL_SWALOT) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SWALOT))
        elseif (channel == CHANNEL_SWABLU) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SWABLU))
        elseif (channel == CHANNEL_MEDICHAM) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MEDICHAM))
        elseif (channel == CHANNEL_MILOTIC) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MILOTIC))
        elseif (channel == CHANNEL_SPINDA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_SPINDA))
        elseif (channel == CHANNEL_REGIROCK) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_REGIROCK))
        elseif (channel == CHANNEL_WAILORD) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_WAILORD))
        elseif (channel == CHANNEL_ILLUMISE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_ILLUMISE))
        elseif (channel == CHANNEL_MINUN) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_MINUN))
        elseif (channel == CHANNEL_PLUSLE) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_PLUSLE))
        elseif (channel == CHANNEL_NINCADA) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_NINCADA))
        elseif (channel == CHANNEL_RALTS) then
            doPlayerPopupFYI(cid, getCaughtHighscoreText(HIGHSCORE_ID_CAUGHT_RALTS))
        elseif (channel == CHANNEL_FRONTIER_ISLAND) then
            doPlayerSendChannelsDialog(cid, {CHANNEL_GLADIATOR, CHANNEL_COOPERATIVE_ELITE, CHANNEL_COOPERATIVE_TITAN, CHANNEL_SURVIVE_CHALLENGE, CHANNEL_SURVIVE_HARDCORE, CHANNEL_BATTLE_TOWER_TWENTY, CHANNEL_BATTLE_TOWER_FIFTEEN, CHANNEL_BATTLE_TOWER_TEN, CHANNEL_FRONTIER_ISLAND_GENERAL})
        elseif (channel == CHANNEL_GLADIATOR) then
            doPlayerPopupFYI(cid, getHighscoreText(HIGHSCORE_IDS.GLADIATOR))
        elseif (channel == CHANNEL_COOPERATIVE_ELITE) then
            doPlayerPopupFYI(cid, getHighscoreText(HIGHSCORE_IDS.COOPERATIVE_ELITE))
        elseif (channel == CHANNEL_COOPERATIVE_TITAN) then
            doPlayerPopupFYI(cid, getHighscoreText(HIGHSCORE_IDS.COOPERATIVE_TITAN))
        elseif (channel == CHANNEL_SURVIVE_CHALLENGE) then
            doPlayerPopupFYI(cid, getHighscoreText(HIGHSCORE_IDS.SURVIVE_CHALLENGE))
        elseif (channel == CHANNEL_BATTLE_TOWER_TWENTY) then
            doPlayerPopupFYI(cid, getHighscoreText(HIGHSCORE_IDS.BATTLE_TOWER_TWENTY))
        elseif (channel == CHANNEL_BATTLE_TOWER_FIFTEEN) then
            doPlayerPopupFYI(cid, getHighscoreText(HIGHSCORE_IDS.BATTLE_TOWER_FIFTEEN))
        elseif (channel == CHANNEL_BATTLE_TOWER_TEN) then
            doPlayerPopupFYI(cid, getHighscoreText(HIGHSCORE_IDS.BATTLE_TOWER_TEN))
        elseif (channel == CHANNEL_FRONTIER_ISLAND_GENERAL) then
            doPlayerPopupFYI(cid, getHighscoreText(HIGHSCORE_IDS.FRONTIER_ISLAND))
        elseif (channel == CHANNEL_SURVIVE_HARDCORE) then
            doPlayerPopupFYI(cid, getHighscoreText(HIGHSCORE_IDS.SURVIVE_HARDCORE))
        elseif (channel == CHANNEL_ACHIEVEMENTS) then
            doPlayerPopupFYI(cid, getHighscoreText(HIGHSCORE_IDS.ACHIEVEMENTS))
        elseif (channel == CHANNEL_RANGER_CLUB) then
            doPlayerPopupFYI(cid, getHighscoreText(HIGHSCORE_IDS.RANGER_CLUB))
        elseif (channel == CHANNEL_HOUSE) then
            doCreatureExecuteTalkAction(cid, "/tp house")
        elseif (channel == CHANNEL_GUILD_HOUSE) then
            doCreatureExecuteTalkAction(cid, "/tp guild house")
        elseif (channel == CHANNEL_VIRIDIAN) then
            doCreatureExecuteTalkAction(cid, "/tp viridian")
        elseif (channel == CHANNEL_PEWTER) then
            doCreatureExecuteTalkAction(cid, "/tp pewter")
        elseif (channel == CHANNEL_CERULEAN) then
            doCreatureExecuteTalkAction(cid, "/tp cerulean")
        elseif (channel == CHANNEL_SAFFRON) then
            doCreatureExecuteTalkAction(cid, "/tp saffron")
        elseif (channel == CHANNEL_CELADON) then
            doCreatureExecuteTalkAction(cid, "/tp celadon")
        elseif (channel == CHANNEL_VERMILION) then
            doCreatureExecuteTalkAction(cid, "/tp vermilion")
        elseif (channel == CHANNEL_LAVENDER) then
            doCreatureExecuteTalkAction(cid, "/tp lavender")
        elseif (channel == CHANNEL_FUCHSIA) then
            doCreatureExecuteTalkAction(cid, "/tp fuchsia")
        elseif (channel == CHANNEL_CINNABAR) then
            doCreatureExecuteTalkAction(cid, "/tp cinnabar")
        elseif (channel == CHANNEL_TANGELO) then
            doCreatureExecuteTalkAction(cid, "/tp tangelo")
        elseif (channel == CHANNEL_SUNBURST) then
            doCreatureExecuteTalkAction(cid, "/tp sunburst")
        elseif (channel == CHANNEL_MIKAN) then
            doCreatureExecuteTalkAction(cid, "/tp mikan")
        elseif (channel == CHANNEL_PUMMELO) then
            doCreatureExecuteTalkAction(cid, "/tp pummelo")
        elseif (channel == CHANNEL_PINKAN) then
            doCreatureExecuteTalkAction(cid, "/tp pinkan")
        elseif (channel == CHANNEL_VALENCIA) then
            doCreatureExecuteTalkAction(cid, "/tp valencia")
        elseif (channel == CHANNEL_HAMLIN) then
            doCreatureExecuteTalkAction(cid, "/tp hamlin")
        elseif (channel == CHANNEL_KUMQUAT) then
            doCreatureExecuteTalkAction(cid, "/tp kumquat")
        elseif (channel == CHANNEL_TARROCO) then
            doCreatureExecuteTalkAction(cid, "/tp tarroco")
        elseif (channel == CHANNEL_BUTWAL) then
            doCreatureExecuteTalkAction(cid, "/tp butwal")
        elseif (channel == CHANNEL_NAVEL) then
            doCreatureExecuteTalkAction(cid, "/tp navel")
        elseif (channel == CHANNEL_MANDARIN_NORTH) then
            doCreatureExecuteTalkAction(cid, "/tp mandarin north")
        elseif (channel == CHANNEL_ASCORBIA) then
            doCreatureExecuteTalkAction(cid, "/tp ascorbia")
        elseif (channel == CHANNEL_SEVEN_GRAPEFRUIT) then
            doCreatureExecuteTalkAction(cid, "/tp seven grapefruit")
        elseif (channel == CHANNEL_MORO) then
            doCreatureExecuteTalkAction(cid, "/tp moro")
        elseif (channel == CHANNEL_SHAMOUTI) then
            doCreatureExecuteTalkAction(cid, "/tp shamouti")
        elseif (channel == CHANNEL_MURCOTT) then
            doCreatureExecuteTalkAction(cid, "/tp murcott")
        elseif (channel == CHANNEL_TROVITOPOLIS) then
            doCreatureExecuteTalkAction(cid, "/tp trovitopolis")
        elseif (channel == CHANNEL_MANDARIN_SOUTH) then
            doCreatureExecuteTalkAction(cid, "/tp mandarin south")
        elseif (channel == CHANNEL_LITTLEROOT) then
            doCreatureExecuteTalkAction(cid, "/tp littleroot")
        elseif (channel == CHANNEL_OLDALE) then
            doCreatureExecuteTalkAction(cid, "/tp oldale")
        elseif (channel == CHANNEL_PETALBURG) then
            doCreatureExecuteTalkAction(cid, "/tp petalburg")
        elseif (channel == CHANNEL_RUSTBORO) then
            doCreatureExecuteTalkAction(cid, "/tp rustboro")
        elseif (channel == CHANNEL_DEWFORD) then
            doCreatureExecuteTalkAction(cid, "/tp dewford")
        elseif (channel == CHANNEL_SLATEPORT) then
            doCreatureExecuteTalkAction(cid, "/tp slateport")
        elseif (channel == CHANNEL_MAUVILLE) then
            doCreatureExecuteTalkAction(cid, "/tp mauville")
        elseif (channel == CHANNEL_VERDANTURF) then
            doCreatureExecuteTalkAction(cid, "/tp verdanturf")
        elseif (channel == CHANNEL_FALLARBOR) then
            doCreatureExecuteTalkAction(cid, "/tp fallarbor")
        elseif (channel == CHANNEL_LAVARIDGE) then
            doCreatureExecuteTalkAction(cid, "/tp lavaridge")
        elseif (channel == CHANNEL_FORTREE) then
            doCreatureExecuteTalkAction(cid, "/tp fortree")
        elseif (channel == CHANNEL_LILYCOVE) then
            doCreatureExecuteTalkAction(cid, "/tp lilycove")
        elseif (channel == CHANNEL_MOSSDEEP) then
            doCreatureExecuteTalkAction(cid, "/tp mossdeep")
        elseif (channel == CHANNEL_SOOTOPOLIS) then
            doCreatureExecuteTalkAction(cid, "/tp sootopolis")
        elseif (channel == CHANNEL_PACIFIDLOG) then
            doCreatureExecuteTalkAction(cid, "/tp pacifidlog")
        elseif (channel == CHANNEL_DUEL_WITHOUT_BET or channel == CHANNEL_DUEL_WITH_BET) then
            chooseBet(cid, channel == CHANNEL_DUEL_WITH_BET)
        elseif (channel == CHANNEL_WIKI_CHAT) then
            addEvent(function(cid)
                if (isCreature(cid)) then
                    WikiChat.handler:greet(cid)
                end
            end, 150, cid)
            return true
        end
		return false

	elseif (channel == CHANNEL_TOURNAMENT) then
		if (getPlayerTournamentInscribed(cid)) then
            local tournament = getTournamentInfo(getPlayerTournamentId(cid))
            if (tournament) then
                local diff = tournament.date - os.time()
                if (diff > 0) then
                    diff = string.timediff(diff, cid)
                    addEvent(doPlayerSendChannelMessage, 3000, cid, "", string.format(__L(cid, "Remaing %s to the %s tournament begin!"), table.concat(diff), tournament.name), TALKTYPE_CHANNEL_RA, channel)
                end
            end
        else
            addEvent(function(cid, channel)
                if (isCreature(cid)) then
                    doPlayerSendChannelMessage(cid, "You are not subscribed to any tournament.", TALKTYPE_CHANNEL_RA,
                        channel)
                end
            end, 3000)
		end
    end
	return true
end
