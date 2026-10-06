POKEMON["Meowth"] = {
    pTypes = { ELEMENT_NORMAL },
    dexStorage = 10052,
    atk = 45,
    def = 35,
    spAtk = 40,
    spDef = 40,
    energy = 100,
    chance = 30,
    portrait = 12753,
    dexPortrait = 13553,
    fastcallPortrait = 10686,
    catchStorage = 16052,
    evolutions = { { name = "Persian", requiredLevel = 40 } },
    description = "All it does is sleep during the daytime. At night, it patrols its territory with its eyes aglow.",
    skills = { "Tackle", 1, "Scratch", 5, "Bite", 10, "Fury Swipes", 15, "Slash", 20, "Captivate", 25, "Night Slash", 30, "Iron Tail", 35 },
    abilities = { POKEMON_ABILITIES.DIG, "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 13999,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.PICKUP, POKEMON_SPECIAL_ABILITY_IDS.TECHNICIAN },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.AERIAL_ACE, TM_IDS.WATER_PULSE, TM_IDS.NIGHTMARE, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DREAM_EATER, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.PAY_DAY, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.SKULL_BASh, TM_IDS.REST, TM_IDS.SUBSTITUTE, TM_IDS.TAUNT, TM_IDS.SHOCK_WAVE },
    eggMoves = { "Amnesia", "Assist", "Charm", "Flail", "Foul Play", "Hypnosis", "Iron Tail", "Last Resort", "Odor Sleuth", "Punishment", "Snatch", "Spite", "Tail Whip" }
}

POKEMON["RC Meowth"] = table.deepcopy(POKEMON["Meowth"])
POKEMON["RC Meowth"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Meowth"].blockTransform = true

POKEMON["Christmas Meowth"] = table.deepcopy(POKEMON["Meowth"])
POKEMON["Christmas Meowth"].blockTransform = true
POKEMON["Christmas Meowth"].evolutions = {}
POKEMON["Christmas Meowth"].ignoreBallCounter = true