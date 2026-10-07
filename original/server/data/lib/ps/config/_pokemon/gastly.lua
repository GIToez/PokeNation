POKEMON["Gastly"] = {
    pTypes = { ELEMENT_GHOST, ELEMENT_POISON },
    dexStorage = 10092,
    atk = 35,
    def = 30,
    spAtk = 100,
    spDef = 35,
    energy = 100,
    chance = 200,
    portrait = 12793,
    dexPortrait = 13593,
    fastcallPortrait = 10726,
    catchStorage = 16092,
    evolutions = { { name = "Haunter", requiredLevel = 35 } },
    description = "A being that exists as a thin gas. It can topple an Indian elephant by enveloping the prey in two seconds.",
    skills = { "Tackle", 1, "Lick", 5, "Night Shade", 10, "Hypnosis", 15, "Dream Eater", 20, "Curse", 25, "Spite", 30 },
    abilities = {},
    eggGroup = { POKEMON_EGG_GROUP_AMORPHOUS },
    eggId = 14017,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.LEVITATE },
    learnableTms = { TM_IDS.ENERGY_BALL, TM_IDS.NIGHTMARE, TM_IDS.SLUDGE_BOMB, TM_IDS.SHADOW_BALL, TM_IDS.GIGA_DRAIN, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.TOXIC, TM_IDS.RAGE, TM_IDS.MEGA_DRAIN, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SELFDESTRUCT, TM_IDS.DREAM_EATER, TM_IDS.REST, TM_IDS.PSYWAVE, TM_IDS.EXPLOSION, TM_IDS.SUBSTITUTE },
    eggMoves = { "Astonish", "Clear Smog", "Disable", "Fire Punch", "Grudge", "Haze", "Ice Punch", "Perish Song", "Psywave", "Reflect Type", "Scary Face", "Smog", "Thunder Punch" }
}

POKEMON["Christmas Gastly"] = table.deepcopy(POKEMON["Gastly"])
POKEMON["Christmas Gastly"].blockTransform = true
POKEMON["Christmas Gastly"].evolutions = {}
POKEMON["Christmas Gastly"].ignoreBallCounter = true