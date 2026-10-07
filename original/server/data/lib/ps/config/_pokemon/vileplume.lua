POKEMON["Vileplume"] = {
    pTypes = { ELEMENT_GRASS, ELEMENT_POISON },
    dexStorage = 10045,
    atk = 80,
    def = 85,
    spAtk = 110,
    spDef = 90,
    energy = 100,
    chance = 400,
    portrait = 12746,
    dexPortrait = 13546,
    fastcallPortrait = 10679,
    catchStorage = 16045,
    evolutions = {},
    description = "Its petals are the largest in the world. It fiendishly scatters allergy-causing pollen from its petals.",
    skills = { "Tackle", 1, "Absorb", 5, "Acid", 10, "Poison Powder", 15, "Stun Spore", 20, "Giga Drain", 25, "Acid Spray", 35, "Moonlight", 40, "Sleep Powder", 45, "Venoshock", 55, "Petal Blizzard", 60, "Petal Dance", 65, "Solar Beam", 70, "Aromatherapy", 75 },
    abilities = { "Cut" },
    eggGroup = { POKEMON_EGG_GROUP_GRASS },
    eggId = 13995,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.CHLOROPHYLL },
    learnableTms = { TM_IDS.DRAIN_PUNCH, TM_IDS.ENERGY_BALL, TM_IDS.SLUDGE_BOMB, TM_IDS.GIGA_DRAIN, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MEGA_DRAIN, TM_IDS.SOLAR_BEAM, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.REST, TM_IDS.SUBSTITUTE },
    eggMoves = { "After You", "Charm", "Flail", "Ingrain", "Nature Power", "Razor Leaf", "Secret Power", "Synthesis", "Teeter Dance", "Tickle" }
}

POKEMON["RC Vileplume"] = table.deepcopy(POKEMON["Vileplume"])
POKEMON["RC Vileplume"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Vileplume"].blockTransform = true