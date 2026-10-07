POKEMON["Snorlax"] = {
    pTypes = { ELEMENT_NORMAL },
    dexStorage = 10143,
    atk = 110,
    def = 65,
    spAtk = 65,
    spDef = 110,
    energy = 100,
    chance = 800,
    portrait = 12844,
    dexPortrait = 13644,
    fastcallPortrait = 10777,
    catchStorage = 16143,
    evolutions = {},
    description = "It is not satisfied unless it eats over 880 pounds of food every day. When it is done eating, it goes promptly to sleep.",
    skills = { "Tackle", 1, "Lick", 5, "Headbutt", 10, "Body Slam", 15, "Rest", 20, "Rollout", 25, "Crunch", 30, "Amnesia", 35, "Chip Away", 40, "Defense Curl", 45, "Heavy Slam", 50, "Giga Impact", 55, "Hyper Beam", 60, "Yawn", 65 },
    abilities = { POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Headbutt", "Rock Smash", "Surf" },
    eggGroup = { POKEMON_EGG_GROUP_MONSTER },
    eggId = 14046,
    eggChance = 1,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.IMMUNITY, POKEMON_SPECIAL_ABILITY_IDS.THICK_FAT },
    learnableTms = { TM_IDS.FLAMETHROWER, TM_IDS.ROCK_TOMB, TM_IDS.WATER_PULSE, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.PAY_DAY, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.SOLAR_BEAM, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.SELFDESTRUCT, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.PSYWAVE, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE },
    eggMoves = { "After You", "Belch", "Charm", "Counter", "Curse", "Double-Edge", "Fissure", "Lick", "Natural Gift", "Pursuit", "Selfdestruct", "Whirlwind", "Zen Headbutt" }
}

POKEMON["Cloned Snorlax"] = table.deepcopy(POKEMON["Snorlax"])
POKEMON["Cloned Snorlax"].blockTransform = true