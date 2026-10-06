POKEMON["Clefairy"] = {
    pTypes = { ELEMENT_FAIRY },
    dexStorage = 10035,
    atk = 45,
    def = 48,
    spAtk = 60,
    spDef = 65,
    energy = 100,
    chance = 80,
    portrait = 12736,
    dexPortrait = 13536,
    fastcallPortrait = 10669,
    catchStorage = 16035,
    evolutions = { { name = "Clefable", requiredLevel = 35, requiredItems = { ITEMS.MOON_STONE } } },
    description = "Its adorable appearance makes it popular as a pet. However, it is rare and difficult to find.",
    skills = { "Tackle", 1, "Pound", 5, "Double Slap", 10, "Sing", 15, "Magical Leaf", 20, "Metronome", 25, "Moonlight", 30 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Flash", "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FAIRY },
    eggId = 13991,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.CUTE_CHARM, POKEMON_SPECIAL_ABILITY_IDS.MAGIC_GUARD },
    learnableTms = { TM_IDS.DRAIN_PUNCH, TM_IDS.FLAMETHROWER, TM_IDS.WATER_PULSE, TM_IDS.NIGHTMARE, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.DEFENSE_CURL, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.DREAM_EATER, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.SOLAR_BEAM, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.PSYWAVE, TM_IDS.TRI_ATTACK, TM_IDS.SUBSTITUTE, TM_IDS.FOCUS_PUNCH, TM_IDS.CALM_MIND, TM_IDS.LIGHT_SCREEN, TM_IDS.SAFEGUARD, TM_IDS.BRICK_BREAK, TM_IDS.SHOCK_WAVE },
    eggMoves = { "Amnesia", "Aromatherapy", "Belly Drum", "Covet", "Fake Tears", "Heal Pulse", "Metronome", "Mimic", "Misty Terrain", "Present", "Splash", "Stored Power", "Tickle", "Wish" }
}

POKEMON["RC Clefairy"] = table.deepcopy(POKEMON["Clefairy"])
POKEMON["RC Clefairy"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Clefairy"].blockTransform = true