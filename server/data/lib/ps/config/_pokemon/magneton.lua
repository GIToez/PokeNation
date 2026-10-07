POKEMON["Magneton"] = {
    pTypes = { ELEMENT_ELECTRIC, ELEMENT_STEEL },
    dexStorage = 10082,
    atk = 60,
    def = 95,
    spAtk = 120,
    spDef = 70,
    energy = 100,
    chance = 350,
    portrait = 12783,
    dexPortrait = 13583,
    fastcallPortrait = 10716,
    catchStorage = 16082,
    evolutions = {},
    description = "A linked cluster formed of several MAGNEMITE. It discharges powerful magnetic waves at high voltage.",
    skills = { "Tackle", 1, "Thunder Shock", 5, "Supersonic", 10, "Sonic Boom", 15, "Thunder Wave", 20, "Electro Ball", 25, "Thunderbolt", 35, "Magnet Bomb", 40, "Discharge", 45, "Mirror Shot", 50, "Flash Cannon", 55, "Metal Sound", 60, "Zap Cannon", 65 },
    abilities = { "Flash" },
    eggGroup = { POKEMON_EGG_GROUP_MINERAL },
    eggId = 14011,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.MAGNET_PULL, POKEMON_SPECIAL_ABILITY_IDS.STURDY },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.EXPLOSION, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.SUBSTITUTE }
}

POKEMON["RC Magneton"] = table.deepcopy(POKEMON["Magneton"])
POKEMON["RC Magneton"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Magneton"].blockTransform = true

POKEMON["Cloned Magneton"] = table.deepcopy(POKEMON["Magneton"])
POKEMON["Cloned Magneton"].blockTransform = true