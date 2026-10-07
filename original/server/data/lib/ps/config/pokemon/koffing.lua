POKEMON["Koffing"] = {
    pTypes = { ELEMENT_POISON },
    dexStorage = 10109,
    atk = 65,
    def = 95,
    spAtk = 60,
    spDef = 45,
    energy = 100,
    chance = 15,
    portrait = 12810,
    dexPortrait = 13610,
    fastcallPortrait = 10743,
    catchStorage = 16109,
    evolutions = { { name = "Weezing", requiredLevel = 35 } },
    description = "Its thin, balloon-like body is inflated by horribly toxic gases. It reeks when it is nearby.",
    skills = { "Tackle", 1, "Smog", 5, "Poison Gas", 10, "Clear Smog", 15, "Sludge", 20, "Smoke Screen", 25, "Selfdestruct", 30 },
    abilities = {},
    eggGroup = { POKEMON_EGG_GROUP_AMORPHOUS },
    eggId = 14027,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.LEVITATE },
    learnableTms = { TM_IDS.FLAMETHROWER, TM_IDS.SLUDGE_BOMB, TM_IDS.SHADOW_BALL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.TOXIC, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SELFDESTRUCT, TM_IDS.FIRE_BLAST, TM_IDS.REST, TM_IDS.EXPLOSION, TM_IDS.SUBSTITUTE, TM_IDS.TAUNT, TM_IDS.SHOCK_WAVE },
    eggMoves = { "Curse", "Destiny Bond", "Grudge", "Pain Split", "Psybeam", "Psywave", "Screech", "Spite" --[[, "Spit Up", "Stockpile", "Swallow"]], "Toxic Spikes" }
}

POKEMON["Rocket's Koffing"] = table.deepcopy(POKEMON["Koffing"])