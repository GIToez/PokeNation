POKEMON["Poliwhirl"] = {
    pTypes = { ELEMENT_WATER },
    dexStorage = 10061,
    atk = 65,
    def = 65,
    spAtk = 50,
    spDef = 50,
    energy = 100,
    chance = 200,
    portrait = 12762,
    dexPortrait = 13562,
    fastcallPortrait = 10695,
    catchStorage = 16061,
    evolutions = {
        { name = "Poliwrath", requiredLevel = 50, requiredItems = { ITEMS.WATER_STONE } },
        { name = "Politoed", requiredLevel = 50, requiredItems = { ITEMS.KINGS_ROCK } }
    },
    description = "Its two legs are well developed. Even though it can live on the ground, it prefers living in water.",
    skills = { "Tackle", 1, "Bubble", 5, "Water Gun", 10, "Double Slap", 15, "Bubblebeam", 20, "Hypnosis", 25, "Body Slam", 35, "Mud Shot", 40, "Wake-Up Slap", 45 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, POKEMON_ABILITIES.WATERFALL, "Surf", "Dive", "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_WATER_1 },
    eggId = 14003,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.WATER_ABSORB, POKEMON_SPECIAL_ABILITY_IDS.DAMP },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.WATER_PULSE, TM_IDS.DEFENSE_CURL, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.PSYWAVE, TM_IDS.SUBSTITUTE },
    eggMoves = { "Bubblebeam", "Encore", "Endeavor", "Endure", "Haze", "Ice Ball", "Mind Reader", "Mist", "Mud Shot", "Refresh", "Splash", "Water Pulse", "Water Sport" }
}