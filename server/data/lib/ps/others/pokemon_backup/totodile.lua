POKEMON["Totodile"] = {
    pTypes = {ELEMENT_WATER}, dexStorage = 10158, atk = 65, def = 64, spAtk = 44, spDef = 48, energy = 100, chance = 150, portrait = 17447, dexPortrait = 15805, fastcallPortrait = 16005, catchStorage = 16158,
    evolutions = {{name = "Croconaw", requiredLevel = 35}},
    description = "It is small but rough and tough. It won't hesitate to take a bite out of anything that moves.",
    skills = {"Tackle", 1, "Scratch", 5, "Water Gun", 10, "Bite", 15, "Scary Face", 20, "Ice Fang", 25, "Aqua Tail", 30},
    abilities = {POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.WATERFALL, "Cut", "Surf", "Dive", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_MONSTER, POKEMON_EGG_GROUP_WATER_1}, eggId = 17743, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.TORRENT},
    learnableTms = {TM_IDS.AERIAL_ACE, TM_IDS.ROCK_TOMB, TM_IDS.WATER_PULSE, TM_IDS.ICE_PUNCH, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.BLIZZARD, TM_IDS.ROCK_SLIDE, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.ICE_BEAM, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, },
    eggMoves = {"Ancient Power", "Aqua Jet", "Block", "Crunch" , "Dragon Dance", "Fake Teasr", "Flatter", "Hydro Pump", "Ice Punch", "Metal Claw", "Mud Sport", "Thrash", "Water Pulse", "Water Sport"}
}

POKEMON["RC Totodile"] = table.deepcopy(POKEMON["Totodile"])
POKEMON["RC Totodile"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Totodile"].blockTransform = true