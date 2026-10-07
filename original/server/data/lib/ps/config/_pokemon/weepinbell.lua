POKEMON["Weepinbell"] = {
    pTypes = { ELEMENT_GRASS, ELEMENT_POISON },
    dexStorage = 10070,
    atk = 90,
    def = 50,
    spAtk = 85,
    spDef = 45,
    energy = 100,
    chance = 200,
    portrait = 12771,
    dexPortrait = 13571,
    fastcallPortrait = 10704,
    catchStorage = 16070,
    evolutions = { { name = "Victreebel", requiredLevel = 50, requiredItems = { ITEMS.LEAF_STONE } } },
    description = "The leafy parts act as cutters for slashing foes. It spits a fluid that dissolves everything.",
    skills = { "Tackle", 1, "Vine Whip", 5, "Poison Powder", 10, "Razor Leaf", 15, "Stun Spore", 20, "Acid", 25, "Slam", 30, "Venoshock", 40, "Leaf Tornado", 45 },
    abilities = { "Cut" },
    eggGroup = { POKEMON_EGG_GROUP_GRASS },
    eggId = 14006,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.CHLOROPHYLL },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.ENERGY_BALL, TM_IDS.SLUDGE_BOMB, TM_IDS.GIGA_DRAIN, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.MEGA_DRAIN, TM_IDS.SOLAR_BEAM, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.REST, TM_IDS.SUBSTITUTE },
    eggMoves = { "Acid Spray", "Belch", "Bullet Seed", "Clear Smog", "Encore", "Giga Drain", "Ingrain", "Leech Life", "Magical Leaf", "Natural Gift", "Power Whip", "Synthesis", "Tickle", "Weather Ball", "Worry Seed" }
}

POKEMON["RC Weepinbell"] = table.deepcopy(POKEMON["Weepinbell"])
POKEMON["RC Weepinbell"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Weepinbell"].blockTransform = true