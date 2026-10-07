POKEMON["Rattata"] = {
    pTypes = { ELEMENT_NORMAL },
    dexStorage = 10019,
    atk = 56,
    def = 35,
    spAtk = 25,
    spDef = 35,
    energy = 100,
    chance = 2,
    portrait = 12720,
    dexPortrait = 13520,
    fastcallPortrait = 10653,
    catchStorage = 16019,
    evolutions = { { name = "Raticate", requiredLevel = 20 } },
    description = "Its fangs are long and very sharp. They grow continuously, so it gnaws on hard things to whittle them down.",
    skills = { "Tackle", 1, "Quick Attack", 5, "Bite", 10, "Hyper Fang", 15 },
    abilities = { POKEMON_ABILITIES.DIG, "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 13984,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.RUN_AWAY, POKEMON_SPECIAL_ABILITY_IDS.GUTS },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.THUNDER_WAVE, TM_IDS.ICE_BEAM, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.BLIZZARD, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE },
    eggMoves = { "Bite", "Counter", "Final Gambit", "Flame Wheel", "Fury Swipes", "Last Resort", "Me First", "Revenge", "Reversal", "Screech", "Uproar" }
}

POKEMON["RC Rattata"] = table.deepcopy(POKEMON["Rattata"])
POKEMON["RC Rattata"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Rattata"].blockTransform = true

POKEMON["Christmas Rattata"] = table.deepcopy(POKEMON["Rattata"])
POKEMON["Christmas Rattata"].blockTransform = true
POKEMON["Christmas Rattata"].evolutions = {}
POKEMON["Christmas Rattata"].ignoreBallCounter = true