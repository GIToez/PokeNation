POKEMON["Ekans"] = {
    pTypes = { ELEMENT_POISON },
    dexStorage = 10023,
    atk = 60,
    def = 44,
    spAtk = 40,
    spDef = 54,
    energy = 100,
    chance = 15,
    portrait = 12724,
    dexPortrait = 13524,
    fastcallPortrait = 10657,
    catchStorage = 16023,
    evolutions = { { name = "Arbok", requiredLevel = 35 } },
    description = "A very common sight in grassland, etc. It flicks its tongue in and out to sense danger in its surroundings.",
    skills = { "Tackle", 1, "Bite", 5, "Poison Sting", 10, "Glare", 15, "Acid", 20, "Acid Spray", 25, "Mud Bomb", 30 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD, POKEMON_EGG_GROUP_DRAGON },
    eggId = 13986,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.INTIMIDATE, POKEMON_SPECIAL_ABILITY_IDS.SHED_SKIN },
    learnableTms = { TM_IDS.POISON_JAB, TM_IDS.ROCK_TOMB, TM_IDS.SLUDGE_BOMB, TM_IDS.IRON_TAIL, TM_IDS.GIGA_DRAIN, TM_IDS.RAIN_DANCE, TM_IDS.HEADBUTT, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.MEGA_DRAIN, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE },
    eggMoves = { "Beat Up", "Disable", "Iron Tail", "Poison Fang", "Poison Tail", "Pursuit", "Scary Face", "Slam", "Snatch", "Spite", "Sucker Punch", "Switcheroo" }
}

POKEMON["RC Ekans"] = table.deepcopy(POKEMON["Ekans"])
POKEMON["RC Ekans"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Ekans"].blockTransform = true

POKEMON["Rocket's Ekans"] = table.deepcopy(POKEMON["Ekans"])

POKEMON["Christmas Ekans"] = table.deepcopy(POKEMON["Ekans"])
POKEMON["Christmas Ekans"].blockTransform = true
POKEMON["Christmas Ekans"].evolutions = {}
POKEMON["Christmas Ekans"].ignoreBallCounter = true