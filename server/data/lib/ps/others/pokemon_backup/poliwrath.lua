POKEMON["Poliwrath"] = {
    pTypes = {ELEMENT_WATER, ELEMENT_FIGHT}, dexStorage = 10062, atk = 95, def = 95, spAtk = 70, spDef = 90, energy = 100, chance = 400, portrait = 12763, dexPortrait = 13563, fastcallPortrait = 10696, catchStorage = 16062,
    evolutions = {},
    description = "An adept swimmer, it knows the front crawl, butterfly, and more. It is faster than the best human swimmers.",
    skills = {"Tackle", 1, "Bubble", 5, "Water Gun", 10, "Hypnosis", 15, "Double Slap", 20, "Bubblebeam", 25, "Wake-Up Slap", 35, "Mud Shot", 40, "Body Slam", 45, "Submission", 55, "Rain Dance", 60, "Hydro Pump", 65, "Dynamic Punch", 70, "Ice Punch", 75},
    abilities = {POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, POKEMON_ABILITIES.WATERFALL, "Surf", "Dive", "Rock Smash", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_WATER_1}, eggId = 14003, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.WATER_ABSORB, POKEMON_SPECIAL_ABILITY_IDS.DAMP},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.POISON_JAB, TM_IDS.ROCK_TOMB, TM_IDS.WATER_PULSE, TM_IDS.DEFENSE_CURL, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.PSYWAVE, TM_IDS.SUBSTITUTE},
    eggMoves = {"Bubblebeam", "Encore", "Endeavor", "Endure", "Haze", "Ice Ball", "Mind Reader", "Mist", "Mud Shot", "Refresh", "Splash", "Water Pulse", "Water Sport"}
}

POKEMON["RC Poliwrath"] = table.deepcopy(POKEMON["Poliwrath"])
POKEMON["RC Poliwrath"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Poliwrath"].blockTransform = true