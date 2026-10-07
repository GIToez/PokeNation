POKEMON["Gengar"] = {
    pTypes = { ELEMENT_GHOST, ELEMENT_POISON },
    dexStorage = 10094,
    atk = 65,
    def = 60,
    spAtk = 130,
    spDef = 75,
    energy = 100,
    chance = 800,
    portrait = 12795,
    dexPortrait = 13595,
    fastcallPortrait = 10728,
    catchStorage = 16094,
    evolutions = {},
    description = "It is said to emerge from darkness to steal the lives of those who become lost in mountains.",
    skills = { "Tackle", 1, "Lick", 5, "Night Shade", 10, "Hypnosis", 15, "Dream Eater", 20, "Curse", 25, "Spite", 30, "Confuse Ray", 40, "Sucker Punch", 45, "Dark Pulse", 50, "Payback", 60, "Hex", 65, "Nightmare", 70 },
    abilities = { POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Levitate", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_AMORPHOUS },
    eggId = 14017,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.LEVITATE },
    learnableTms = { TM_IDS.POISON_JAB, TM_IDS.DRAIN_PUNCH, TM_IDS.ENERGY_BALL, TM_IDS.NIGHTMARE, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.SLUDGE_BOMB, TM_IDS.ICE_PUNCH, TM_IDS.SHADOW_BALL, TM_IDS.GIGA_DRAIN, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMC_TOSS, TM_IDS.RAGE, TM_IDS.MEGA_DRAIN, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.SELFDESTRUCT, TM_IDS.SKULL_BASH, TM_IDS.DREAM_EATER, TM_IDS.REST, TM_IDS.PSYWAVE, TM_IDS.EXPLOSION, TM_IDS.SUBSTITUTE, TM_IDS.FOCUS_PUNCH, TM_IDS.TAUNT, TM_IDS.BRICK_BREAK },
    eggMoves = { "Astonish", "Clear Smog", "Disable", "Fire Punch", "Grudge", "Haze", "Ice Punch", "Perish Song", "Psywave", "Reflect Type", "Scary Face", "Smog", "Thunder Punch" }
}

POKEMON["RC Gengar"] = table.deepcopy(POKEMON["Gengar"])
POKEMON["RC Gengar"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Gengar"].blockTransform = true

POKEMON["Cloned Gengar"] = table.deepcopy(POKEMON["Gengar"])
POKEMON["Cloned Gengar"].blockTransform = true