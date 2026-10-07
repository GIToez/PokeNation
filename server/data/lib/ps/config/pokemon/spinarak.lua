POKEMON["Spinarak"] = {
    pTypes = { ELEMENT_BUG, ELEMENT_POISON },
    dexStorage = 10167,
    atk = 60,
    def = 40,
    spAtk = 40,
    spDef = 40,
    energy = 100,
    chance = 100,
    portrait = 17456,
    dexPortrait = 15814,
    fastcallPortrait = 16014,
    catchStorage = 16167,
    evolutions = { { name = "Ariados", requiredLevel = 40 } },
    description = "It spins a web using fine--but durable--thread. It then waits patiently for prey to be trapped.",
    skills = { "Tackle", 1, "Poison Sting", 5, "Bug Bite", 10, "Leech Life", 15, "Shadow Sneak", 20, "Psychic", 25, "Fury Swipes", 30, "Spider Web", 35 },
    abilities = { POKEMON_ABILITIES.DIG, "Find", "Flash" },
    eggGroup = { POKEMON_EGG_GROUP_BUG },
    eggId = 17747,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.SWARM, POKEMON_SPECIAL_ABILITY_IDS.INSOMNIA },
    learnableTms = { TM_IDS.POISON_JAB, TM_IDS.SLUDGE_BOMB, TM_IDS.GIGA_DRAIN, TM_IDS.SWIFT, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.SOLAR_BEAM, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, },
    eggMoves = { "Baton Pass", "Disable", "Electroweb", "Megahorn", "Night Slash", "Psybeam ", "Pursuit", "Rage Powder", "Singal Beam", "Sonic Boom", "Toxic Spikes", "Twineedle" }
}

POKEMON["RC Spinarak"] = table.deepcopy(POKEMON["Spinarak"])
POKEMON["RC Spinarak"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Spinarak"].blockTransform = true