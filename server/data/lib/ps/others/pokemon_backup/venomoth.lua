POKEMON["Venomoth"] = {
    pTypes = {ELEMENT_BUG, ELEMENT_POISON}, dexStorage = 10049, atk = 65, def = 60, spAtk = 90, spDef = 75, energy = 100, chance = 400, portrait = 12750, dexPortrait = 13550, fastcallPortrait = 10683, catchStorage = 16049,
    evolutions = {},
    description = "The wings are covered with dustlike scales. Every time it flaps its wings, it looses highly toxic dust.",
    skills = {"Tackle", 1, "Bug Bite", 5, "Confusion", 10, "Bug Buzz", 15, "Leech Life", 20, "Stun Spore", 25, "Sleep Powder", 30, "Poison Fang", 35, "Gust", 45, "Psybeam", 50, "Poison Powder", 55, "Zen Headbutt", 60, "Psychic", 65},
    abilities = {"Find", "Flash"}, eggGroup = {POKEMON_EGG_GROUP_BUG}, eggId = 13997, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, POKEMON_SPECIAL_ABILITY_IDS.TINTED_LENS},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.ENERGY_BALL, TM_IDS.AERIAL_ACE, TM_IDS.SLUDGE_BOMB, TM_IDS.GIGA_DRAIN, TM_IDS.RAZOR_WIND, TM_IDS.WHIRLWIND, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MEGA_DRAIN, TM_IDS.SOLAR_BEAM, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.BIDE, TM_IDS.REST, TM_IDS.PSYWAVE, TM_IDS.SUBSTITUTE},
    eggMoves = {"Agility", "Baton Pass", "Bug Bite", "Giga Drain", "Morning Sun", "Rage Powder", "Screech", "Secret Power", "Signal Beam", "Skill Swap", "Toxic Spikes"}
}

POKEMON["RC Venomoth"] = table.deepcopy(POKEMON["Venomoth"])
POKEMON["RC Venomoth"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Venomoth"].blockTransform = true

POKEMON["Furious Venomoth"] = table.deepcopy(POKEMON["Venomoth"])