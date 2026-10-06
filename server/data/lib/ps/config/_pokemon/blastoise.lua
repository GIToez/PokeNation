POKEMON["Blastoise"] = {
    pTypes = { ELEMENT_WATER },
    dexStorage = 10009,
    atk = 83,
    def = 100,
    spAtk = 85,
    spDef = 105,
    energy = 100,
    chance = 800,
    portrait = 12710,
    dexPortrait = 13510,
    fastcallPortrait = 10643,
    catchStorage = 16009,
    evolutions = {},
    description = "It crushes its foe under its heavy body to cause fainting. In a pinch, it will withdraw inside its shell.",
    skills = { "Tackle", 1, "Bite", 5, "Bubble", 10, "Water Gun", 15, "Protect", 20, "Bubblebeam", 25, "Water Pulse", 30, "Rapid Spin", 40, "Aqua Tail", 45, "Hydro Pump", 50, "Hydro Cannon", 60, "Skull Bash", 65, "Flash Cannon", 70, "Rain Dance", 75 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, POKEMON_ABILITIES.WATERFALL, "Surf", "Dive", "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_MONSTER, POKEMON_EGG_GROUP_WATER_1 },
    eggId = 13980,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.TORRENT },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.AVALANCHE, TM_IDS.ROCK_TOMB, TM_IDS.WATER_PULSE, TM_IDS.DEFENSE_CURL, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE },
    eggMoves = { "Aqua Jet", "Aqua Ring", "Aura Sphere", "Brine", "Dragon Pulse", "Fake Out", "Flail", "Foresight", "Haze", "Mirror Coat", "Mist", "Mud Sport", "Muddy Water", "Refresh", "Water Spout", "Yawn" }
}

POKEMON["RC Blastoise"] = table.deepcopy(POKEMON["Blastoise"])
POKEMON["RC Blastoise"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Blastoise"].blockTransform = true

POKEMON["Suramoon Blastoise"] = table.deepcopy(POKEMON["Blastoise"])
POKEMON["Suramoon Blastoise"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["Suramoon Blastoise"].blockTransform = true
POKEMON["Suramoon Blastoise"].atk = 105 * 6
POKEMON["Suramoon Blastoise"].def = 60 * 3
POKEMON["Suramoon Blastoise"].spAtk = 60 * 6
POKEMON["Suramoon Blastoise"].spDef = 70 * 3

POKEMON["Clone Blastoise"] = table.deepcopy(POKEMON["Blastoise"])
POKEMON["Clone Blastoise"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["Clone Blastoise"].blockTransform = true
POKEMON["Clone Blastoise"].atk = 105 * 6
POKEMON["Clone Blastoise"].def = 60 * 3
POKEMON["Clone Blastoise"].spAtk = 60 * 6
POKEMON["Clone Blastoise"].spDef = 70 * 3

POKEMON["Cloned Blastoise"] = table.deepcopy(POKEMON["Blastoise"])
POKEMON["Cloned Blastoise"].blockTransform = true