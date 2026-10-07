POKEMON["Electabuzz"] = {
    pTypes = {ELEMENT_ELECTRIC}, dexStorage = 10125, atk = 83, def = 57, spAtk = 95, spDef = 85, energy = 100, chance = 800, portrait = 12826, dexPortrait = 13626, fastcallPortrait = 10759, catchStorage = 16125,
    evolutions = {},
    description = "It loves to feed on strong electricity. It occasionally appears around large power plants and so on.",
    skills = {"Tackle", 1, "Quick Attack", 5, "Thunder Shock", 10, "Low Kick", 15, "Swift", 20, "Electro Ball", 25, "Thunder Punch", 30, "Discharge", 35, "Thunderbolt", 40, "Thunder", 45, "Thunder Wave", 50},
    abilities = {POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Flash", "Rock Smash", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_HUMAN_LIKE}, eggId = 14038, eggChance = 1,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.STATIC},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.PSYWAVE, TM_IDS.SUBSTITUTE},
    eggMoves = {"Barrier", "Cross Chop", "Dynamic Punch", "Feint", "Fire Punch", "Focus Punch", "Hammer Arm", "Ice Punch", "Karate Chop" ,"Meditate", "Rolling Kick"}
}

POKEMON["RC Electabuzz"] = table.deepcopy(POKEMON["Electabuzz"])
POKEMON["RC Electabuzz"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Electabuzz"].blockTransform = true

POKEMON["Cloned Electabuzz"] = table.deepcopy(POKEMON["Electabuzz"])
POKEMON["Cloned Electabuzz"].blockTransform = true