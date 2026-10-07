POKEMON["Golduck"] = {
    pTypes = { ELEMENT_WATER },
    dexStorage = 10055,
    atk = 82,
    def = 78,
    spAtk = 95,
    spDef = 80,
    energy = 100,
    chance = 400,
    portrait = 12756,
    dexPortrait = 13556,
    fastcallPortrait = 10689,
    catchStorage = 16055,
    evolutions = {},
    description = "The forelegs are webbed, helping to make it an adept swimmer. It can be seen swimming elegantly in lakes, etc.",
    skills = { "Tackle", 1, "Scratch", 5, "Water Gun", 10, "Confusion", 15, "Water Pulse", 20, "Fury Swipes", 25, "Disable", 30, "Amnesia", 40, "Psychic", 45, "Aqua Tail", 50, "Psybeam", 55, "Hydro Pump", 60, "Zen Headbutt", 65, "Future Sight", 70 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, POKEMON_ABILITIES.WATERFALL, "Surf", "Dive", "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_WATER_1, POKEMON_EGG_GROUP_FIELD },
    eggId = 14000,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.DAMP, POKEMON_SPECIAL_ABILITY_IDS.CLOUD_NINE },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.AERIAL_ACE, TM_IDS.WATER_PULSE, TM_IDS.FURY_CUTTER, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.PSYCHIC, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.PAY_DAY, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE },
    eggMoves = { "Clear Smog", "Confuse Ray", "Cross Chop", "Encore", "Foresight", "Future Sight", "Hypnosis", "Mud Bomb", "Psybeam", "Refresh", "Secret Power", "Simple Beam", "Sleep Talk", "Synchronoise", "Yawn" }
}

POKEMON["RC Golduck"] = table.deepcopy(POKEMON["Golduck"])
POKEMON["RC Golduck"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Golduck"].blockTransform = true