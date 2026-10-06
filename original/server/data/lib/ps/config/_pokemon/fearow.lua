POKEMON["Fearow"] = {
    pTypes = { ELEMENT_NORMAL, ELEMENT_FLYING },
    dexStorage = 10022,
    atk = 90,
    def = 65,
    spAtk = 61,
    spDef = 61,
    energy = 100,
    chance = 400,
    portrait = 12723,
    dexPortrait = 13523,
    fastcallPortrait = 10656,
    catchStorage = 16022,
    evolutions = {},
    description = "Its huge and magnificent wings can keep it aloft in the sky. It can remain flying a whole day without landing.",
    skills = {
        "Tackle", 1, "Peck", 5, "Fury Attack", 10, "Gust", 15, "Pursuit", 20, "Drill Peck", 25, "Agility", 30, "Roost", 40, "Pluck", 45, "Aerial Ace", 50, "Hurricane", 55, "Drill Run", 60, "Sky Attack", 65, "Mirror Move", 70
    },
    abilities = { "Find", "Fly" },
    eggGroup = { POKEMON_EGG_GROUP_FLYING },
    eggId = 13985,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.KEEN_EYE },
    learnableTms = { TM_IDS.AERIAL_ACE, TM_IDS.STEEL_WING, TM_IDS.MUD_SLAP, TM_IDS.RAIN_DANCE, TM_IDS.RAZOR_WIND, TM_IDS.WHIRLWIND, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.SKY_ATTACK, TM_IDS.REST, TM_IDS.SUBSTITUTE },
    eggMoves = { "Astonish", "Feather Dance", "Faint Attack", "Quick Attack", "Razor Wind", "Sacry Face", "Sky Attack", "Steel Wing", "Tri Attack", "Uproar", "Whirlwind" }
}

POKEMON["RC Fearow"] = table.deepcopy(POKEMON["Fearow"])
POKEMON["RC Fearow"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Fearow"].blockTransform = true