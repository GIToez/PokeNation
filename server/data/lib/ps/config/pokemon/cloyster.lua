POKEMON["Cloyster"] = {
    pTypes = { ELEMENT_WATER, ELEMENT_ICE },
    dexStorage = 10091,
    atk = 95,
    def = 180,
    spAtk = 85,
    spDef = 45,
    energy = 100,
    chance = 500,
    portrait = 12792,
    dexPortrait = 13592,
    fastcallPortrait = 10725,
    catchStorage = 16091,
    evolutions = {},
    description = "Its shell is extremely hard. It cannot be shattered, even with a bomb. The shell opens only when it is attacking.",
    skills = { "Tackle", 1, "Headbutt", 5, "Supersonic", 10, "Icicle Spear", 15, "Razor Shell", 20, "Icy Wind", 25, "Protect", 30, "Spike Cannon", 40, "Aurora Beam", 45, "Frost Breath", 50, "Icicle Crash", 55, "Blizzard", 60, "Ice Beam", 65, "Hydro Pump", 70, "Toxic Spikes", 75 },
    abilities = { "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_WATER_3 },
    eggId = 14016,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.SHELL_ARMOR, POKEMON_SPECIAL_ABILITY_IDS.SKILL_LINK },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.AVALANCHE, TM_IDS.POISON_JAB, TM_IDS.WATER_PULSE, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SELFDESTRUCT, TM_IDS.SWIFT, TM_IDS.REST, TM_IDS.EXPLOSION, TM_IDS.TRI_ATTACK, TM_IDS.SUBSTITUTE, TM_IDS.HAIL },
    eggMoves = { "Aqua Ring", "Avalanche", "Barrier", "Bubblebeam", "Icicle Spear", "Mud Shot", "Rapid Spin", "Rock Blast", "Screech", "Take Down", "Twineedle", "Water Pulse" }
}

POKEMON["RC Cloyster"] = table.deepcopy(POKEMON["Cloyster"])
POKEMON["RC Cloyster"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Cloyster"].blockTransform = true