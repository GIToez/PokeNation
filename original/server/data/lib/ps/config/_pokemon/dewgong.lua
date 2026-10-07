POKEMON["Dewgong"] = {
    pTypes = { ELEMENT_WATER, ELEMENT_ICE },
    dexStorage = 10087,
    atk = 70,
    def = 80,
    spAtk = 70,
    spDef = 95,
    energy = 100,
    chance = 300,
    portrait = 12788,
    dexPortrait = 13588,
    fastcallPortrait = 10721,
    catchStorage = 16087,
    evolutions = {},
    description = "Its body is covered with a pure white fur. The colder the weather, the more active it becomes.",
    skills = { "Tackle", 1, "Headbutt", 5, "Icy Wind", 10, "Water Pulse", 15, "Rest", 20, "Aurora Beam", 25, "Ice Shard", 30, "Aqua Tail", 35, "Frost Breath", 45, "Ice Beam", 50, "Brine", 55, "Blizzard", 60, "Safeguard", 65 },
    abilities = { POKEMON_ABILITIES.STRENGTH, POKEMON_ABILITIES.WATERFALL, "Headbutt", "Surf", "Dive", "Rock Smash" },
    eggGroup = { POKEMON_EGG_GROUP_WATER_1, POKEMON_EGG_GROUP_FIELD },
    eggId = 14014,
    eggChance = 20,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.THICK_FAT, POKEMON_SPECIAL_ABILITY_IDS.HYDRATION },
    learnableTms = { TM_IDS.AVALANCHE, TM_IDS.WATER_PULSE, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.TOXIC, TM_IDS.HORN_DRILL, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.PAY_DAY, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE },
    eggMoves = { "Belch", "Disable", "Encore", "Entrainment", "Fake Out", "Horn Drill", "Icicle Spear", "Iron Tail", "Lick", "Perish Song", "Signal Beam", "Slam", "Sleep Talk", --[["Spit Up", "Stockpile", "Swallow",]] "Water Pulse" }
}

POKEMON["RC Dewgong"] = table.deepcopy(POKEMON["Dewgong"])
POKEMON["RC Dewgong"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Dewgong"].blockTransform = true

POKEMON["Cloned Dewgong"] = table.deepcopy(POKEMON["Dewgong"])
POKEMON["Cloned Dewgong"].blockTransform = true