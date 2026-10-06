local base = 10000
local ballsAttributes = {
    --canUsePokeball = base + 1,
    pokemonName = base + 2,
    pokemonLastHp = base + 3,
    --spellTick = base + 4,
    pokemonLevel = base + 5,
    pokemonExperience = base + 6,
    energy = base + 7,
    maxEnergy = base + 8,
    statsSleep = base + 9,
    statsPoison = base + 10,
    statsBurn = base + 11,
    statsConfuse = base + 12,
    statsLowAccuracy = base + 13,
    statsParalyzed = base + 14,
    nickname = base + 15,
    sex = base + 16,
    pokemonLastHpPercent = base + 17,
    extraPoints = base + 18,
    statsPoisonDamage = base + 19,
    statsBurnDamage = base + 20,
    statsBadPoison = base + 21,
    statsBadPoisonDamage = base + 22,
    specialAbility = base + 23,
    tm1 = base + 24,
    tm1Slot = base + 25,
    tm2 = base + 26,
    tm2Slot = base + 27,
    seal = base + 28,
    uniqueFromTm = base + 29, -- When the ball is unique because it has an unique tm
    sketchMoves = base + 30, -- String-table with all sketch moves "Tackle#Bubblebeam#Water Gun..."
    uniqueFromTmSlot1 = base + 31, -- When unique by TM on slot 1
    uniqueFromTmSlot2 = base + 32, -- When unique by TM on slot 2
    originalTrainer = base + 33, -- Only give to starter Pokemons, a safe way to check later if it really is of the trainer
    uniqueFromTournament = base + 34, -- When the ball is unique because the player enters the tournament
    --[[transformMemory1 = base + 35,
    transformMemory2 = base + 36,
    transformMemory3 = base + 37,
    transformMemory4 = base + 38,
    currentTransform = base + 40, THESE STORAGED HAS CHANGED TO FORCE A RESET IN ALL BALL'S TRANSFORMATIONS]]
    transformMemory1 = base + 41,
    transformMemory2 = base + 42,
    currentTransform = base + 43,
    totalVitamins = base + 44,
    vitaminHpUp = base + 45,
    vitaminProtein = base + 46,
    vitaminIron = base + 47,
    vitaminCalcium = base + 48,
    vitaminZinc = base + 49,
    vitaminCarbos = base + 50,
    vitaminPPUp = base + 51,
    vitaminPPMax = base + 52,
    eggMoveSlot = base + 53,
    eggMove = base + 54,
    held = base + 55,
    heldLevel = base + 56,
    heldExperience = base + 57,
    isNotPokemonFromEgg = base + 58,
    receivedEggMove = base + 59,
    lastEggMoveGenerationTry = base + 60,
    fromNpc = base + 61, -- Borrowed by NPC to quest execution
    lastLollipopReceived = base + 62,
    heldVariables = base + 63,
    eggMoveRegenerateEnabled = base + 64,
    lastEggMoveRegenerationTry = base + 65,
    eggMovesRegenerated = base + 66,
    lastEggMoveRegenerated = base + 67,
    addons = base + 68,
    addonLookType = base + 69,
    addonLookHead = base + 70,
    addonLookBody = base + 71,
    addonLookLegs = base + 72,
    addonLookFeet = base + 73,
}

local SKETCH_MOVES_DELIMITER = ";"
local HEALTH_MAX = 99999999
local ENERGY_MAX = 99999

--[[ballsNames = {
    [12157] = "poke", [12158] = "poke", [12159] = "poke", [12160] = "poke",
    [12161] = "great", [12162] = "great", [12163] = "great", [12164] = "great",
    [12165] = "ultra", [12166] = "ultra", [12167] = "ultra", [12168] = "ultra",
    [12169] = "safari", [12170] = "safari", [12171] = "safari", [12172] = "safari",
    [12173] = "blue", [12174] = "blue", [12175] = "blue", [12176] = "blue",
    [12177] = "red", [12178] = "red", [12179] = "red", [12180] = "red",
    [12181] = "yellow", [12182] = "yellow", [12183] = "yellow", [12184] = "yellow",
    [12185] = "dark", [12186] = "dark", [12187] = "dark", [12188] = "dark",
    [13492] = "soul", [13493] = "soul", [13494] = "soul", [13495] = "soul",
    [14389] = "azure", [14390] = "azure", [14391] = "azure",
    [14392] = "brown", [14393] = "brown", [14394] = "brown",
    [14395] = "gold", [14396] = "gold", [14397] = "gold",
    [14398] = "green", [14399] = "green", [14400] = "green",
    [14401] = "pink", [14402] = "pink", [14403] = "pink",
    [14404] = "lilac", [14405] = "lilac", [14406] = "lilac",
    [14407] = "silver", [14408] = "silver", [14409] = "silver",
    [14410] = "sandwisp", [14411] = "sandwisp", [14412] = "sandwisp",
    [14443] = "star", [14444] = "star", [14445] = "star",
    [14446] = "yereblu", [14447] = "yereblu", [14448] = "yereblu",
    [14451] = "pumpkin", [14452] = "pumpkin", [14453] = "pumpkin",
    [14454] = "skull", [14455] = "skull", [14456] = "skull",
    [18129] = "frontier", [18130] = "frontier", [18131] = "frontier",
    [18628] = "coloured", [18629] = "coloured", [18630] = "coloured", [18631] = "coloured",
    [18725] = "black", [18726] = "black", [18727] = "black",
    [18725] = "black", [18726] = "black", [18727] = "black",
    [18728] = "fang", [18729] = "fang", [18730] = "fang",
    [18731] = "horn", [18732] = "horn", [18733] = "horn",
    [18852] = "blue egg", [18853] = "blue egg", [18854] = "blue egg",
    [18855] = "carrot", [18856] = "carrot", [18857] = "carrot",
    [18858] = "chocolate", [18859] = "chocolate", [18860] = "chocolate",
    [18861] = "green egg", [18862] = "green egg", [18863] = "green egg",
    [18864] = "white egg", [18865] = "white egg", [18866] = "white egg",
    [18886] = "dragonborn", [18887] = "dragonborn", [18888] = "dragonborn",
    [18889] = "grinch", [18890] = "grinch", [18891] = "grinch",
    [18892] = "minus", [18893] = "minus", [18894] = "minus",
    [18899] = "fire", [18900] = "fire", [18901] = "fire",
    [18902] = "thunder", [18903] = "thunder", [18904] = "thunder",
    [18905] = "water", [18906] = "water", [18907] = "water",
    [18933] = "nightmare", [18934] = "nightmare", [18935] = "nightmare",
    [18936] = "shadow", [18937] = "shadow", [18938] = "shadow",
    [18939] = "spark", [18940] = "spark", [18941] = "spark",
    [19027] = "avalanche", [19028] = "avalanche", [19029] = "avalanche", [19030] = "avalanche",
    [19031] = "blaze", [19032] = "blaze", [19033] = "blaze", [19034] = "blaze",
    [19035] = "gaia", [19036] = "gaia", [19037] = "gaia", [19038] = "gaia",
    [19039] = "heremit", [19040] = "heremit", [19041] = "heremit", [19042] = "heremit",
    [19043] = "hurricane", [19044] = "hurricane", [19045] = "hurricane", [19046] = "hurricane",
    [19047] = "spectrum", [19048] = "spectrum", [19049] = "spectrum", [19050] = "spectrum",
    [19051] = "vital", [19052] = "vital", [19053] = "vital", [19054] = "vital",
    [19055] = "voltagic", [19056] = "voltagic", [19057] = "voltagic", [19058] = "voltagic",
    [19059] = "zen", [19060] = "zen", [19061] = "zen", [19063] = "zen",
    [19074] = "bat", [19075] = "bat", [19076] = "bat",
    [19077] = "dark eye", [19078] = "dark eye", [19079] = "dark eye",
    [19080] = "spectral", [19081] = "spectral", [19082] = "spectral",
    [24554] = "blue easter", [24555] = "blue easter", [24556] = "blue easter",
    [24557] = "green easter", [24558] = "green easter", [24559] = "green easter",
    [24560] = "red easter", [24561] = "red easter", [24562] = "red easter",
    [24566] = "white easter", [24567] = "white easter", [24568] = "white easter", [24569] = "white easter",
    [24592] = "epic", [24593] = "epic", [24594] = "epic",
    [24595] = "jurassic", [24596] = "jurassic", [24597] = "jurassic",
    [24598] = "the companions", [24599] = "the companions", [24600] = "the companions",
    [24601] = "yin yang", [24602] = "yin yang", [24603] = "yin yang",
    [24608] = "eevee", [24609] = "eevee", [24610] = "eevee",
    [24611] = "espeon", [24612] = "espeon", [24613] = "espeon",
    [24614] = "flareon", [24615] = "flareon", [24616] = "flareon",
    [24617] = "jolteon", [24618] = "jolteon", [24619] = "jolteon",
    [24620] = "umbreon", [24621] = "umbreon", [24622] = "umbreon",
    [24623] = "vaporeon", [24624] = "vaporeon", [24625] = "vaporeon",
    [24677] = "cake", [24678] = "cake", [24679] = "cake",
    [24680] = "power green", [24681] = "power green", [24682] = "power green",
    [24683] = "power light purple", [24684] = "power light purple", [24685] = "power light purple",
    [24686] = "power pink", [24687] = "power pink", [24688] = "power pink",
    [24689] = "power purple", [24690] = "power purple", [24691] = "power purple",
    [24692] = "power red", [24693] = "power red", [24694] = "power red",
    [24695] = "power yellow", [24696] = "power yellow", [24697] = "power yellow",
    [25161] = "magic", [25162] = "magic", [25163] = "magic",
    [25164] = "pumpkinhead", [25165] = "pumpkinhead", [25166] = "pumpkinhead",
    [25167] = "pumpkinface", [25168] = "pumpkinface", [25169] = "pumpkinface",
    [25170] = "x-gold", [25171] = "x-gold", [25172] = "x-gold",
    [25173] = "yellow trace", [25174] = "yellow trace", [25175] = "yellow trace",
    [25176] = "invisible", [25177] = "invisible", [25178] = "invisible",
    [25276] = "xeeter", [25277] = "xeeter", [25278] = "xeeter", [25279] = "xeeter",
    --[12185] = "master", [12186] = "master", [12187] = "master", [12188] = "master"
}]]

balls = {
    ["poke"] = {
        useCounter = true,
        charged = 12159,
        discharged = 12160,
        empty = 12157,
        inUse = 12158,
        projectile = PROJECTILE_POKEBALL,
        effects = { use = EFFECT_POKEBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["great"] = {
        useCounter = true,
        charged = 12163,
        discharged = 12164,
        empty = 12161,
        inUse = 12162,
        projectile = PROJECTILE_GREATBALL,
        effects = { use = EFFECT_GREATBALL_USE, catch = EFFECT_GREATBALL_CATCH_OK, catchMiss = EFFECT_GREATBALL_CATCH_FAIL }
    },
    ["ultra"] = {
        useCounter = true,
        charged = 12167,
        discharged = 12168,
        empty = 12165,
        inUse = 12166,
        projectile = PROJECTILE_ULTRABALL,
        effects = { use = EFFECT_ULTRABALL_USE, catch = EFFECT_ULTRABALL_CATCH_OK, catchMiss = EFFECT_ULTRABALL_CATCH_FAIL }
    },
    ["safari"] = {
        useCounter = true,
        charged = 12171,
        discharged = 12172,
        empty = 12169,
        inUse = 12170,
        projectile = PROJECTILE_SAFARIBALL,
        effects = { use = EFFECT_SAFARIBALL_USE, catch = EFFECT_SAFARIBALL_CATCH_OK, catchMiss = EFFECT_SAFARIBALL_CATCH_FAIL }
    },
    ["blue"] = {
        charged = 12175,
        discharged = 12176,
        empty = 12173,
        inUse = 12174,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE, catch = EFFECT_BLUEBALL_CATCH_OK, catchMiss = EFFECT_BLUEBALL_CATCH_FAIL }
    },
    ["red"] = {
        charged = 12179,
        discharged = 12180,
        empty = 12177,
        inUse = 12178,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE, catch = EFFECT_REDBALL_CATCH_OK, catchMiss = EFFECT_REDBALL_CATCH_FAIL }
    },
    ["yellow"] = {
        charged = 12183,
        discharged = 12184,
        empty = 12181,
        inUse = 12182,
        projectile = PROJECTILE_YELLOWBALL,
        effects = { use = EFFECT_YELLOWBALL_USE, catch = EFFECT_YELLOWBALL_CATCH_OK, catchMiss = EFFECT_YELLOWBALL_CATCH_FAIL }
    },
    ["dark purple"] = {
        charged = 12187,
        discharged = 12188,
        empty = 12185,
        inUse = 12186,
        projectile = PROJECTILE_DARKBALL,
        effects = { use = EFFECT_DARKBALL_USE, catch = EFFECT_DARKBALL_CATCH_OK, catchMiss = EFFECT_DARKBALL_CATCH_FAIL }
    },
    ["soul"] = {
        charged = 13494,
        discharged = 13495,
        empty = 13492,
        inUse = 13493,
        projectile = PROJECTILE_POKEBALL,
        effects = { use = EFFECT_POKEBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["azure"] = {
        charged = 14389,
        discharged = 14390,
        inUse = 14391,
        projectile = PROJECTILE_AZUREBALL,
        effects = { use = EFFECT_AZUREBALL_USE }
    },
    ["brown"] = {
        charged = 14392,
        discharged = 14393,
        inUse = 14394,
        projectile = PROJECTILE_BROWNBALL,
        effects = { use = EFFECT_BROWNBALL_USE }
    },
    ["gold"] = {
        charged = 14395,
        discharged = 14396,
        inUse = 14397,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_GOLDBALL_USE }
    },
    ["green"] = {
        charged = 14398,
        discharged = 14399,
        inUse = 14400,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["pink"] = {
        charged = 14401,
        discharged = 14402,
        inUse = 14403,
        projectile = PROJECTILE_PINKBALL,
        effects = { use = EFFECT_PINKBALL_USE }
    },
    ["lilac"] = {
        charged = 14404,
        discharged = 14405,
        inUse = 14406,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["silver"] = {
        charged = 14407,
        discharged = 14408,
        inUse = 14409,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["sandwisp"] = {
        charged = 14410,
        discharged = 14411,
        inUse = 14412,
        projectile = PROJECTILE_SANDWISPBALL,
        effects = { use = EFFECT_SANDWISPBALL_USE }
    },
    ["star"] = {
        charged = 14443,
        discharged = 14444,
        inUse = 14445,
        projectile = PROJECTILE_POKEBALL,
        effects = { use = EFFECT_POKEBALL_USE }
    },
    ["yereblu"] = {
        charged = 14446,
        discharged = 14447,
        inUse = 14448,
        projectile = PROJECTILE_POKEBALL,
        effects = { use = EFFECT_POKEBALL_USE }
    },
    ["yereblu"] = {
        charged = 14446,
        discharged = 14447,
        inUse = 14448,
        projectile = PROJECTILE_POKEBALL,
        effects = { use = EFFECT_POKEBALL_USE }
    },
    ["pumpkin"] = {
        charged = 14451,
        discharged = 14452,
        inUse = 14453,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_GOLDBALL_USE }
    },
    ["skull"] = {
        charged = 14454,
        discharged = 14455,
        inUse = 14456,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["frontier"] = {
        charged = 18130,
        discharged = 18131,
        inUse = 18129,
        projectile = PROJECTILE_POKEBALL,
        effects = { use = EFFECT_POKEBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["coloured"] = {
        useCounter = true,
        charged = 18630,
        discharged = 18631,
        empty = 18628,
        inUse = 18629,
        projectile = PROJECTILE_COLOURED_BALL,
        effects = { use = EFFECT_COLOURED_BALL_CATCH_USE, catch = EFFECT_COLOURED_BALL_CATCH_OK, catchMiss = EFFECT_COLOURED_BALL_CATCH_FAIL }
    },
    ["black"] = {
        charged = 18725,
        discharged = 18726,
        inUse = 18727,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["fang"] = {
        charged = 18728,
        discharged = 18729,
        inUse = 18730,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["horn"] = {
        charged = 18731,
        discharged = 18732,
        inUse = 18733,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["blue egg"] = {
        charged = 18852,
        discharged = 18853,
        inUse = 18854,
        projectile = PROJECTILE_AZUREBALL,
        effects = { use = EFFECT_AZUREBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["carrot"] = {
        charged = 18855,
        discharged = 18856,
        inUse = 18857,
        projectile = PROJECTILE_BROWNBALL,
        effects = { use = EFFECT_BROWNBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["chocolate"] = {
        charged = 18858,
        discharged = 18859,
        inUse = 18860,
        projectile = PROJECTILE_BROWNBALL,
        effects = { use = EFFECT_BROWNBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["green egg"] = {
        charged = 18861,
        discharged = 18862,
        inUse = 18863,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["white egg"] = {
        charged = 18864,
        discharged = 18865,
        inUse = 18866,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["dragonborn"] = {
        charged = 18886,
        discharged = 18887,
        inUse = 18888,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["grinch"] = {
        charged = 18889,
        discharged = 18890,
        inUse = 18891,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["minus"] = {
        charged = 18892,
        discharged = 18893,
        inUse = 18894,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_GOLDBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["flame"] = {
        charged = 18899,
        discharged = 18900,
        inUse = 18901,
        projectile = PROJECTILE_POKEBALL,
        effects = { use = EFFECT_POKEBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["zap"] = {
        charged = 18902,
        discharged = 18903,
        inUse = 18904,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_GOLDBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["splash"] = {
        charged = 18905,
        discharged = 18906,
        inUse = 18907,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["nightmare"] = {
        charged = 18933,
        discharged = 18934,
        inUse = 18935,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["shadow"] = {
        charged = 18936,
        discharged = 18937,
        inUse = 18938,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["spark"] = {
        charged = 18939,
        discharged = 18940,
        inUse = 18941,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_GOLDBALL_USE, catch = EFFECT_POKEBALL_CATCH_OK, catchMiss = EFFECT_POKEBALL_CATCH_FAIL }
    },
    ["avalanche"] = {
        useCounter = true,
        charged = 19027,
        discharged = 19028,
        empty = 19029,
        inUse = 19030,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_AVALANCHEBALL_USE, catch = EFFECT_AVALANCHEBALL_CATCH_OK, catchMiss = EFFECT_AVALANCHEBALL_CATCH_FAIL },
        allowedElements = { ELEMENT_ICE, ELEMENT_WATER }
    },
    ["blaze"] = {
        useCounter = true,
        charged = 19031,
        discharged = 19032,
        empty = 19033,
        inUse = 19034,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_BLAZEBALL_USE, catch = EFFECT_BLAZEBALL_CATCH_OK, catchMiss = EFFECT_BLAZEBALL_CATCH_FAIL },
        allowedElements = { ELEMENT_FIRE }
    },
    ["gaia"] = {
        useCounter = true,
        charged = 19035,
        discharged = 19036,
        empty = 19037,
        inUse = 19038,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GAIABALL_USE, catch = EFFECT_GAIABALL_CATCH_OK, catchMiss = EFFECT_GAIABALL_CATCH_FAIL },
        allowedElements = { ELEMENT_GRASS, ELEMENT_BUG }
    },
    ["heremit"] = {
        useCounter = true,
        charged = 19039,
        discharged = 19040,
        empty = 19041,
        inUse = 19042,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_HEREMITBALL_USE, catch = EFFECT_HEREMITBALL_CATCH_OK, catchMiss = EFFECT_HEREMITBALL_CATCH_FAIL },
        allowedElements = { ELEMENT_GROUND, ELEMENT_ROCK }
    },
    ["hurricane"] = {
        useCounter = true,
        charged = 19043,
        discharged = 19044,
        empty = 19045,
        inUse = 19046,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_HURRICANEBALL_USE, catch = EFFECT_HURRICANEBALL_CATCH_OK, catchMiss = EFFECT_HURRICANEBALL_CATCH_FAIL },
        allowedElements = { ELEMENT_FLYING, ELEMENT_DRAGON }
    },
    ["spectrum"] = {
        useCounter = true,
        charged = 19047,
        discharged = 19048,
        empty = 19049,
        inUse = 19050,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_SPECTRUMBALL_USE, catch = EFFECT_SPECTRUMBALL_CATCH_OK, catchMiss = EFFECT_SPECTRUMBALL_CATCH_FAIL },
        allowedElements = { ELEMENT_GHOST, ELEMENT_POISON }
    },
    ["vital"] = {
        useCounter = true,
        charged = 19051,
        discharged = 19052,
        empty = 19053,
        inUse = 19054,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_VITALBALL_USE, catch = EFFECT_VITALBALL_CATCH_OK, catchMiss = EFFECT_VITALBALL_CATCH_FAIL },
        allowedElements = { ELEMENT_FIGHT, ELEMENT_NORMAL, ELEMENT_FAIRY }
    },
    ["voltagic"] = {
        useCounter = true,
        charged = 19055,
        discharged = 19056,
        empty = 19057,
        inUse = 19058,
        projectile = PROJECTILE_YELLOWBALL,
        effects = { use = EFFECT_VOLTAGICBALL_USE, catch = EFFECT_VOLTAGICBALL_CATCH_OK, catchMiss = EFFECT_VOLTAGICBALL_CATCH_FAIL },
        allowedElements = { ELEMENT_ELECTRIC, ELEMENT_STEEL }
    },
    ["zen"] = {
        useCounter = true, -- Remember to update database schema
        charged = 19059,
        discharged = 19060,
        empty = 19061,
        inUse = 19063,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_ZENBALL_USE, catch = EFFECT_ZENBALL_CATCH_OK, catchMiss = EFFECT_ZENBALL_CATCH_FAIL },
        allowedElements = { ELEMENT_PSYCHIC, ELEMENT_DARK }
    },
    ["bat"] = {
        charged = 19074,
        discharged = 19075,
        inUse = 19076,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["dark eye"] = {
        charged = 19077,
        discharged = 19078,
        inUse = 19079,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["spectral"] = {
        charged = 19080,
        discharged = 19081,
        inUse = 19082,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["blue easter"] = {
        charged = 24554,
        discharged = 24555,
        inUse = 24556,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["green easter"] = {
        charged = 24557,
        discharged = 24558,
        inUse = 24559,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["red easter"] = {
        charged = 24560,
        discharged = 24561,
        inUse = 24562,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["white easter"] = {
        useCounter = true, -- Remember to update database schema
        charged = 24566,
        discharged = 24567,
        empty = 24568,
        inUse = 24569,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_WHITEEASTER_USE, catch = EFFECT_WHITEEASTER_CATCH_OK, catchMiss = EFFECT_WHITEEASTER_CATCH_FAIL },
    },
    ["epic"] = {
        charged = 24592,
        discharged = 24593,
        inUse = 24594,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["jurassic"] = {
        charged = 24595,
        discharged = 24596,
        inUse = 24597,
        projectile = PROJECTILE_BROWNBALL,
        effects = { use = EFFECT_BROWNBALL_USE }
    },
    ["the companions"] = {
        charged = 24598,
        discharged = 24599,
        inUse = 24600,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["yin yang"] = {
        charged = 24601,
        discharged = 24602,
        inUse = 24603,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["eevee"] = {
        charged = 24608,
        discharged = 24609,
        inUse = 24610,
        projectile = PROJECTILE_BROWNBALL,
        effects = { use = EFFECT_BROWNBALL_USE }
    },
    ["espeon"] = {
        charged = 24611,
        discharged = 24612,
        inUse = 24613,
        projectile = PROJECTILE_PINKBALL,
        effects = { use = EFFECT_PINKBALL_USE }
    },
    ["flareon"] = {
        charged = 24614,
        discharged = 24615,
        inUse = 24616,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["jolteon"] = {
        charged = 24617,
        discharged = 24618,
        inUse = 24619,
        projectile = PROJECTILE_YELLOWBALL,
        effects = { use = EFFECT_YELLOWBALL_USE }
    },
    ["umbreon"] = {
        charged = 24620,
        discharged = 24621,
        inUse = 24622,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["vaporeon"] = {
        charged = 24623,
        discharged = 24624,
        inUse = 24625,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["cake"] = {
        charged = 24677,
        discharged = 24678,
        inUse = 24679,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_GOLDBALL_USE }
    },
    ["power green"] = {
        charged = 24680,
        discharged = 24681,
        inUse = 24682,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREATBALL_USE }
    },
    ["power light purple"] = {
        charged = 24683,
        discharged = 24684,
        inUse = 24685,
        projectile = PROJECTILE_AZUREBALL,
        effects = { use = EFFECT_AZUREBALL_USE }
    },
    ["power pink"] = {
        charged = 24686,
        discharged = 24687,
        inUse = 24688,
        projectile = PROJECTILE_PINKBALL,
        effects = { use = EFFECT_PINKBALL_USE }
    },
    ["power purple"] = {
        charged = 24689,
        discharged = 24690,
        inUse = 24691,
        projectile = PROJECTILE_AZUREBALL,
        effects = { use = EFFECT_AZUREBALL_USE }
    },
    ["power red"] = {
        charged = 24692,
        discharged = 24693,
        inUse = 24694,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["power yellow"] = {
        charged = 24695,
        discharged = 24696,
        inUse = 24697,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_GOLDBALL_USE }
    },
    ["magic"] = {
        charged = 25161,
        discharged = 25162,
        inUse = 25163,
        projectile = PROJECTILE_AZUREBALL,
        effects = { use = EFFECT_AZUREBALL_USE }
    },
    ["pumpkinhead"] = {
        charged = 25164,
        discharged = 25165,
        inUse = 25166,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_GOLDBALL_USE }
    },
    ["pumpkinface"] = {
        charged = 25167,
        discharged = 25168,
        inUse = 25169,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_GOLDBALL_USE }
    },
    ["x-gold"] = {
        charged = 25170,
        discharged = 25171,
        inUse = 25172,
        projectile = PROJECTILE_BLACKBALL,
        effects = { use = EFFECT_HEREMITBALL_USE }
    },
    ["yellow trace"] = {
        charged = 25173,
        discharged = 25174,
        inUse = 25175,
        projectile = PROJECTILE_BLACKBALL,
        effects = { use = EFFECT_HEREMITBALL_USE }
    },
    ["invisible"] = {
        charged = 25176,
        discharged = 25177,
        inUse = 25178,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["xeeter"] = {
        returnOnBroke = true,
        charged = 25276,
        discharged = 25277,
        inUse = 25278,
        empty = 25279,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_XEETERBALL_USE, catch = EFFECT_XEETERBALL_CATCH_OK, catchMiss = EFFECT_XEETERBALL_CATCH_FAIL }
    },
    ["blue present"] = {
        charged = 25318,
        discharged = 25319,
        inUse = 25320,
        projectile = PROJECTILE_AZUREBALL,
        effects = { use = EFFECT_AZUREBALL_USE }
    },
    ["christmas night"] = {
        charged = 25321,
        discharged = 25322,
        inUse = 25323,
        projectile = PROJECTILE_AZUREBALL,
        effects = { use = EFFECT_AZUREBALL_USE }
    },
    ["christmas tree"] = {
        charged = 25324,
        discharged = 25325,
        inUse = 25326,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["ginger"] = {
        charged = 25327,
        discharged = 25328,
        inUse = 25329,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_GOLDBALL_USE }
    },
    ["green present"] = {
        charged = 25330,
        discharged = 25331,
        inUse = 25332,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["north pole"] = {
        charged = 25333,
        discharged = 25334,
        inUse = 25335,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["purple present"] = {
        charged = 25336,
        discharged = 25337,
        inUse = 25338,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["red present"] = {
        charged = 25339,
        discharged = 25340,
        inUse = 25341,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["yellow present"] = {
        charged = 25342,
        discharged = 25343,
        inUse = 25344,
        projectile = PROJECTILE_YELLOWBALL,
        effects = { use = EFFECT_YELLOWBALL_USE }
    },
    ["christmas"] = {
        useCounter = true, -- Remember to update database schema
        charged = 25345,
        discharged = 25346,
        inUse = 25347,
        empty = 25348,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_CHRISTMASBALL_USE, catch = EFFECT_CHRISTMASBALL_CATCH_OK, catchMiss = EFFECT_CHRISTMASBALL_CATCH_FAIL }
    },
    --[[["yellow present"] = {
        charged = 25342, discharged = 25343, inUse = 25344,
        projectile = PROJECTILE_YELLOWBALL, effects = {use = EFFECT_YELLOWBALL_USE}
    },]]
    ["blue chocoegg"] = {
        charged = 25358,
        discharged = 25359,
        inUse = 25360,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["brown chocoegg"] = {
        charged = 25361,
        discharged = 25362,
        inUse = 25363,
        projectile = PROJECTILE_BROWNBALL,
        effects = { use = EFFECT_BROWNBALL_USE }
    },
    ["golden easter"] = {
        charged = 25364,
        discharged = 25365,
        inUse = 25366,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_GOLDBALL_USE }
    },
    ["green chocoegg"] = {
        charged = 25367,
        discharged = 25368,
        inUse = 25369,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["king chocoegg"] = {
        charged = 25370,
        discharged = 25371,
        inUse = 25372,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_GOLDBALL_USE }
    },
    ["mint chocoegg"] = {
        charged = 25373,
        discharged = 25374,
        inUse = 25375,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["ocean chocoegg"] = {
        charged = 25376,
        discharged = 25377,
        inUse = 25378,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["orange chocoegg"] = {
        charged = 25379,
        discharged = 25380,
        inUse = 25381,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["pink chocoegg"] = {
        charged = 25382,
        discharged = 25383,
        inUse = 25384,
        projectile = PROJECTILE_PINKBALL,
        effects = { use = EFFECT_PINKBALL_USE }
    },
    ["purple chocoegg"] = {
        charged = 25385,
        discharged = 25386,
        inUse = 25387,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["red chocoegg"] = {
        charged = 25388,
        discharged = 25389,
        inUse = 25390,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["yellow chocoegg"] = {
        charged = 25391,
        discharged = 25392,
        inUse = 25393,
        projectile = PROJECTILE_YELLOWBALL,
        effects = { use = EFFECT_YELLOWBALL_USE }
    },
    ["bug"] = {
        charged = 27631,
        discharged = 27632,
        inUse = 27633,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["insect"] = {
        charged = 27634,
        discharged = 27635,
        inUse = 27636,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["dark"] = {
        charged = 27637,
        discharged = 27638,
        inUse = 27639,
        projectile = PROJECTILE_BROWNBALL,
        effects = { use = EFFECT_BROWNBALL_USE }
    },
    ["dread"] = {
        charged = 27640,
        discharged = 27641,
        inUse = 27642,
        projectile = PROJECTILE_BROWNBALL,
        effects = { use = EFFECT_BROWNBALL_USE }
    },
    ["draco"] = {
        charged = 27643,
        discharged = 27644,
        inUse = 27645,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_US }
    },
    ["dragon"] = {
        charged = 27646,
        discharged = 27647,
        inUse = 27648,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["electric"] = {
        charged = 27649,
        discharged = 27650,
        inUse = 27651,
        projectile = PROJECTILE_YELLOWBALL,
        effects = { use = EFFECT_YELLOWBALL_USE }
    },
    ["pixie"] = {
        charged = 27652,
        discharged = 27653,
        inUse = 27654,
        projectile = PROJECTILE_PINKBALL,
        effects = { use = EFFECT_PINKBALL_USE }
    },
    ["fighting"] = {
        charged = 27655,
        discharged = 27656,
        inUse = 27657,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["fist"] = {
        charged = 27658,
        discharged = 27659,
        inUse = 27660,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["fire"] = {
        charged = 27661,
        discharged = 27662,
        inUse = 27663,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["flying"] = {
        charged = 27664,
        discharged = 27665,
        inUse = 27666,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["sky"] = {
        charged = 27667,
        discharged = 27668,
        inUse = 27669,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["ghost"] = {
        charged = 27670,
        discharged = 27671,
        inUse = 27672,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["spooky"] = {
        charged = 27673,
        discharged = 27674,
        inUse = 27675,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["grass"] = {
        charged = 27676,
        discharged = 27677,
        inUse = 27678,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["meadow"] = {
        charged = 27679,
        discharged = 27680,
        inUse = 27681,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["earth"] = {
        charged = 27682,
        discharged = 27683,
        inUse = 27684,
        projectile = PROJECTILE_SANDWISPBALL,
        effects = { use = EFFECT_SANDWISPBALL_USE }
    },
    ["ground"] = {
        charged = 27685,
        discharged = 27686,
        inUse = 27687,
        projectile = PROJECTILE_SANDWISPBALL,
        effects = { use = EFFECT_SANDWISPBALL_USE }
    },
    ["ice"] = {
        charged = 27688,
        discharged = 27689,
        inUse = 27690,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["icicle"] = {
        charged = 27691,
        discharged = 27692,
        inUse = 27693,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["normal"] = {
        charged = 27694,
        discharged = 27695,
        inUse = 27696,
        projectile = PROJECTILE_SANDWISPBALL,
        effects = { use = EFFECT_SANDWISPBALL_USE }
    },
    ["plate"] = {
        charged = 27697,
        discharged = 27698,
        inUse = 27699,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["poison"] = {
        charged = 27700,
        discharged = 27701,
        inUse = 27702,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["toxic"] = {
        charged = 27703,
        discharged = 27704,
        inUse = 27705,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["mind"] = {
        charged = 27706,
        discharged = 27707,
        inUse = 27708,
        projectile = PROJECTILE_PINKBALL,
        effects = { use = EFFECT_PINKBALL_USE }
    },
    ["psychic"] = {
        charged = 27709,
        discharged = 27710,
        inUse = 27711,
        projectile = PROJECTILE_PINKBALL,
        effects = { use = EFFECT_PINKBALL_USE }
    },
    ["rock"] = {
        charged = 27712,
        discharged = 27713,
        inUse = 27714,
        projectile = PROJECTILE_SANDWISPBALL,
        effects = { use = EFFECT_SANDWISPBALL_USE }
    },
    ["stone"] = {
        charged = 27715,
        discharged = 27716,
        inUse = 27717,
        projectile = PROJECTILE_SANDWISPBALL,
        effects = { use = EFFECT_SANDWISPBALL_USE }
    },
    ["iron"] = {
        charged = 27718,
        discharged = 27719,
        inUse = 27720,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["steel"] = {
        charged = 27721,
        discharged = 27722,
        inUse = 27723,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["water"] = {
        charged = 27724,
        discharged = 27725,
        inUse = 27726,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["fairy"] = {
        charged = 27727,
        discharged = 27728,
        inUse = 27729,
        projectile = PROJECTILE_PINKBALL,
        effects = { use = EFFECT_PINKBALL_USE }
    },
    ["fire legendary"] = {
        charged = 27775,
        discharged = 27776,
        inUse = 27777,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["green vision"] = {
        charged = 27779,
        discharged = 27780,
        inUse = 27781,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["l"] = {
        charged = 27783,
        discharged = 27784,
        inUse = 27785,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["o"] = {
        charged = 27787,
        discharged = 27788,
        inUse = 27789,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["ocean vision"] = {
        charged = 27791,
        discharged = 27792,
        inUse = 27793,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["p"] = {
        charged = 27795,
        discharged = 27796,
        inUse = 27797,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["purple vision"] = {
        charged = 27799,
        discharged = 27800,
        inUse = 27801,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["s"] = {
        charged = 27803,
        discharged = 27804,
        inUse = 27805,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["u"] = {
        charged = 27807,
        discharged = 27808,
        inUse = 27809,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["black cat"] = {
        charged = 27995,
        discharged = 27996,
        inUse = 27997,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["halloween ghost"] = {
        charged = 27999,
        discharged = 28000,
        inUse = 28001,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["halloween"] = {
        charged = 28003,
        discharged = 28004,
        inUse = 28005,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["enchanted"] = {
        charged = 28007,
        discharged = 28008,
        inUse = 28009,
        empty = 28070,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_ENCHANTEDBALL_USE, catch = EFFECT_ENCHANTEDBALL_CATCH_OK, catchMiss = EFFECT_ENCHANTEDBALL_CATCH_FAIL }
    },
    ["orange bat"] = {
        charged = 28011,
        discharged = 28012,
        inUse = 28013,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["silver bat"] = {
        charged = 28015,
        discharged = 28016,
        inUse = 28017,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["dark pumpkin"] = {
        charged = 28019,
        discharged = 28020,
        inUse = 28021,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["eye"] = {
        charged = 28023,
        discharged = 28024,
        inUse = 28025,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["mummy"] = {
        charged = 28027,
        discharged = 28028,
        inUse = 28029,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["neon"] = {
        charged = 28031,
        discharged = 28032,
        inUse = 28033,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["witch"] = {
        charged = 28035,
        discharged = 28036,
        inUse = 28037,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["black tearful"] = {
        charged = 28090,
        discharged = 28091,
        inUse = 28092,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["blue tearful"] = {
        charged = 28093,
        discharged = 28094,
        inUse = 28095,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["brain"] = {
        charged = 28096,
        discharged = 28097,
        inUse = 28098,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["green tearful"] = {
        charged = 28099,
        discharged = 28100,
        inUse = 28101,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["moonlight"] = {
        charged = 28102,
        discharged = 28103,
        inUse = 28104,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["orange tearful"] = {
        charged = 28105,
        discharged = 28106,
        inUse = 28107,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["pink tearful"] = {
        charged = 28108,
        discharged = 28109,
        inUse = 28110,
        projectile = PROJECTILE_PINKBALL,
        effects = { use = EFFECT_PINKBALL_USE }
    },
    ["pirate skull"] = {
        charged = 28111,
        discharged = 28112,
        inUse = 28113,
        projectile = PROJECTILE_PINKBALL,
        effects = { use = EFFECT_PINKBALL_USE }
    },
    ["purple tearful"] = {
        charged = 28114,
        discharged = 28115,
        inUse = 28116,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["red tearful"] = {
        charged = 28117,
        discharged = 28118,
        inUse = 28119,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["strange skull"] = {
        charged = 28120,
        discharged = 28121,
        inUse = 28122,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["sunshine"] = {
        charged = 28123,
        discharged = 28124,
        inUse = 28125,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["white tearful"] = {
        charged = 28126,
        discharged = 28127,
        inUse = 28128,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["bg jester"] = {
        charged = 28170,
        discharged = 28171,
        inUse = 28172,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["blue christmas light"] = {
        charged = 28174,
        discharged = 28175,
        inUse = 28176,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["blue christmas present"] = {
        charged = 28178,
        discharged = 28179,
        inUse = 28180,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["christmas chimney"] = {
        charged = 28182,
        discharged = 28183,
        inUse = 28184,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["garland"] = {
        charged = 28186,
        discharged = 28187,
        inUse = 28188,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["golden christmas"] = {
        charged = 28190,
        discharged = 28191,
        inUse = 28192,
        projectile = PROJECTILE_GOLDBALL,
        effects = { use = EFFECT_GOLDBALL_USE }
    },
    ["green christmas light"] = {
        charged = 28194,
        discharged = 28195,
        inUse = 28196,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["green christmas present"] = {
        charged = 28198,
        discharged = 28199,
        inUse = 28200,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["grinch christmas"] = {
        charged = 28202,
        discharged = 28203,
        inUse = 28204,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["noel"] = {
        charged = 28206,
        discharged = 28207,
        inUse = 28208,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["orange christmas light"] = {
        charged = 28210,
        discharged = 28211,
        inUse = 28212,
        projectile = PROJECTILE_SANDWISPBALL,
        effects = { use = EFFECT_SANDWISPBALL_USE }
    },
    ["pine tree"] = {
        charged = 28214,
        discharged = 28215,
        inUse = 28216,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["pink christmas light"] = {
        charged = 28218,
        discharged = 28219,
        inUse = 28220,
        projectile = PROJECTILE_PINKBALL,
        effects = { use = EFFECT_PINKBALL_USE }
    },
    ["purple christmas light"] = {
        charged = 28222,
        discharged = 28223,
        inUse = 28224,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["red christmas light"] = {
        charged = 28226,
        discharged = 28227,
        inUse = 28228,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["reindeer"] = {
        charged = 28230,
        discharged = 28231,
        inUse = 28232,
        projectile = PROJECTILE_SANDWISPBALL,
        effects = { use = EFFECT_SANDWISPBALL_USE }
    },
    ["rgb present"] = {
        charged = 28234,
        discharged = 28235,
        inUse = 28236,
        projectile = PROJECTILE_LILACBALL,
        effects = { use = EFFECT_LILACBALL_USE }
    },
    ["ry jester"] = {
        charged = 28238,
        discharged = 28239,
        inUse = 28240,
        projectile = PROJECTILE_YELLOWBALL,
        effects = { use = EFFECT_YELLOWBALL_USE }
    },
    ["silver christmas"] = {
        charged = 28242,
        discharged = 28243,
        inUse = 28244,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["sky blue christmas light"] = {
        charged = 28246,
        discharged = 28247,
        inUse = 28248,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["snowman"] = {
        charged = 28250,
        discharged = 28251,
        inUse = 28252,
        projectile = PROJECTILE_SILVERBALL,
        effects = { use = EFFECT_SILVERBALL_USE }
    },
    ["yellow christmas light"] = {
        charged = 28254,
        discharged = 28255,
        inUse = 28256,
        projectile = PROJECTILE_YELLOWBALL,
        effects = { use = EFFECT_YELLOWBALL_USE }
    },
    ["yellow christmas present"] = {
        charged = 28258,
        discharged = 28259,
        inUse = 28260,
        projectile = PROJECTILE_SANDWISPBALL,
        effects = { use = EFFECT_SANDWISPBALL_USE }
    },
    ["divine"] = {
        charged = 29873,
        discharged = 29874,
        inUse = 29875,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["skyller"] = {
        charged = 29877,
        discharged = 29878,
        inUse = 29879,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["xdark"] = {
        charged = 29881,
        discharged = 29882,
        inUse = 29883,
        projectile = PROJECTILE_REDBALL,
    },
    ["firestone"] = {
        charged = 29887,
        discharged = 29888,
        inUse = 29889,
        projectile = PROJECTILE_REDBALL,
        effects = { use = EFFECT_REDBALL_USE }
    },
    ["golem"] = {
        charged = 29891,
        discharged = 29892,
        inUse = 29893,
        projectile = PROJECTILE_BROWNBALL,
        effects = { use = EFFECT_BROWNBALL_USE }
    },
    ["sunstone"] = {
        charged = 29895,
        discharged = 29896,
        inUse = 29897,
        projectile = PROJECTILE_YELLOWBALL,
        effects = { use = EFFECT_YELLOWBALL_USE }
    },
    ["tentacruel"] = {
        charged = 29899,
        discharged = 29900,
        inUse = 29901,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    ["vanish"] = {
        charged = 29903,
        discharged = 29904,
        inUse = 29905,
        projectile = PROJECTILE_GREENBALL,
        effects = { use = EFFECT_GREENBALL_USE }
    },
    ["waterstone"] = {
        charged = 29907,
        discharged = 29908,
        inUse = 29909,
        projectile = PROJECTILE_BLUEBALL,
        effects = { use = EFFECT_BLUEBALL_USE }
    },
    --["master"] = {
    --	charged = 12187, discharged = 12188, empty = 12185, inUse = 12186,
    --	projectile = projectiles.masterball, effects = {use = effects.masterballUse, catch = effects.masterballCatch, catchMiss = effects.masterballCatchMiss}
    --}
}

ballsNames = {}
for ballName, config in pairs(balls) do
    if (config.charged) then
        ballsNames[config.charged] = ballName
    end

    if (config.discharged) then
        ballsNames[config.discharged] = ballName
    end

    if (config.inUse) then
        ballsNames[config.inUse] = ballName
    end

    if (config.empty) then
        ballsNames[config.empty] = ballName
    end
end

--[[
balls = {
	balls["poke"].charged, balls["poke"].discharged,
	balls["great"].charged, balls["great"].discharged,
	balls["ultra"].charged, balls["ultra"].discharged,
	balls["safari"].charged, balls["safari"].discharged,
	balls["blue"].charged, balls["blue"].discharged,
	balls["red"].charged, balls["red"].discharged,
	balls["yellow"].charged, balls["yellow"].discharged,
	balls["dark"].charged, balls["dark"].discharged,
	balls["soul"].charged, balls["soul"].discharged
}
]]
local CATCH_RATE = {
    ["poke"] = 1,
    ["great"] = 2,
    ["ultra"] = 3,
    ["safari"] = 4,
    ["blue"] = 1,
    ["red"] = 1,
    ["yellow"] = 1,
    ["dark purple"] = 1,
    ["soul"] = 1,
    ["coloured"] = 2.5,
    ["avalanche"] = 4,
    ["blaze"] = 4,
    ["gaia"] = 4,
    ["heremit"] = 4,
    ["hurricane"] = 4,
    ["spectrum"] = 4,
    ["vital"] = 4,
    ["voltagic"] = 4,
    ["zen"] = 4,
    ["white easter"] = 1,
    ["xeeter"] = 3,
    ["christmas"] = 1,
    ["enchanted"] = 3,
}

-- Functions
-- Get
function getBallCatchRate(ballName)
    return CATCH_RATE[ballName] or 1
end

function getBallPokemonName(uid)
    return getItemAttribute(uid, ballsAttributes.pokemonName)
end

function getBallPokemonLastHp(uid)
    return getItemAttribute(uid, ballsAttributes.pokemonLastHp)
end

function getBallPokemonLevel(uid)
    return getItemAttribute(uid, ballsAttributes.pokemonLevel) or 1
end

function getBallPokemonExp(uid)
    return getItemAttribute(uid, ballsAttributes.pokemonExperience) or 0
end

function getBallPokemonEnergy(uid)
    return getItemAttribute(uid, ballsAttributes.energy)
end

function getBallPokemonMaxEnergy(uid)
    -- todo: this function isnt really working, the vitamin may influence this true result
    local pokemonName = getBallPokemonName(uid)
    return getPokemonBaseEnergy(pokemonName) + getBallPokemonLevel(uid) * POKEMON_GAIN_ENERGY
    --return getItemAttribute(uid, ballsAttributes.maxEnergy)
end

function getBallPokemonNickname(uid)
    return getItemAttribute(uid, ballsAttributes.nickname)
end

function getBallPokemonSex(uid)
    return getItemAttribute(uid, ballsAttributes.sex)
end

function getBallStatsSleep(uid)
    return getItemAttribute(uid, ballsAttributes.statsSleep)
end

function getBallStatsPoison(uid)
    return getItemAttribute(uid, ballsAttributes.statsPoison)
end

function getBallStatsBurn(uid)
    return getItemAttribute(uid, ballsAttributes.statsBurn)
end

function getBallStatsBadPoison(uid)
    return getItemAttribute(uid, ballsAttributes.statsBadPoison)
end

function getBallStatsConfuse(uid)
    return getItemAttribute(uid, ballsAttributes.statsConfuse)
end

function getBallStatsLowAccuracy(uid)
    return getItemAttribute(uid, ballsAttributes.statsLowAccuracy)
end

function getBallStatsParalyzed(uid)
    return getItemAttribute(uid, ballsAttributes.statsParalyzed)
end

function getBallPokemonLastHpPercent(uid)
    return getItemAttribute(uid, ballsAttributes.pokemonLastHpPercent) or 100
end

function getBallPokemonExtraPoints(uid)
    return getItemAttribute(uid, ballsAttributes.extraPoints) or 0
end

function getBallStatsPoisonDamage(uid)
    return getItemAttribute(uid, ballsAttributes.statsPoisonDamage)
end

function getBallStatsBurnDamage(uid)
    return getItemAttribute(uid, ballsAttributes.statsBurnDamage)
end

function getBallStatsBadPoisonDamage(uid)
    return getItemAttribute(uid, ballsAttributes.statsBadPoisonDamage)
end

function getBallPokemonSpecialAbility(uid)
    return getItemAttribute(uid, ballsAttributes.specialAbility) or POKEMON_SPECIAL_ABILITY_IDS.NONE
end

function getBallTm(uid, number)
    return getItemAttribute(uid, (number == 1 and ballsAttributes.tm1 or ballsAttributes.tm2)) or TM_IDS.NONE
end

function getBallTmSlot(uid, number)
    return getItemAttribute(uid, (number == 1 and ballsAttributes.tm1Slot or ballsAttributes.tm2Slot)) or 0
end

function getBallSeal(uid)
    return getItemAttribute(uid, ballsAttributes.seal) or BALL_SEAL_IDS.NONE
end

function getBallUniqueFromTm(uid)
    return getItemAttribute(uid, ballsAttributes.uniqueFromTm) == 1
end

function getBallSketchMoves(uid)
    local r = {}

    local attr = getItemAttribute(uid, ballsAttributes.sketchMoves)
    if (not attr) then
        return r
    end

    for k, v in pairs(string.explode(attr, SKETCH_MOVES_DELIMITER)) do
        r[#r + 1] = v
    end

    return r
end

function getBallUniqueFromTmSlot(uid, slot)
    return getItemAttribute(uid, (slot == 1 and ballsAttributes.uniqueFromTmSlot1 or
            ballsAttributes.uniqueFromTmSlot2)) == 1
end

function getBallOriginalTrainer(uid)
    return getItemAttribute(uid, ballsAttributes.originalTrainer)
end

function getBallUniqueFromTournament(uid)
    return getItemAttribute(uid, ballsAttributes.uniqueFromTournament) == 1
end

function getBallPokemonReferenceName(uid)
    local transform = getBallCurrentTransform(uid)
    if (transform) then
        return transform
    end
    return getBallPokemonName(uid)
end

-- Set
function setBallPokemonName(uid, pokemonName)
    doItemSetAttribute(uid, ballsAttributes.pokemonName, pokemonName)
end

function setBallPokemonLastHp(uid, pokemonLastHp)
    doItemSetAttribute(uid, ballsAttributes.pokemonLastHp, pokemonLastHp)
end

function setBallPokemonLevel(uid, pokemonLevel)
    doItemSetAttribute(uid, ballsAttributes.pokemonLevel,
        (tonumber(pokemonLevel) <= POKEMON_LEVEL_MAX and pokemonLevel or POKEMON_LEVEL_MAX))
end

function setBallPokemonExp(uid, pokemonExp)
    doItemSetAttribute(uid, ballsAttributes.pokemonExperience, pokemonExp)
end

function setBallPokemonEnergy(uid, pokemonEnergy)
    doItemSetAttribute(uid, ballsAttributes.energy, pokemonEnergy)
end

function setBallPokemonMaxEnergy(uid, pokemonMaxEnergy)
    doItemSetAttribute(uid, ballsAttributes.maxEnergy, pokemonMaxEnergy)
end

function setBallPokemonNickname(uid, pokemonNickname, removing)
    if (removing) then
        doItemEraseAttribute(uid, ballsAttributes.nickname)
    else
        doItemSetAttribute(uid, ballsAttributes.nickname, pokemonNickname)
    end
end

function setBallPokemonSex(uid, pokemonSex)
    doItemSetAttribute(uid, ballsAttributes.sex, pokemonSex)
end

function setBallStatsSleep(uid, stats)
    doItemSetAttribute(uid, ballsAttributes.statsSleep, (stats and 1 or -1))
end

function setBallStatsPoison(uid, stats)
    doItemSetAttribute(uid, ballsAttributes.statsPoison, (stats and 1 or -1))
end

function setBallStatsBurn(uid, stats)
    doItemSetAttribute(uid, ballsAttributes.statsBurn, (stats and 1 or -1))
end

function setBallStatsBadPoison(uid, stats)
    doItemSetAttribute(uid, ballsAttributes.statsBadPoison, (stats and 1 or -1))
end

function setBallStatsConfuse(uid, stats)
    doItemSetAttribute(uid, ballsAttributes.statsConfuse, (stats and 1 or -1))
end

function setBallStatsLowAccuracy(uid, stats)
    doItemSetAttribute(uid, ballsAttributes.statsLowAccuracy, (stats and 1 or -1))
end

function setBallStatsParalyzed(uid, stats)
    doItemSetAttribute(uid, ballsAttributes.statsParalyzed, (stats and 1 or -1))
end

function setBallPokemonLastHpPercent(uid, lastHpPercent)
    doItemSetAttribute(uid, ballsAttributes.pokemonLastHpPercent, lastHpPercent)
end

function setBallPokemonExtraPoints(uid, extraPoints)
    doItemSetAttribute(uid, ballsAttributes.extraPoints,
        (tonumber(extraPoints) <= (POKEMON_LEVEL_MAX + 10) and extraPoints or (POKEMON_LEVEL_MAX + 10)))
end

function setBallStatsPoisonDamage(uid, damage)
    doItemSetAttribute(uid, ballsAttributes.statsPoisonDamage, damage)
end

function setBallStatsBurnDamage(uid, damage)
    doItemSetAttribute(uid, ballsAttributes.statsBurnDamage, damage)
end

function setBallStatsBadPoisonDamage(uid, damage)
    doItemSetAttribute(uid, ballsAttributes.statsBadPoisonDamage, damage)
end

function setBallPokemonSpecialAbility(uid, ability)
    doItemSetAttribute(uid, ballsAttributes.specialAbility, ability)
end

function setBallTm(uid, number, moveSlot, tm)
    if (tm == TM_IDS.NONE) then
        doItemEraseAttribute(uid, (number == 1 and ballsAttributes.tm1Slot or ballsAttributes.tm2Slot))
        doItemEraseAttribute(uid, (number == 1 and ballsAttributes.tm1 or ballsAttributes.tm2))
    else
        doItemSetAttribute(uid, (number == 1 and ballsAttributes.tm1Slot or ballsAttributes.tm2Slot), moveSlot)
        doItemSetAttribute(uid, (number == 1 and ballsAttributes.tm1 or ballsAttributes.tm2), tm)
    end
end

function setBallSeal(uid, seal)
    if (seal == BALL_SEAL_IDS.NONE) then
        doItemEraseAttribute(uid, ballsAttributes.seal)
    else
        doItemSetAttribute(uid, ballsAttributes.seal, seal)
    end
end

function setBallUniqueFromTm(uid, v)
    doItemSetAttribute(uid, ballsAttributes.uniqueFromTm, v and 1 or 0)
end

function setBallSketchMoves(uid, moves)
    local attr = {}

    for k, v in pairs(moves) do
        attr[#attr + 1] = v
        attr[#attr + 1] = SKETCH_MOVES_DELIMITER
    end
    attr[#attr] = nil -- Clear last delimiter

    doItemSetAttribute(uid, ballsAttributes.sketchMoves, tostring(table.concat(attr)))
end

function setBallUniqueFromTmSlot(uid, slot, v)
    doItemSetAttribute(uid, (slot == 1 and ballsAttributes.uniqueFromTmSlot1 or
            ballsAttributes.uniqueFromTmSlot2), v and 1 or 0)
end

function setBallOriginalTrainer(uid, cid)
    doItemSetAttribute(uid, ballsAttributes.originalTrainer, getPlayerGUID(cid))
end

function setBallUniqueFromTournament(uid, v)
    doItemSetAttribute(uid, ballsAttributes.uniqueFromTournament, v and 1 or 0)
end

-- Do
function doBallUpdateDescription(uid, pokemonSex, pokemonName, pokemonNickname, pokemonLevel,
pokemonExtraPoints)
    if (pokemonSex == nil) then pokemonSex = getBallPokemonSex(uid) end
    if (pokemonName == nil) then pokemonName = getBallPokemonName(uid) end
    if (pokemonNickname == nil) then pokemonNickname = getBallPokemonNickname(uid) end
    if (pokemonLevel == nil) then pokemonLevel = getBallPokemonLevel(uid) end
    if (pokemonExtraPoints == nil) then pokemonExtraPoints = getBallPokemonExtraPoints(uid) end

    local msg = {}
    msg[#msg + 1] = "Contains a "
    msg[#msg + 1] = getSexDescription(pokemonSex)
    msg[#msg + 1] = " "
    msg[#msg + 1] = pokemonName
    if (pokemonNickname and pokemonNickname ~= -1) then
        msg[#msg + 1] = "("
        msg[#msg + 1] = pokemonNickname
        msg[#msg + 1] = ")"
    end
    msg[#msg + 1] = " (Level "
    msg[#msg + 1] = pokemonLevel
    msg[#msg + 1] = ") [+"
    msg[#msg + 1] = pokemonExtraPoints
    msg[#msg + 1] = "]."

    if (getBallPokemonSpecialAbility(uid) ~= POKEMON_SPECIAL_ABILITY_IDS.NONE) then
        msg[#msg + 1] = "\nSpecial Ability: "
        msg[#msg + 1] = getPokemonSpecialAbilityName(getBallPokemonSpecialAbility(uid))
        msg[#msg + 1] = "."
    end

    local defaultMoves
    if (getBallTm(uid, 1) ~= TM_IDS.NONE) then
        defaultMoves = getPokemonDefaultSkills(pokemonName)
        msg[#msg + 1] = "\nTM: Replaced "
        msg[#msg + 1] = defaultMoves[getBallTmSlot(uid, 1)]
        msg[#msg + 1] = " by "
        msg[#msg + 1] = getTmMove(getBallTm(uid, 1))
        msg[#msg + 1] = "."
    end

    if (getBallTm(uid, 2) ~= TM_IDS.NONE) then
        defaultMoves = defaultMoves and defaultMoves or getPokemonDefaultSkills(pokemonName)
        msg[#msg + 1] = "\nTM: Replaced "
        msg[#msg + 1] = defaultMoves[getBallTmSlot(uid, 2)]
        msg[#msg + 1] = " by "
        msg[#msg + 1] = getTmMove(getBallTm(uid, 2))
        msg[#msg + 1] = "."
    end

    if (getBallEggMove(uid)) then
        if (getBallEggMoveSlot(uid)) then -- The egg move reallys exists
            defaultMoves = defaultMoves and defaultMoves or getPokemonDefaultSkills(pokemonName)
            msg[#msg + 1] = "\nEgg Move: Replaced "
            msg[#msg + 1] = defaultMoves[getBallEggMoveSlot(uid)]
            msg[#msg + 1] = " by "

        else -- The egg move was removed
            msg[#msg + 1] = "\nEgg Move REMOVED: "
        end

        msg[#msg + 1] = getBallEggMove(uid)
        msg[#msg + 1] = "."
    end

    if (getBallSeal(uid) ~= BALL_SEAL_IDS.NONE) then
        msg[#msg + 1] = "\nSeal: "
        msg[#msg + 1] = getItemNameById(getBallSealItemid(getBallSeal(uid)))
        msg[#msg + 1] = "."
    end

    if (getBallHeld(uid)) then
        msg[#msg + 1] = "\nHeld Item: "
        msg[#msg + 1] = PokemonHeldItem.getHeldName(getBallHeld(uid), uid)
        msg[#msg + 1] = "."
    end

    doItemSetSpecialDescription(uid, table.concat(msg))
end

function doBallHeal(cid, ball)
    setBallPokemonLastHp(ball.uid, HEALTH_MAX)
    setBallPokemonEnergy(ball.uid, ENERGY_MAX)
    setBallStatsSleep(ball.uid, false)
    setBallStatsPoison(ball.uid, false)
    setBallStatsBadPoison(ball.uid, false)
    setBallStatsBurn(ball.uid, false)
    setBallStatsConfuse(ball.uid, false)
    setBallStatsLowAccuracy(ball.uid, false)
    setBallStatsParalyzed(ball.uid, false)
    setBallPokemonLastHpPercent(ball.uid, 100)
    doBallResetAllCooldowns(cid, ball.uid)
    doTransformItem(ball.uid, balls[ballsNames[ball.itemid]].charged)
    doPlayerSendPokemonWindowUpdatePokemonIcon(cid, getFastcallNumber(ball.uid), 0, "100%")
end

-- Is
function isBall(itemid)
    return ballsNames[itemid] ~= nil
end

function isBallWithPokemon(uid)
    local ballPokemonName = getBallPokemonName(uid)
    return ballPokemonName ~= nil and ballPokemonName ~= -1
end

function isBallWithPokemonByBallId(itemId)
    local ballName = ballsNames[itemId]
    if (ballName) then
        return itemId ~= balls[ballName].empty -- is a ball and not is empty will return true
    end
    return false
end

-- ...
function doCreatePokemonBall(toPlayer, ball, pokemonName, pokemonLevel, pokemonSex, pokemonNickname,
pokemonExtraPoints, pokemonOwner, forceToDepot, pokemonLastHP, pokemonExp, specialAbility, tm1, tm1Slot,
tm2, tm2Slot, ballSeal, depotable, attributesBlob, beforeDepotFunction, hideMessages)
    -- attributesBlob = table{column = resultColumn, result = resultId}
    -- When attributesBlob exists, all others variable set attributes are ignored
    ball = doCreateItemEx((isString(ball) and balls[ball].charged or ball), 1)

    if (ball) then
        if (attributesBlob) then
            doItemLoadAttributes(ball, attributesBlob.column, attributesBlob.result)
            pokemonName = getBallPokemonName(ball) -- We need this to use on result message
        else
            if (not pokemonExp) then pokemonExp = getExperienceForLevel(pokemonLevel) end
            if (not specialAbility) then specialAbility = POKEMON_SPECIAL_ABILITY_IDS.NONE end
            if (not tm1) then tm1 = TM_IDS.NONE end
            if (not tm1Slot) then tm1Slot = 0 end
            if (not tm2) then tm2 = TM_IDS.NONE end
            if (not tm2Slot) then tm2Slot = 0 end
            if (not ballSeal) then ballSeal = BALL_SEAL_IDS.NONE end
            if (depotable == nil) then depotable = true end -- If can go to depot

            if (not pokemonSex) then
                local mTypeSex = getMonsterInfo(pokemonName).sex
                pokemonSex = mTypeSex == -1 and getRandom(POKEMON_SEX_FEMALE, POKEMON_SEX_MALE) or mTypeSex
            end

            setBallPokemonName(ball, pokemonName)
            setBallPokemonExp(ball, pokemonExp)
            setBallPokemonLevel(ball, pokemonLevel)
            setBallPokemonEnergy(ball, getPokemonBaseEnergy(pokemonName))
            setBallPokemonMaxEnergy(ball, getPokemonBaseEnergy(pokemonName) + (POKEMON_GAIN_ENERGY * pokemonLevel))
            setBallPokemonSex(ball, pokemonSex)
            setBallPokemonExtraPoints(ball, pokemonExtraPoints)
            setBallPokemonSpecialAbility(ball, specialAbility)
            setBallSeal(ball, ballSeal)
            setBallPokemonLastHp(ball, pokemonLastHP and pokemonLastHP or HEALTH_MAX)
            setBallPokemonEnergy(ball, ENERGY_MAX)

            if (tm1 ~= TM_IDS.NONE) then
                setBallTm(ball, 1, tm1Slot, tm1)
            end

            if (tm2 ~= TM_IDS.NONE) then
                setBallTm(ball, 2, tm2Slot, tm2)
            end

            if (isString(pokemonNickname) and pokemonNickname ~= "") then
                setBallPokemonNickname(ball, pokemonNickname, false)
            end

            if (pokemonOwner) then
                setItemUniqueOwner(ball, pokemonOwner)
            end
        end

        doBallUpdateDescription(ball, pokemonSex, pokemonName, pokemonNickname, pokemonLevel,
            pokemonExtraPoints)

        if (beforeDepotFunction) then
            beforeDepotFunction(ball)
        end

        if (forceToDepot) then
            if (not doPlayerAddDepotItem(toPlayer, 0, ball, true) and not doPlayerAddDepotItem(toPlayer, 0, ball)) then
                log(LOG_TYPES.ERROR, "doCreatePokemonBall - Can't send to depot[1].", getCreatureName(toPlayer), ball,
                    pokemonName, pokemonLevel, pokemonSex, pokemonNickname, pokemonExtraPoints, pokemonOwner,
                    forceToDepot, pokemonLastHP, pokemonExp, specialAbility, tm1, tm1Slot, tm2, tm2Slot, ballSeal,
                    depotable, attributesBlob, beforeDepotFunction)
            end

            doPlayerSendTextMessage(toPlayer, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(toPlayer, "Congratulations! You received %s, this ball will be teleported directly to the pokemon center."), getMonsterInfo(pokemonName).description))


        elseif (getPlayerFreeCap(toPlayer) < 1) then
            if (not depotable) then
                return nil
            end

            if (not doPlayerAddDepotItem(toPlayer, 0, ball, true) and not doPlayerAddDepotItem(toPlayer, 0, ball)) then
                log(LOG_TYPES.ERROR, "doCreatePokemonBall - Can't send to depot[2].", getCreatureName(toPlayer), ball,
                    pokemonName, pokemonLevel, pokemonSex, pokemonNickname, pokemonExtraPoints, pokemonOwner,
                    forceToDepot, pokemonLastHP, pokemonExp, specialAbility, tm1, tm1Slot, tm2, tm2Slot, ballSeal,
                    depotable, attributesBlob, beforeDepotFunction)
            end

            if (not hideMessages) then
                doPlayerSendTextMessage(toPlayer, MESSAGE_STATUS_CONSOLE_BLUE, "You're already carrying six Pokemon, this ball will be teleported to the Pokemon Center.")
            end

        else
            local backpack = getPlayerSlotItem(toPlayer, PLAYER_SLOT_BACKPACK)
            if (not isContainer(backpack.uid) or doAddContainerItemEx(backpack.uid, ball) ~= RETURNVALUE_NOERROR) then
                if (not depotable) then
                    return nil
                end

                if (not doPlayerAddDepotItem(toPlayer, 0, ball, true) and not doPlayerAddDepotItem(toPlayer, 0, ball)) then
                    log(LOG_TYPES.ERROR, "doCreatePokemonBall - Can't send to depot[3].", getCreatureName(toPlayer), ball,
                        pokemonName, pokemonLevel, pokemonSex, pokemonNickname, pokemonExtraPoints, pokemonOwner,
                        forceToDepot, pokemonLastHP, pokemonExp, specialAbility, tm1, tm1Slot, tm2, tm2Slot, ballSeal,
                        depotable, attributesBlob, beforeDepotFunction)
                end

                if (not hideMessages) then
                    doPlayerSendTextMessage(toPlayer, MESSAGE_STATUS_CONSOLE_BLUE,
                        "A Pokemon ball could not go to your backpack and will be teleported to the Pokemon Center.")
                end

            else
                if (not hideMessages) then
                    doPlayerSendTextMessage(toPlayer, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(toPlayer, "You received %s."), getMonsterInfo(pokemonName).description))
                end
            end
            --doPlayerAddItemEx(toPlayer, ball, true)
        end

    else
        log(LOG_TYPES.ERROR, "doCreatePokemonBall - Can't create a ball.", getCreatureName(toPlayer), ball,
            pokemonName, pokemonLevel, pokemonSex, pokemonNickname, pokemonExtraPoints, pokemonOwner,
            forceToDepot, pokemonLastHP, pokemonExp, specialAbility, tm1, tm1Slot, tm2, tm2Slot, ballSeal,
            depotable, attributesBlob, beforeDepotFunction)
    end

    return ball
end

function doBallSaveStats(pokemon, ball)
    setBallStatsSleep(ball, getCreatureStatus(pokemon, CREATURE_STATUS_SLEEP))
    setBallStatsConfuse(ball, getCreatureStatus(pokemon, CREATURE_STATUS_CONFUSION))
    setBallStatsLowAccuracy(ball, getCreatureStatus(pokemon, CREATURE_STATUS_LOWACCURACY))
    setBallStatsParalyzed(ball, getCreatureStatus(pokemon, CREATURE_STATUS_PARALYSIS))

    if (getCreatureStatus(pokemon, CREATURE_STATUS_POISON)) then
        setBallStatsPoison(ball, true)
        setBallStatsPoisonDamage(ball, getPokemonPoisonDamage(pokemon))
    else
        setBallStatsPoison(ball, false)
    end

    if (getCreatureStatus(pokemon, CREATURE_STATUS_BURN)) then
        setBallStatsBurn(ball, true)
        setBallStatsBurnDamage(ball, getPokemonBurnDamage(pokemon))
    else
        setBallStatsBurn(ball, false)
    end

    if (getCreatureStatus(pokemon, CREATURE_STATUS_BADPOISON)) then
        setBallStatsBadPoison(ball, true)
        setBallStatsBadPoisonDamage(ball, getPokemonBadPoisonDamage(pokemon))
    else
        setBallStatsBadPoison(ball, false)
    end

    setBallPokemonLastHp(ball, getCreatureHealth(pokemon))
    setBallPokemonEnergy(ball, getCreatureMana(getCreatureMaster(pokemon)))

    local currentHpPercent, textColor = math.round(getCreatureHealth(pokemon) / getCreatureMaxHealth(pokemon) * 100), 2
    if (currentHpPercent >= 80) then
        textColor = 0
    elseif (currentHpPercent >= 40) then
        textColor = 1
    end

    setBallPokemonLastHpPercent(ball, currentHpPercent)
    doPlayerSendPokemonWindowUpdatePokemonIcon(getCreatureMaster(pokemon), getFastcallNumber(ball), textColor, tostring(currentHpPercent) .. "%")
end

function doPokemonUpdateStats(pokemon, ball)
    if (isCreature(pokemon) and ball ~= nil and
            not doPokemonSpecialAbilityCheck(pokemon, POKEMON_SPECIAL_ABILITY_IDS.NATURAL_CURE, nil)) then
        local sleep = getBallStatsSleep(ball)
        if (sleep ~= nil and sleep > 0) then
            doCreatureAddStatus(pokemon, CREATURE_STATUS_SLEEP)
        end

        local confuse = getBallStatsConfuse(ball)
        if (confuse ~= nil and confuse > 0) then
            doCreatureAddStatus(pokemon, CREATURE_STATUS_CONFUSION)
        end

        local lowAccuracy = getBallStatsLowAccuracy(ball)
        if (lowAccuracy ~= nil and lowAccuracy > 0) then
            doCreatureAddStatus(pokemon, CREATURE_STATUS_LOWACCURACY)
        end

        local paralyzed = getBallStatsParalyzed(ball)
        if (paralyzed ~= nil and paralyzed > 0) then
            doCreatureAddStatus(pokemon, CREATURE_STATUS_PARALYSIS)
        end

        local poison = getBallStatsPoison(ball)
        if (poison ~= nil and poison > 0) then
            doCreaturePoison(pokemon, getBallStatsPoisonDamage(ball))
        end

        local burn = getBallStatsBurn(ball)
        if (burn ~= nil and burn > 0) then
            doCreatureBurn(pokemon, getBallStatsBurnDamage(ball))
        end

        local badPoison = getBallStatsBadPoison(ball)
        if (badPoison ~= nil and badPoison > 0) then
            doCreatureBadPoison(pokemon, getBallStatsBadPoisonDamage(ball))
        end
    end
end

function getBallTransformMemory(uid, number)
    if (number == 1) then
        return getItemAttribute(uid, ballsAttributes.transformMemory1)
    elseif (number == 2) then
        return getItemAttribute(uid, ballsAttributes.transformMemory2)
    elseif (number == 3) then
        return getItemAttribute(uid, ballsAttributes.transformMemory3)
    elseif (number == 4) then
        return getItemAttribute(uid, ballsAttributes.transformMemory4)
    end
    return nil
end

function setBallTransformMemory(uid, number, value)
    if (number == 1) then
        doItemSetAttribute(uid, ballsAttributes.transformMemory1, value)
    elseif (number == 2) then
        doItemSetAttribute(uid, ballsAttributes.transformMemory2, value)
    elseif (number == 3) then
        doItemSetAttribute(uid, ballsAttributes.transformMemory3, value)
    elseif (number == 4) then
        doItemSetAttribute(uid, ballsAttributes.transformMemory4, value)
    end
end

function doBallSaveTransformMemory(uid, lastTransform)
    local currentMemories = {}
    for key = 1, POKEMON_TRANSFORM_MEMORY_MAX do
        local memory = getBallTransformMemory(uid, key)
        if (memory and lastTransform == memory) then -- This Pokemon already have this memory, lets skip
            return
        end

        currentMemories[key] = memory and memory or EMPTY_STORAGE -- We need to set the nil value to EMPTY_STORAGE, otherwise the next pairs wont ocurr
    end

    local savingMemory = lastTransform
    for key, memory in pairs(currentMemories) do
        if (savingMemory == EMPTY_STORAGE) then -- If we didnt have more memory to save
            return
        end

        local replacedMemory = memory
        setBallTransformMemory(uid, key, savingMemory)
        savingMemory = replacedMemory
    end
end

function getBallCurrentTransform(uid)
    return getItemAttribute(uid, ballsAttributes.currentTransform)
end

function setBallCurrentTransform(uid, value)
    doItemSetAttribute(uid, ballsAttributes.currentTransform, value)
end

function getBallTotalVitamins(uid)
    local r = getItemAttribute(uid, ballsAttributes.totalVitamins)
    return r and r or 0
end

function setBallTotalVitamins(uid, value, reset)
    if (reset) then
        doItemEraseAttribute(uid, ballsAttributes.totalVitamins)
    else
        doItemSetAttribute(uid, ballsAttributes.totalVitamins, value)
    end
end

function getBallVitaminHpUp(uid)
    local r = getItemAttribute(uid, ballsAttributes.vitaminHpUp)
    return r and r or 0
end

function setBallVitaminHpUp(uid, value, reset)
    if (reset) then
        doItemEraseAttribute(uid, ballsAttributes.vitaminHpUp)
    else
        doItemSetAttribute(uid, ballsAttributes.vitaminHpUp, value)
    end
end

function getBallVitaminProtein(uid)
    local r = getItemAttribute(uid, ballsAttributes.vitaminProtein)
    return r and r or 0
end

function setBallVitaminProtein(uid, value, reset)
    if (reset) then
        doItemEraseAttribute(uid, ballsAttributes.vitaminProtein)
    else
        doItemSetAttribute(uid, ballsAttributes.vitaminProtein, value)
    end
end

function getBallVitaminIron(uid)
    local r = getItemAttribute(uid, ballsAttributes.vitaminIron)
    return r and r or 0
end

function setBallVitaminIron(uid, value, reset)
    if (reset) then
        doItemEraseAttribute(uid, ballsAttributes.vitaminIron)
    else
        doItemSetAttribute(uid, ballsAttributes.vitaminIron, value)
    end
end

function getBallVitaminCalcium(uid)
    local r = getItemAttribute(uid, ballsAttributes.vitaminCalcium)
    return r and r or 0
end

function setBallVitaminCalcium(uid, value, reset)
    if (reset) then
        doItemEraseAttribute(uid, ballsAttributes.vitaminCalcium)
    else
        doItemSetAttribute(uid, ballsAttributes.vitaminCalcium, value)
    end
end

function getBallVitaminZinc(uid)
    local r = getItemAttribute(uid, ballsAttributes.vitaminZinc)
    return r and r or 0
end

function setBallVitaminZinc(uid, value, reset)
    if (reset) then
        doItemEraseAttribute(uid, ballsAttributes.vitaminZinc)
    else
        doItemSetAttribute(uid, ballsAttributes.vitaminZinc, value)
    end
end

function getBallVitaminCarbos(uid)
    local r = getItemAttribute(uid, ballsAttributes.vitaminCarbos)
    return r and r or 0
end

function setBallVitaminCarbos(uid, value, reset)
    if (reset) then
        doItemEraseAttribute(uid, ballsAttributes.vitaminCarbos)
    else
        doItemSetAttribute(uid, ballsAttributes.vitaminCarbos, value)
    end
end

function getBallVitaminPPUp(uid)
    local r = getItemAttribute(uid, ballsAttributes.vitaminPPUp)
    return r and r or 0
end

function setBallVitaminPPUp(uid, value, reset)
    if (reset) then
        doItemEraseAttribute(uid, ballsAttributes.vitaminPPUp)
    else
        doItemSetAttribute(uid, ballsAttributes.vitaminPPUp, value)
    end
end

function getBallVitaminPPMax(uid)
    local r = getItemAttribute(uid, ballsAttributes.vitaminPPMax)
    return r and r or 0
end

function setBallVitaminPPMax(uid, value, reset)
    if (reset) then
        doItemEraseAttribute(uid, ballsAttributes.vitaminPPMax)
    else
        doItemSetAttribute(uid, ballsAttributes.vitaminPPMax, value)
    end
end

function setBallEggMove(uid, replacingSlot, eggMove, remove)
    if (remove) then
        doItemEraseAttribute(uid, ballsAttributes.eggMoveSlot)
    else
        doItemSetAttribute(uid, ballsAttributes.eggMoveSlot, replacingSlot)
        doItemSetAttribute(uid, ballsAttributes.eggMove, eggMove)
        setBallReceivedEggMove(uid, true)
    end
end

function getBallEggMove(uid)
    return getItemAttribute(uid, ballsAttributes.eggMove)
end

function getBallEggMoveSlot(uid)
    return getItemAttribute(uid, ballsAttributes.eggMoveSlot)
end

function getBallHeld(uid)
    return getItemAttribute(uid, ballsAttributes.held)
end

function setBallHeld(uid, value, reset)
    if (reset) then
        doItemEraseAttribute(uid, ballsAttributes.held)
    else
        doItemSetAttribute(uid, ballsAttributes.held, value)
    end
end

function getBallHeldLevel(uid)
    local r = getItemAttribute(uid, ballsAttributes.heldLevel)
    return r and r or 1
end

function setBallHeldLevel(uid, value)
    doItemSetAttribute(uid, ballsAttributes.heldLevel, value)
end

function getBallHeldLevel(uid)
    local r = getItemAttribute(uid, ballsAttributes.heldLevel)
    return r and r or 1
end

function setBallHeldLevel(uid, value)
    doItemSetAttribute(uid, ballsAttributes.heldLevel, value)
end

function getBallHeldExperience(uid)
    local r = getItemAttribute(uid, ballsAttributes.heldExperience)
    return r and r or 1
end

function setBallHeldExperience(uid, value)
    doItemSetAttribute(uid, ballsAttributes.heldExperience, value)
end

function getBallIsNotPokemonFromEgg(uid)
    return getItemAttribute(uid, ballsAttributes.isNotPokemonFromEgg)
end

function setBallIsNotPokemonFromEgg(uid, value)
    doItemSetAttribute(uid, ballsAttributes.isNotPokemonFromEgg, value)
end

function isBallPokemonFromEgg(uid)
    return getBallPokemonExtraPoints(uid) >= getBallPokemonLevel(uid) and not getBallIsNotPokemonFromEgg(uid)
end

function getBallReceivedEggMove(uid)
    return getItemAttribute(uid, ballsAttributes.receivedEggMove)
end

function setBallReceivedEggMove(uid, value)
    doItemSetAttribute(uid, ballsAttributes.receivedEggMove, value)
end

function getBallEggMoveRegenerateEnabled(uid)
    local r = getItemAttribute(uid, ballsAttributes.eggMoveRegenerateEnabled)
    return r and r > 0 or false
end

function setBallEggMoveRegenerateEnabled(uid, value)
    doItemSetAttribute(uid, ballsAttributes.eggMoveRegenerateEnabled, value and 1 or 0)
end

function getBallLastEggMoveRegenerated(uid)
    return getItemAttribute(uid, ballsAttributes.lastEggMoveRegenerated)
end

function setBallLastEggMoveRegenerated(uid, value)
    doItemSetAttribute(uid, ballsAttributes.lastEggMoveRegenerated, value)
end

function getBallLastEggMoveGenerationTry(uid)
    local r = getItemAttribute(uid, ballsAttributes.lastEggMoveGenerationTry)
    return r and r or 0
end

function setBallLastEggMoveGenerationTry(uid, value)
    doItemSetAttribute(uid, ballsAttributes.lastEggMoveGenerationTry, value)
end

function getBallLastEggMoveRegenerationTry(uid)
    local r = getItemAttribute(uid, ballsAttributes.lastEggMoveRegenerationTry)
    return r and r or 0
end

function setBallLastEggMoveRegenerationTry(uid, value)
    doItemSetAttribute(uid, ballsAttributes.lastEggMoveRegenerationTry, value)
end

function setBallFromNpc(uid, value)
    doItemSetAttribute(uid, ballsAttributes.fromNpc, value and 1 or 0)
end

function getBallFromNpc(uid)
    local r = getItemAttribute(uid, ballsAttributes.fromNpc)
    return r and tonumber(r) > 0
end

function isEpicBall(itemId)
    return itemId == balls["epic"].charged or itemId == balls["epic"].discharged or itemId == balls["epic"].inUse
end

function getBallLastLollipopReceived(uid)
    local r = getItemAttribute(uid, ballsAttributes.lastLollipopReceived)
    return r and r or 0
end

function setBallLastLollipopReceived(uid, value)
    doItemSetAttribute(uid, ballsAttributes.lastLollipopReceived, value)
end

function getBallHeldVariables(uid)
    local r = getItemAttribute(uid, ballsAttributes.heldVariables)
    return r and r or false
end

function setBallHeldVariables(uid, value)
    doItemSetAttribute(uid, ballsAttributes.heldVariables, value)
end

function setBallEggMovesRegenerated(uid, moves)
    if (not moves) then
        return doItemEraseAttribute(uid, ballsAttributes.eggMovesRegenerated)
    end

    local attr = {}
    for k, v in pairs(moves) do
        attr[#attr + 1] = v
        attr[#attr + 1] = SKETCH_MOVES_DELIMITER
    end
    attr[#attr] = nil -- Clear last delimiter

    doItemSetAttribute(uid, ballsAttributes.eggMovesRegenerated, tostring(table.concat(attr)))
end

function getBallRegeneratedEggMoves(uid)
    local r = {}

    local attr = getItemAttribute(uid, ballsAttributes.eggMovesRegenerated)
    if (not attr) then
        return r
    end

    for k, v in pairs(string.explode(attr, SKETCH_MOVES_DELIMITER)) do
        r[#r + 1] = v
    end

    return r
end

function getBallAddons(uid)
    local r = {}

    local attr = getItemAttribute(uid, ballsAttributes.addons)
    if (not attr) then
        return r
    end

    attr = tostring(attr)
    for k, v in pairs(string.explode(attr, SKETCH_MOVES_DELIMITER)) do
        r[#r + 1] = tonumber(v)
    end

    return r
end

function doBallAddAddon(uid, addonId)
    local addons = getBallAddons(uid)
    addons[#addons + 1] = addonId

    local attr = {}
    for k, v in pairs(addons) do
        attr[#attr + 1] = v
        attr[#attr + 1] = SKETCH_MOVES_DELIMITER
    end
    attr[#attr] = nil -- Clear last delimiter

    doItemSetAttribute(uid, ballsAttributes.addons, tostring(table.concat(attr)))
end

function doBallSaveAddon(uid, outfit, reset)
    if (reset) then
        doItemEraseAttribute(uid, ballsAttributes.addonLookType)
        doItemEraseAttribute(uid, ballsAttributes.addonLookHead)
        doItemEraseAttribute(uid, ballsAttributes.addonLookBody)
        doItemEraseAttribute(uid, ballsAttributes.addonLookLegs)
        doItemEraseAttribute(uid, ballsAttributes.addonLookFeet)
    else
        doItemSetAttribute(uid, ballsAttributes.addonLookType, outfit.lookType)
        doItemSetAttribute(uid, ballsAttributes.addonLookHead, outfit.lookHead)
        doItemSetAttribute(uid, ballsAttributes.addonLookBody, outfit.lookBody)
        doItemSetAttribute(uid, ballsAttributes.addonLookLegs, outfit.lookLegs)
        doItemSetAttribute(uid, ballsAttributes.addonLookFeet, outfit.lookFeet)
    end
end

function getBallCurrentAddon(uid)
    local type = getItemAttribute(uid, ballsAttributes.addonLookType)
    if (not type) then
        return nil
    end

    return {
        lookType = type,
        lookHead = getItemAttribute(uid, ballsAttributes.addonLookHead),
        lookBody = getItemAttribute(uid, ballsAttributes.addonLookBody),
        lookLegs = getItemAttribute(uid, ballsAttributes.addonLookLegs),
        lookFeet = getItemAttribute(uid, ballsAttributes.addonLookFeet)
    }
end