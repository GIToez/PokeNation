POKEMON["Clefable"] = {
    pTypes = { ELEMENT_FAIRY },
    dexStorage = 10036,
    atk = 70,
    def = 73,
    spAtk = 95,
    spDef = 90,
    energy = 100,
    chance = 400,
    portrait = 12737,
    dexPortrait = 13537,
    fastcallPortrait = 10670,
    catchStorage = 16036,
    evolutions = {},
    description = "It has an acute sense of hearing. It can easily hear a pin being dropped nearly 1,100 yards away.",
    skills = { "Tackle", 1, "Pound", 5, "Double Slap", 10, "Sing", 15, "Magical Leaf", 20, "Metronome", 25, "Moonlight", 30, "Disarming Voice", 40, "Body Slam", 45, "Defense Curl", 50, "Wake-Up Slap", 55, "Meteor Mash", 60, "Moonblast", 65, "Healing Wish", 70 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Flash", "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FAIRY },
    eggId = 13991,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.CUTE_CHARM, POKEMON_SPECIAL_ABILITY_IDS.MAGIC_GUARD },
    learnableTms = { TM_IDS.DRAIN_PUNCH, TM_IDS.FLAMETHROWER, TM_IDS.WATER_PULSE, TM_IDS.NIGHTMARE, TM_IDS.THUNDER_PUNCH, TM_IDS.DEFENSE_CURL, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.DREAM_EATER, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.SOLAR_BEAM, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.PSYWAVE, TM_IDS.TRI_ATTACK, TM_IDS.SUBSTITUTE },
    eggMoves = { "Amnesia", "Aromatherapy", "Belly Drum", "Covet", "Fake Tears", "Heal Pulse", "Metronome", "Mimic", "Misty Terrain", "Present", "Splash", "Stored Power", "Tickle", "Wish" }
}

POKEMON["RC Clefable"] = table.deepcopy(POKEMON["Clefable"])
POKEMON["RC Clefable"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Clefable"].blockTransform = true