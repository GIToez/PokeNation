POKEMON["Raticate"] = {
    pTypes = { ELEMENT_NORMAL },
    dexStorage = 10020,
    atk = 81,
    def = 60,
    spAtk = 50,
    spDef = 70,
    energy = 100,
    chance = 200,
    portrait = 12721,
    dexPortrait = 13521,
    fastcallPortrait = 10654,
    catchStorage = 16020,
    evolutions = {},
    description = "Its rear feet have three toes each. They are webbed, enabling it to swim across rivers.",
    skills = { "Tackle", 1, "Quick Attack", 5, "Bite", 10, "Hyper Fang", 15, "Pursuit", 25, "Scary Face", 30, "Crunch", 35, "Endeavor", 40, "Double-Edge", 45, "Focus Energy", 50, "Assurance", 55, "Swords Dance", 60, "Sucker Punch", 65 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 13984,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.RUN_AWAY, POKEMON_SPECIAL_ABILITY_IDS.GUTS },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.THUNDER_WAVE, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE, TM_IDS.TAUNT, TM_IDS.SHOKC_WAVE, TM_IDS.ROAR },
    eggMoves = { "Bite", "Counter", "Final Gambit", "Flame Wheel", "Fury Swipes", "Last Resort", "Me First", "Revenge", "Reversal", "Screech", "Uproar" }
}

POKEMON["Felon Raticate"] = table.deepcopy(POKEMON["Raticate"])