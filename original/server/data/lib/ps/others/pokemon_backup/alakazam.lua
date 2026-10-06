POKEMON["Alakazam"] = {
    pTypes = {ELEMENT_PSYCHIC}, dexStorage = 10065, atk = 50, def = 45, spAtk = 135, spDef = 95, energy = 100, chance = 800, portrait = 12766, dexPortrait = 13566, fastcallPortrait = 10699, catchStorage = 16065,
    evolutions = {},
    description = "It does not like physical attacks very much. Instead, it freely uses extra-sensory powers to defeat foes.",
    skills = {"Tackle", 1, "Confusion", 5, "Calm Mind", 10, "Mist Ball", 15, "Recover", 20, "Disable", 25, "Psybeam", 35, "Psychic", 40, "Psycho Cut", 45, "Reflect", 55, "Future Sight", 60},
    abilities = {POKEMON_ABILITIES.DIG, "Blink", "Flash", "Teleport", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_HUMAN_LIKE}, eggId = 14004, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.SYNCHRONIZE, POKEMON_SPECIAL_ABILITY_IDS.INNER_FOCUS},
    learnableTms = {TM_IDS.DRAIN_PUNCH, TM_IDS.ENERGY_BALL, TM_IDS.NIGHTMARE, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.ICE_PUNCH, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.DREAM_EATER, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.HYPER_BEAM, TM_IDS.DOUBLE_EDGE, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.PSYWAVE, TM_IDS.TRI_ATTACK, TM_IDS.SUBSTITUTE},
    eggMoves = {"Ally Switch", "Barrier", "Encore", "Fire Punch", "Guard Split", "Guard Swap", "Ice Punch", "Knock Off", "Power Trick", "Psycho Shift", "Skill Swap", "Thunder Punch"}
}

POKEMON["RC Alakazam"] = table.deepcopy(POKEMON["Alakazam"])
POKEMON["RC Alakazam"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Alakazam"].blockTransform = true

POKEMON["Cloned Alakazam"] = table.deepcopy(POKEMON["Alakazam"])
POKEMON["Cloned Alakazam"].blockTransform = true