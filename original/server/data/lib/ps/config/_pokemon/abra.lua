POKEMON["Abra"] = {
    pTypes = { ELEMENT_PSYCHIC },
    dexStorage = 10063,
    atk = 20,
    def = 15,
    spAtk = 105,
    spDef = 55,
    energy = 100,
    chance = 100,
    portrait = 12764,
    dexPortrait = 13564,
    fastcallPortrait = 10697,
    catchStorage = 16063,
    evolutions = { { name = "Kadabra", requiredLevel = 30 } },
    description = "It sleeps for 18 hours a day. It uses a variety of extrasensory powers even while asleep.",
    skills = { "Tackle", 1, "Confusion", 5, "Mist Ball", 10, "Calm Mind", 15, "Recover", 20, "Reflect", 25 },
    abilities = { "Blink", "Flash", "Teleport", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_HUMAN_LIKE },
    eggId = 14004,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.SYNCHRONIZE, POKEMON_SPECIAL_ABILITY_IDS.INNER_FOCUS },
    learnableTms = { TM_IDS.DRAIN_PUNCH, TM_IDS.ENERGY_BALL, TM_IDS.NIGHTMARE, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.ICE_PUNCH, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.DREAM_EATER, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.PSYWAVE, TM_IDS.TRI_ATTACK, TM_IDS.SUBSTITUTE },
    eggMoves = { "Ally Switch", "Barrier", "Encore", "Fire Punch", "Guard Split", "Guard Swap", "Ice Punch", "Knock Off", "Power Trick", "Psycho Shift", "Skill Swap", "Thunder Punch" }
}

POKEMON["RC Abra"] = table.deepcopy(POKEMON["Abra"])
POKEMON["RC Abra"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Abra"].blockTransform = true

POKEMON["Christmas Abra"] = table.deepcopy(POKEMON["Abra"])
POKEMON["Christmas Abra"].blockTransform = true
POKEMON["Christmas Abra"].evolutions = {}
POKEMON["Christmas Abra"].ignoreBallCounter = true