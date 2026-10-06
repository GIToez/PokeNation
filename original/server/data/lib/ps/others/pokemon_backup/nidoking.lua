POKEMON["Nidoking"] = {
    pTypes = {ELEMENT_POISON, ELEMENT_GROUND}, dexStorage = 10034, atk = 102, def = 77, spAtk = 85, spDef = 75, energy = 100, chance = 500, portrait = 12735, dexPortrait = 13535, fastcallPortrait = 10668, catchStorage = 16034,
    evolutions = {},
    description = "It is recognized by its rock-hard hide and its extended horn. Be careful with the horn as it contains venom.",
    skills = {"Tackle", 1, "Double Kick", 5, "Poison Sting", 10, "Fury Attack", 15, "Poison Jab", 20, "Acid", 25, "Focus Energy", 35, "Captivate", 40, "Horn Drill", 45, "Horn Attack", 50, "Mud-Slap", 60, "Thrash", 65, "Earth Power", 70, "Megahorn", 75},
    abilities = {POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_MONSTER, POKEMON_EGG_GROUP_FIELD}, eggId = 13990, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.POISON_POINT, POKEMON_SPECIAL_ABILITY_IDS.RIVALRY},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.AVALANCHE, TM_IDS.POISON_JAB, TM_IDS.FLAMETHROWER, TM_IDS.AERIAL_ACE, TM_IDS.ROCK_TOMB, TM_IDS.WATER_PULSE, TM_IDS.FURY_CUTTER, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.DEFENSE_CURL, TM_IDS.SLUDGE_BOMB, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.HORN_DRILL, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.PAY_DAY, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE},
    eggMoves = {"Amnesia", "Beat Up", "Chip Away", "Confusion", "Counter", "Disable", "Endure", "Head Smash", "Iron Tail", "Poison Tail", "Sucker Punch", "Supersonic", "Take Down", "Venom Drench"}
}

POKEMON["RC Nidoking"] = table.deepcopy(POKEMON["Nidoking"])
POKEMON["RC Nidoking"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Nidoking"].blockTransform = true

POKEMON["Cloned Nidoking"] = table.deepcopy(POKEMON["Nidoking"])
POKEMON["Cloned Nidoking"].blockTransform = true