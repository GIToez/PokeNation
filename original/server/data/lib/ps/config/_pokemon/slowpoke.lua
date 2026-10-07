POKEMON["Slowpoke"] = {
    pTypes = { ELEMENT_WATER, ELEMENT_PSYCHIC },
    dexStorage = 10079,
    atk = 65,
    def = 65,
    spAtk = 40,
    spDef = 40,
    energy = 100,
    chance = 60,
    portrait = 12780,
    dexPortrait = 13580,
    fastcallPortrait = 10713,
    catchStorage = 16079,
    evolutions = {
        { name = "Slowbro", requiredLevel = 35, requiredItems = { ITEMS.WATER_STONE } },
        { name = "Slowking", requiredLevel = 35, requiredItems = { ITEMS.KINGS_ROCK } }
    },
    description = "It is always vacantly lost in thought, but no one knows what it is thinking about. It is good at fishing with its tail.",
    skills = { "Tackle", 1, "Water Gun", 5, "Confusion", 10, "Disable", 15, "Headbutt", 20, "Water Pulse", 25, "Amnesia", 30 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Headbutt", "Rock Smash", "Flash" },
    eggGroup = { POKEMON_EGG_GROUP_MONSTER, POKEMON_EGG_GROUP_WATER_1 },
    eggId = 14010,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.OBLIVIOUS, POKEMON_SPECIAL_ABILITY_IDS.OWN_TEMPO },
    learnableTms = { TM_IDS.FLAMETHROWER, TM_IDS.WATER_PULSE, TM_IDS.NIGHTMARE, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DREAM_EATER, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.PAY_DAY, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.PSYWAVE, TM_IDS.TRI_ATTACK, TM_IDS.SUBSTITUTE },
    eggMoves = { "Belch", "Belly Drum", "Block", "Future Sight", "Me First", "Mud Sport", "Sleep Talk", "Snore", "Stomp", "Wonder Room", "Zen Headbutt" }
}