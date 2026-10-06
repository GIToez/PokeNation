POKEMON["Chikorita"] = {
    pTypes = { ELEMENT_GRASS },
    dexStorage = 10152,
    atk = 49,
    def = 65,
    spAtk = 49,
    spDef = 65,
    energy = 100,
    chance = 150,
    portrait = 17441,
    dexPortrait = 15799,
    fastcallPortrait = 15999,
    catchStorage = 16152,
    evolutions = { { name = "Bayleef", requiredLevel = 35 } },
    description = "Its pleasantly aromatic leaves have the ability to check the humidity and temperature.",
    skills = { "Tackle", 1, "Razor Leaf", 5, "Leech Seed", 10, "Magical Leaf", 15, "Body Slam", 20, "Poison Powder", 25, "Grass Whistle", 30 },
    abilities = { "Cut", "Flash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_MONSTER, POKEMON_EGG_GROUP_GRASS },
    eggId = 17741,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.OVERGROW },
    learnableTms = { TM_IDS.ENERGY_BALL, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.GIGA_DRAIN, TM_IDS.HEADBUTT, TM_IDS.REFLECT, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.SOLAR_BEAM, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, },
    eggMoves = { "Ancient Power", "Aromatherapy", "Body Slam", "Counter", "Flail", "Grass Whistle", "Grassy Terrain", "Heal Pulse", "Ingrain", "Leaf Storm", "Leech Seed", "Nature Power", "Refresh", "Vine Whip", "Wring Out" }
}

POKEMON["RC Chikorita"] = table.deepcopy(POKEMON["Chikorita"])
POKEMON["RC Chikorita"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Chikorita"].blockTransform = true