POKEMON["Wigglytuff"] = {
    pTypes = { ELEMENT_NORMAL, ELEMENT_FAIRY },
    dexStorage = 10040,
    atk = 70,
    def = 45,
    spAtk = 85,
    spDef = 50,
    energy = 100,
    chance = 350,
    portrait = 12741,
    dexPortrait = 13541,
    fastcallPortrait = 10674,
    catchStorage = 16040,
    evolutions = {},
    description = "Its fur is extremely fine, dense, and supple. The exquisitely pleasant fur conveys an image of luxury.",
    skills = { "Tackle", 1, "Pound", 5, "Sing", 10, "Body Slam", 15, "Disarming Voice", 20, "Wake-Up Slap", 25, "Rest", 30, "Hyper Voice", 40, "Defense Curl", 45, "Play Rough", 50, "Double-Edge", 55, "Mimic", 60, "Disable", 65 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Flash", "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FAIRY },
    eggId = 13993,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.COMPETITIVE, POKEMON_SPECIAL_ABILITY_IDS.CUTE_CHARM },
    learnableTms = { TM_IDS.DRAIN_PUNCH, TM_IDS.FLAMETHROWER, TM_IDS.WATER_PULSE, TM_IDS.NIGHTMARE, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.DEFENSE_CURL, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.DREAM_EATER, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.SOLAR_BEAM, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.PSYWAVE, TM_IDS.TRI_ATTACK, TM_IDS.SUBSTITUTE },
    eggMoves = { "Captivate", "Covet", "Fake Tears", "Faint Attack", "Gravity", "Heal Pulse", "Last Resort", "Misty Terrain", "Perish Song", "Present", "Punishment", "Sleep Talk", "Wish" }
}

POKEMON["RC Wigglytuff"] = table.deepcopy(POKEMON["Wigglytuff"])
POKEMON["RC Wigglytuff"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Wigglytuff"].blockTransform = true

POKEMON["Cloned Wigglytuff"] = table.deepcopy(POKEMON["Wigglytuff"])
POKEMON["Cloned Wigglytuff"].blockTransform = true