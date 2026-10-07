POKEMON["Tauros"] = {
    pTypes = { ELEMENT_NORMAL },
    dexStorage = 10128,
    atk = 100,
    def = 95,
    spAtk = 40,
    spDef = 70,
    energy = 100,
    chance = 300,
    portrait = 12829,
    dexPortrait = 13629,
    fastcallPortrait = 10762,
    catchStorage = 16128,
    evolutions = {},
    description = "When it is about to TACKLE, it whips its body repeatedly with its three long tails.",
    skills = { "Tackle", 1, "Headbutt", 5, "Rage", 10, "Pursuit", 15, "Horn Attack", 20, "Scary Face", 25, "Rest", 30, "Take Down", 35, "Zen Headbutt", 40, "Payback", 45, "Thrash", 50, "Iron Head", 55, "Giga Impact", 60, "Endeavor", 65 },
    abilities = { POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Headbutt", "Ride", "Rock Smash" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 14041,
    eggChance = 5,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.INTIMIDATE, POKEMON_SPECIAL_ABILITY_IDS.ANGER_POINT },
    learnableTms = { TM_IDS.FLAMETHROWER, TM_IDS.ROCK_TOMB, TM_IDS.WATER_PULSE, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.ROCK_SLIDE, TM_IDS.SOLAR_BEAM, TM_IDS.TOXIC, TM_IDS.HORN_DRILL, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE, TM_IDS.SHOCK_WAVE, TM_IDS.SANDSTORM }
}

POKEMON["RC Tauros"] = table.deepcopy(POKEMON["Tauros"])
POKEMON["RC Tauros"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Tauros"].blockTransform = true