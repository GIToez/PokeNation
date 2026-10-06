POKEMON["Butterfree"] = {
    pTypes = {ELEMENT_BUG, ELEMENT_FLYING}, dexStorage = 10012, atk = 45, def = 50, spAtk = 90, spDef = 80, energy = 100, chance = 250, portrait = 12713, dexPortrait = 13513, fastcallPortrait = 10646, catchStorage = 16012,
    evolutions = {},
    description = "The wings are protected by rain-repellent dust. As a result, this POKEMON can fly about even in rain.",
    skills = {"Tackle", 1, "Confusion", 5, "Bug Buzz", 10, "Stun Spore", 15, "Air Cutter", 20, "Sleep Powder", 30, "Supersonic", 35, "Silver Wind", 40, "Psybeam", 45, "Poison Powder", 50, "Psychic", 55, "Quiver Dance", 60},
    abilities = {"Flash"}, eggGroup = {POKEMON_EGG_GROUP_BUG}, eggId = 13981, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.COMPOUNDEYES},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.ENERGY_BALL, TM_IDS.AERIAL_ACE, TM_IDS.NIGHTMARE, TM_IDS.SHADOW_BALL, TM_IDS.GIGA_DRAIN, TM_IDS.RAIN_DANCE, TM_IDS.DREAM_EATER, TM_IDS.RAZOR_WIND, TM_IDS.WHIRLWIND, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MEGA_DRAIN, TM_IDS.SOLAR_BEAM, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.REST, TM_IDS.PSYWAVE, TM_IDS.SUBSTITUTE}
}

POKEMON["RC Butterfree"] = table.deepcopy(POKEMON["Butterfree"])
POKEMON["RC Butterfree"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Butterfree"].blockTransform = true