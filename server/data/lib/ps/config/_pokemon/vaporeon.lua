POKEMON["Vaporeon"] = {
    pTypes = { ELEMENT_WATER },
    dexStorage = 10134,
    atk = 65,
    def = 60,
    spAtk = 110,
    spDef = 95,
    energy = 100,
    chance = 500,
    portrait = 12835,
    dexPortrait = 13635,
    fastcallPortrait = 10768,
    catchStorage = 16134,
    evolutions = {},
    description = "Its body's cellular structure is similar to the molecular composition of water. It can melt invisibly in water.",
    skills = { "Tackle", 1, "Quick Attack", 5, "Sand-Attack", 10, "Bite", 15, "Water Gun", 20, "Aurora Beam", 25, "Aqua Ring", 35, "Water Pulse", 40, "Muddy Water", 45, "Scald", 50, "Acid Armor", 55, "Aqua Tail", 60, "Hydro Pump", 65, "Last Resort", 70 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, POKEMON_ABILITIES.WATERFALL, "Find", "Surf", "Dive", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 14044,
    eggChance = 1,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.WATER_ABSORB },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.WATER_PULSE, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE },
    eggMoves = { "Captivate", "Charm", "Covet", "Curse", "Detect", "Endure", "Fake Tears", "Flail", "Natural Gift", "Stored Power", "Synchronoise", "Tickle", "Wish", "Yawn" }
}

POKEMON["RC Vaporeon"] = table.deepcopy(POKEMON["Vaporeon"])
POKEMON["RC Vaporeon"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Vaporeon"].blockTransform = true