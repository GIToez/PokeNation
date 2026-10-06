POKEMON["Aipom"] = {
    pTypes = { ELEMENT_NORMAL },
    dexStorage = 10190,
    atk = 70,
    def = 55,
    spAtk = 40,
    spDef = 55,
    energy = 100,
    chance = 50,
    portrait = 17479,
    dexPortrait = 15837,
    fastcallPortrait = 16037,
    catchStorage = 16190,
    evolutions = {},
    description = "It lives atop tall trees. When leaping from branch to branch, it deftly uses its tail for balance.",
    skills = { "Tackle", 1, "Scratch", 5, "Sand-Attack", 10, "Fury Swipes", 15, "Swift", 20, "Astonish", 25, "Low Sweep", 30, "Shadow Claw", 35, "Rest", 40, "Agility", 45, "Brick Break", 50, "Uproar", 55, "Iron Tail", 60, "Last Resort", 65 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Find", "Cut", "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 17755,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.RUN_AWAY, POKEMON_SPECIAL_ABILITY_IDS.PICKUP },
    learnableTms = { TM_IDS.AERIAL_ACE, TM_IDS.WATER_PULSE, TM_IDS.NIGHTMARE, TM_IDS.FURY_CUTTER, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.DEFENSE_CURL, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.THUNDER_WAVE, TM_IDS.DREAM_EATER, TM_IDS.SWIFT, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.SOLAR_BEAM, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, },
    eggMoves = { "Agility", "Beat Up", "Bounce", "Counter", "Covet", "Double Slap", "Fake Out", "Pursuit", "Quick Guard", "Revenge", "Screech", "Slam", "Spite", "Switcheroo" }
}

POKEMON["RC Aipom"] = table.deepcopy(POKEMON["Aipom"])
POKEMON["RC Aipom"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Aipom"].blockTransform = true