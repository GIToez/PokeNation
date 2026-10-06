POKEMON["Dratini"] = {
    pTypes = { ELEMENT_DRAGON },
    dexStorage = 10147,
    atk = 64,
    def = 45,
    spAtk = 50,
    spDef = 50,
    energy = 100,
    chance = 500,
    portrait = 12848,
    dexPortrait = 13648,
    fastcallPortrait = 10781,
    catchStorage = 16147,
    evolutions = { { name = "Dragonair", requiredLevel = 35 } },
    description = "Even the young can exceed 6.5 feet in length. It grows larger by repeatedly shedding skin.",
    skills = { "Tackle", 1, "Slam", 5, "Twister", 10, "Aqua Tail", 15, "Thunder Wave", 20, "Dragon Tail", 25, "Agility", 30 },
    abilities = { POKEMON_ABILITIES.WATERFALL, "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_WATER_1, POKEMON_EGG_GROUP_DRAGON },
    eggId = 14047,
    eggChance = 1,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.SHED_SKIN },
    learnableTms = { TM_IDS.FLAMETHROWER, TM_IDS.WATER_PULSE, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.RAGE, TM_IDS.DRAGON_RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.SUBSTITUTE },
    eggMoves = { "Aqua Jet", "Dragon Breath", "Dragon Dance", "Dragon Pulse", "Dragon Rush", "Extreme Speed", "Haze", "Iron Tail", "Mist", "Supersonic", "Water Pulse" }
}

POKEMON["RC Dratini"] = table.deepcopy(POKEMON["Dratini"])
POKEMON["RC Dratini"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Dratini"].blockTransform = true