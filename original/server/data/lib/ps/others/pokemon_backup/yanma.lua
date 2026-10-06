POKEMON["Yanma"] = {
    pTypes = {ELEMENT_BUG, ELEMENT_FLYING}, dexStorage = 10193, atk = 65, def = 45, spAtk = 75, spDef = 45, energy = 100, chance = 500, portrait = 17482, dexPortrait = 15840, fastcallPortrait = 16040, catchStorage = 16193,
    evolutions = {},
    description = "Its large eyes can scan 360 degrees. It looks in all directions to seek out insects as its prey.",
    skills = {"Tackle", 1, "Quick Attack", 5, "Double Team", 10, "Sonic Boom", 15, "Supersonic", 20, "Pursuit", 25, "Hypnosis", 30, "Wing Attack", 35, "Bug Buzz", 40, "Screech", 45, "Ancient Power", 50},
    abilities = {"Find", "Flash", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_BUG}, eggId = 17757, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.SPEED_BOOST, POKEMON_SPECIAL_ABILITY_IDS.COMPOUNDEYES},
    learnableTms = {TM_IDS.AERIAL_ACE, TM_IDS.STEEL_WING, TM_IDS.SHADOW_BALL, TM_IDS.GIGA_DRAIN, TM_IDS.HEADBUTT, TM_IDS.DREAM_EATER, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.SOLAR_BEAM, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, },
    eggMoves = {"Double-Edge", "Feint", "Faint Attack", "Leech Life", "Pursuit", "Reversal", "Secret Power", "Signal Beam", "Silver Wind", "Whirlwind"}
}

POKEMON["RC Yanma"] = table.deepcopy(POKEMON["Yanma"])
POKEMON["RC Yanma"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Yanma"].blockTransform = true