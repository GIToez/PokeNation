POKEMON["Venusaur"] = {
    pTypes = {ELEMENT_GRASS, ELEMENT_POISON}, dexStorage = 10003, atk = 82, def = 83, spAtk = 100, spDef = 100, energy = 100, chance = 800, portrait = 12704, dexPortrait = 13504, fastcallPortrait = 10637, catchStorage = 16003,
    evolutions = {},
    description = "A bewitching aroma wafts from its flower. The fragrance becalms those engaged in a battle.",
    skills = {"Tackle", 1, "Headbutt", 5, "Razor Leaf", 10, "Vine Whip", 15, "Leech Seed", 20, "Poison Powder", 25, "Sleep Powder", 30, "Synthesis", 40, "Solar Beam", 45, "Worry Seed", 50, "Petal Dance", 60},
    abilities = {POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Cut", "Headbutt", "Ride"}, eggGroup = {POKEMON_EGG_GROUP_MONSTER, POKEMON_EGG_GROUP_GRASS}, eggId = 13978, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.OVERGROW},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.ENERGY_BALL, TM_IDS.FURY_CUTTER, TM_IDS.DEFENSE_CURL, TM_IDS.SLUDGE_BOMB, TM_IDS.MUD_SLAP, TM_IDS.GIGA_DRAIN, TM_IDS.HEADBUTT, TM_IDS.EARTHQUAKE, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MEGA_DRAIN, TM_IDS.SOLAR_BEAM, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.REST, TM_IDS.SUBSTITUTE},
    eggMoves = {"Amnesia", "Charm", "Curse", "Endure", "Giga Drain", "Grass Whistle", "Grassy Terrain", "Ingrain", "Leaf Storm", "Magical Leaf", "Nature Power", "Petal Dance", "Power Whip", "Skull Bash", "Sludge"}
}

POKEMON["RC Venusaur"] = table.deepcopy(POKEMON["Venusaur"])
POKEMON["RC Venusaur"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Venusaur"].blockTransform = true

POKEMON["Suramoon Venusaur"] = table.deepcopy(POKEMON["Venusaur"])
POKEMON["Suramoon Venusaur"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["Suramoon Venusaur"].blockTransform = true
POKEMON["Suramoon Venusaur"].atk = 105 * 6
POKEMON["Suramoon Venusaur"].def = 60 * 3
POKEMON["Suramoon Venusaur"].spAtk = 60 * 6
POKEMON["Suramoon Venusaur"].spDef = 70 * 3

POKEMON["Clone Venusaur"] = table.deepcopy(POKEMON["Venusaur"])
POKEMON["Clone Venusaur"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["Clone Venusaur"].blockTransform = true
POKEMON["Clone Venusaur"].atk = 105 * 6
POKEMON["Clone Venusaur"].def = 60 * 3
POKEMON["Clone Venusaur"].spAtk = 60 * 6
POKEMON["Clone Venusaur"].spDef = 70 * 3

POKEMON["Cloned Venusaur"] = table.deepcopy(POKEMON["Venusaur"])
POKEMON["Cloned Venusaur"].blockTransform = true