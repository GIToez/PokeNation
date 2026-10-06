POKEMON["Weezing"] = {
    pTypes = { ELEMENT_POISON },
    dexStorage = 10110,
    atk = 90,
    def = 120,
    spAtk = 85,
    spDef = 70,
    energy = 100,
    chance = 350,
    portrait = 12811,
    dexPortrait = 13611,
    fastcallPortrait = 10744,
    catchStorage = 16110,
    evolutions = {},
    description = "Very rarely, a sudden mutation can result in two small KOFFING twins becoming conjoined as a WEEZING.",
    skills = { "Tackle", 1, "Smog", 5, "Poison Gas", 10, "Clear Smog", 15, "Sludge", 20, "Smoke Screen", 25, "Explosion", 30, "Assurance", 40, "Screech", 45, "Venoshock", 50, "Double Hit", 55, "Mud Shot", 60, "Sludge Bomb", 65, "Belch", 70, "Facade", 75 },
    abilities = {},
    eggGroup = { POKEMON_EGG_GROUP_AMORPHOUS },
    eggId = 14027,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.LEVITATE },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.FLAMETHROWER, TM_IDS.SLUDGE_BOMB, TM_IDS.SHADOW_BALL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.TOXIC, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SELFDESTRUCT, TM_IDS.FIRE_BLAST, TM_IDS.REST, TM_IDS.EXPLOSION, TM_IDS.SUBSTITUTE },
    eggMoves = { "Curse", "Destiny Bond", "Grudge", "Pain Split", "Psybeam", "Psywave", "Screech", "Spite" --[[, "Spit Up", "Stockpile", "Swallow"]], "Toxic Spikes" }
}

POKEMON["RC Weezing"] = table.deepcopy(POKEMON["Weezing"])
POKEMON["RC Weezing"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Weezing"].blockTransform = true

POKEMON["Rocket's Weezing"] = table.deepcopy(POKEMON["Weezing"])