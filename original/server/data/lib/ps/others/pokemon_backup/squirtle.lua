POKEMON["Squirtle"] = {
    pTypes = {ELEMENT_WATER}, dexStorage = 10007, atk = 48, def = 65, spAtk = 50, spDef = 64, energy = 100, chance = 150, portrait = 12708, dexPortrait = 13508, fastcallPortrait = 10641, catchStorage = 16007,
    evolutions = {{name = "Wartortle", requiredLevel = 35}},
    description = "When it retracts its long neck into its shell, it squirts out water with vigorous force.",
    skills = {"Tackle", 1, "Bite", 5, "Bubble", 10, "Water Gun", 15, "Protect", 20, "Bubblebeam", 25, "Water Pulse", 30},
    abilities = {POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, POKEMON_ABILITIES.WATERFALL, "Surf", "Dive", "Rock Smash", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_MONSTER, POKEMON_EGG_GROUP_WATER_1}, eggId = 13980, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.TORRENT},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.ROCK_TOMB, TM_IDS.WATER_PULSE, TM_IDS.DEFENSE_CURL, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE},
    eggMoves = {"Aqua Jet", "Aqua Ring", "Aura Sphere", "Brine", "Dragon Pulse", "Fake Out", "Flail", "Foresight", "Haze", "Mirror Coat", "Mist", "Mud Sport", "Muddy Water", "Refresh", "Water Spout", "Yawn"}
}

POKEMON["RC Squirtle"] = table.deepcopy(POKEMON["Squirtle"])
POKEMON["RC Squirtle"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Squirtle"].blockTransform = true

POKEMON["Easter Squirtle"] = table.deepcopy(POKEMON["Squirtle"])
POKEMON["Easter Squirtle"].blockTransform = true
POKEMON["Easter Squirtle"].evolutions = {}
POKEMON["Easter Squirtle"].allowedBall = "white easter"
POKEMON["Easter Squirtle"].ignoreBallCounter = true
POKEMON["Easter Squirtle"].chance = 100

POKEMON["Christmas Squirtle"] = table.deepcopy(POKEMON["Squirtle"])
POKEMON["Christmas Squirtle"].blockTransform = true
POKEMON["Christmas Squirtle"].evolutions = {}
POKEMON["Christmas Squirtle"].ignoreBallCounter = true
POKEMON["Christmas Squirtle"].allowedBall = "christmas"

POKEMON["Squirsaur"] = table.deepcopy(POKEMON["Squirtle"])
POKEMON["Squirsaur"].chance = 250
POKEMON["Squirsaur"].pTypes = {ELEMENT_GRASS, ELEMENT_GHOST}
POKEMON["Squirsaur"].skills = {"Tackle", 1, "Razor Leaf", 5, "Grass Whistle", 10, "Mega Drain", 15, "Spite", 20, "Leech Seed", 25, "Sleep Powder", 30, "Giga Drain", 35, "Dream Eater", 40, "Hypnosis", 45, "Leaf Storm", 50, "Shadow Ball", 55, "Solar Beam", 60, "Petal Dance", 65, "Nightmare", 70}
POKEMON["Squirsaur"].abilities = {POKEMON_ABILITIES.ROCK_SMASH, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.CUT, POKEMON_ABILITIES.FLASH, POKEMON_ABILITIES.BLINK, POKEMON_ABILITIES.TELEPORT}
POKEMON["Squirsaur"].blockTransform = true
POKEMON["Squirsaur"].evolutions = {}
POKEMON["Squirsaur"].ignoreBallCounter = true
POKEMON["Squirsaur"].allowedBall = "enchanted"
POKEMON["Squirsaur"].portrait = 28068
POKEMON["Squirsaur"].fastcallPortrait = 26698
POKEMON["Squirsaur"].specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.WATER_ABSORB, POKEMON_SPECIAL_ABILITY_IDS.ADAPTABILITY}
-- Exeggutor Base Stats
POKEMON["Squirsaur"].atk = 95
POKEMON["Squirsaur"].def = 85
POKEMON["Squirsaur"].spAtk = 125
POKEMON["Squirsaur"].spDef = 65