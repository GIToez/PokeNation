POKEMON["Tentacruel"] = {
    pTypes = { ELEMENT_WATER, ELEMENT_POISON },
    dexStorage = 10073,
    atk = 70,
    def = 65,
    spAtk = 80,
    spDef = 120,
    energy = 100,
    chance = 800,
    portrait = 12774,
    dexPortrait = 13574,
    fastcallPortrait = 10707,
    catchStorage = 16073,
    evolutions = {},
    description = "It has 80 tentacles that move about freely. They can sting, causing poisoning and sharp, stabbing pain.",
    skills = { "Tackle", 1, "Poison Sting", 5, "Acid", 10, "Supersonic", 15, "Bubblebeam", 20, "Water Pulse", 25, "Wrap", 30, "Acid Spray", 40, "Barrier", 45, "Poison Jab", 50, "Hydro Pump", 55, "Sludge Bomb", 60, "Sludge Wave", 65, "Wring Out", 70, "Reflect Type", 75 },
    abilities = { POKEMON_ABILITIES.WATERFALL, "Surf", "Dive", "Cut" },
    eggGroup = { POKEMON_EGG_GROUP_WATER_3 },
    eggId = 14007,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.CLEAR_BODY, POKEMON_SPECIAL_ABILITY_IDS.LIQUID_OOZE },
    learnableTms = { TM_IDS.POISON_JAB, TM_IDS.WATER_PULSE, TM_IDS.SLUDGE_BOMB, TM_IDS.GIGA_DRAIN, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MEGA_DRAIN, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE, TM_IDS.HAIL, TM_IDS.SAFEGUARD },
    eggMoves = { "Acupressure", "Aqua Ring", "Aurora Beam", "Bubble", "Confuse Ray", "Haze", "Knock Off", "Mirror Coat", "Muddy Water", "Rapid Spin", "Tickle" }
}

POKEMON["RC Tentacruel"] = table.deepcopy(POKEMON["Tentacruel"])
POKEMON["RC Tentacruel"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Tentacruel"].blockTransform = true