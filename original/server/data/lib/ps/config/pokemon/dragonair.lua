POKEMON["Dragonair"] = {
    pTypes = { ELEMENT_DRAGON },
    dexStorage = 10148,
    atk = 84,
    def = 65,
    spAtk = 70,
    spDef = 70,
    energy = 100,
    chance = 500,
    portrait = 12849,
    dexPortrait = 13649,
    fastcallPortrait = 10782,
    catchStorage = 16148,
    evolutions = { { name = "Dragonite", requiredLevel = 50 } },
    description = "It is said to live in seas and lakes. Even though it has no wings, it has been seen flying occasionally.",
    skills = { "Tackle", 1, "Slam", 5, "Twister", 10, "Aqua Tail", 15, "Thunder Wave", 20, "Dragon Tail", 25, "Agility", 30, "Outrage", 40, "Hyper Beam", 45 },
    abilities = { POKEMON_ABILITIES.WATERFALL, "Fly", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_WATER_1, POKEMON_EGG_GROUP_DRAGON },
    eggId = 14047,
    eggChance = 1,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.SHED_SKIN },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.FLAMETHROWER, TM_IDS.WATER_PULSE, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.RAGE, TM_IDS.DRAGON_RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.SUBSTITUTE, TM_IDS.HAIL, TM_IDS.LIGHT_SCREEN, TM_IDS.SAFEGUARD, TM_IDS.SHOCK_WAVE },
    eggMoves = { "Aqua Jet", "Dragon Breath", "Dragon Dance", "Dragon Pulse", "Dragon Rush", "Extreme Speed", "Haze", "Iron Tail", "Mist", "Supersonic", "Water Pulse" }
}

POKEMON["RC Dragonair"] = table.deepcopy(POKEMON["Dragonair"])
POKEMON["RC Dragonair"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Dragonair"].blockTransform = true