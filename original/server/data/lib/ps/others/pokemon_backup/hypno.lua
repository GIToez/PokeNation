POKEMON["Hypno"] = {
    pTypes = {ELEMENT_PSYCHIC}, dexStorage = 10097, atk = 73, def = 70, spAtk = 73, spDef = 115, energy = 100, chance = 500, portrait = 12798, dexPortrait = 13598, fastcallPortrait = 10731, catchStorage = 16097,
    evolutions = {},
    description = "It carries a pendulum-like device. There once was an incident in which it took away a child it hypnotized.",
    skills = {"Tackle", 1, "Pound", 5, "Hypnosis", 10, "Dream Eater", 15, "Confusion", 20, "Zen Headbutt", 25, "Psychic", 30, "Psybeam", 35, "Meditate", 45, "Poison Gas", 50, "Future Sight", 55, "Disable", 60},
    abilities = {"Blink", "Teleport", "Flash", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_HUMAN_LIKE}, eggId = 14019, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.INSOMNIA--[[, POKEMON_SPECIAL_ABILITY_IDS.FOREWARN]]},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.DRAIN_PUNCH, TM_IDS.NIGHTMARE, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.ICE_PUNCH, TM_IDS.SHADOW_BALL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.SKULL_BASH, TM_IDS.DREAM_EATER, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.PSYWAVE, TM_IDS.TRI_ATTACK, TM_IDS.SUBSTITUTE},
    eggMoves = {"Assist", "Barrier", "Fire Punch", "Flatter", "Guard Swap", "Ice Punch", "Nasty Plot", "Psycho Cut", "Role Play", "Secret Power", "Skill Swap", "Thunder Punch"}
}

POKEMON["RC Hypno"] = table.deepcopy(POKEMON["Hypno"])
POKEMON["RC Hypno"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Hypno"].blockTransform = true