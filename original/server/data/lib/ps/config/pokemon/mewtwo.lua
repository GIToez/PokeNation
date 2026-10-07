POKEMON["Mewtwo"] = {
    pTypes = { ELEMENT_PSYCHIC },
    dexStorage = 10150,
    atk = 110,
    def = 90,
    spAtk = 154,
    spDef = 90,
    energy = 100,
    chance = 10000,
    portrait = 12851,
    dexPortrait = 13651,
    fastcallPortrait = 10784,
    catchStorage = 16150,
    evolutions = {},
    description = "A POKEMON whose genetic code was repeatedly recombined for research. It turned vicious as a result.",
    skills = { "Tackle", 1, "Confusion", 5, "Swift", 10, "Recover", 15, "Ancient Power", 20, "Amnesia", 25, "Barrier", 30, "Metronome", 35, "Psycho Cut", 40, "Safeguard", 45, "Psychic", 50, "Aura Sphere", 55, "Disable", 60, "Future Sight", 65, "Psystrike", 70 },
    abilities = { POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Find", "Flash", "Blink", "Teleport", "Fly", "RockMSmash", "Headbutt" },
    eggGroup = {},
    eggId = 0,
    eggChance = 0,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.PRESSURE },
    learnableTms = { TM_IDS.AVALANCHE, TM_IDS.POISON_JAB, TM_IDS.DRAIN_PUNCH, TM_IDS.ENERGY_BALL, TM_IDS.FLAMETHROWER, TM_IDS.AERIAL_ACE, TM_IDS.ROCK_TOMB, TM_IDS.WATER_PULSE, TM_IDS.NIGHTMARE, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.DREAM_EATER, TM_IDS.ROCK_SLIDE, TM_IDS.EARTHQUAKE, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.PAY_DAY, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.SOLAR_BEAM, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.SELFDESTRUCT, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.PSYWAVE, TM_IDS.TRI_ATTACK, TM_IDS.SUBSTITUTE, TM_IDS.FOCUS_PUNCH, TM_IDS.CALM_MIND, TM_IDS.BULK_UP, TM_IDS.LIGHT_SCREEN, TM_IDS.SAFEGUARD, TM_IDS.HAIL, TM_IDS.SHOCK_WAVE },
    blockTransform = true
}

POKEMON["Final Mewtwo"] = table.deepcopy(POKEMON["Mewtwo"])
POKEMON["Final Mewtwo"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["Final Mewtwo"].blocTraknsform = true