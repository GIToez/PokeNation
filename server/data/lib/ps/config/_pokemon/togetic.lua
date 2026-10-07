POKEMON["Togetic"] = {
    pTypes = { ELEMENT_FAIRY, ELEMENT_FLYING },
    dexStorage = 10176,
    atk = 40,
    def = 85,
    spAtk = 80,
    spDef = 105,
    energy = 100,
    chance = 600,
    portrait = 17465,
    dexPortrait = 15823,
    fastcallPortrait = 16023,
    catchStorage = 16176,
    evolutions = {},
    description = "It grows dispirited if it is not with kind people. It can float in midair without moving its wings.",
    skills = { "Tackle", 1, "Fairy Wind", 5, "Ancient Power", 10, "Metronome", 15, "Covet", 20, "Wish", 25, "Magical Leaf", 35, "Sweet Kiss", 40, "Mirror Move", 45, "Double-Edge", 50, "Magic Coat", 55, "Future Sight", 60, "Yawn", 65, "Last Resort", 70 },
    abilities = { "Flash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FLYING, POKEMON_EGG_GROUP_FAIRY },
    eggId = 17749,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.HUSTLE, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE },
    learnableTms = { TM_IDS.DRAIN_PUNCH, TM_IDS.FLAMETHROWER, TM_IDS.AERIAL_ACE, TM_IDS.WATER_PULSE, TM_IDS.STEEL_WING, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.THUNDER_WAVE, TM_IDS.DREAM_EATER, TM_IDS.SWIFT, TM_IDS.FIRE_BLAST, TM_IDS.REFLECT, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.SOLAR_BEAM, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, },
    eggMoves = { "Extrasensory", "Foresight", "Future Sight", "Lucky Chant", "Mirror Move", "Morning Sun", "Nasty Plot", "Peck", "Present", "Psycho Shift", "Secret Power", "Stored Power" }
}

POKEMON["Cloned Togetic"] = table.deepcopy(POKEMON["Togetic"])
POKEMON["Cloned Togetic"].blockTransform = true