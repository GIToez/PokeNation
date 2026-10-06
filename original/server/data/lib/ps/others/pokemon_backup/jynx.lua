POKEMON["Jynx"] = {
    pTypes = {ELEMENT_ICE, ELEMENT_PSYCHIC}, dexStorage = 10124, atk = 50, def = 35, spAtk = 115, spDef = 95, energy = 100, chance = 500, portrait = 12825, dexPortrait = 13625, fastcallPortrait = 10758, catchStorage = 16124,
    evolutions = {},
    description = "It speaks using a language that sounds human. Research is under way to determine what is being said.",
    skills = {"Tackle", 1, "Pound", 5, "Lick", 10, "Lovely Kiss", 15, "Powder Snow", 20, "Confusion", 25, "Ice Punch", 30, "Wake-Up Slap", 35, "Blizzard", 40, "Psychic", 45, "Wring Out", 50, "Body Slam", 55},
    abilities = {"Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_HUMAN_LIKE}, eggId = 14037, eggChance = 1,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.OBLIVIOUS--[[, POKEMON_SPECIAL_ABILITY_IDS.FOREWARN]]},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.AVALANCHE, TM_IDS.DRAIN_PUNCH, TM_IDS.ENERGY_BALL, TM_IDS.WATER_PULSE, TM_IDS.NIGHTMARE, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.DYNAMIC_PUNCH, TM_IDS.DREAM_EATER, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEABEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.PSYWAVE, TM_IDS.SUBSTITUTE},
    eggMoves = {"Captivate", "Fake Out", "Ice Punch", "Meditate", "Miracle Eye", "Nasty Plot", "Wake-Up Slap", "Wish"}
}

POKEMON["RC Jynx"] = table.deepcopy(POKEMON["Jynx"])
POKEMON["RC Jynx"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Jynx"].blockTransform = true