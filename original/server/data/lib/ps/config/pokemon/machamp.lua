POKEMON["Machamp"] = {
    pTypes = { ELEMENT_FIGHT },
    dexStorage = 10068,
    atk = 130,
    def = 80,
    spAtk = 65,
    spDef = 85,
    energy = 100,
    chance = 400,
    portrait = 12769,
    dexPortrait = 13569,
    fastcallPortrait = 10702,
    catchStorage = 16068,
    evolutions = {},
    description = "Its four ruggedly developed arms can launch a flurry of 1,000 punches in just two seconds.",
    skills = { "Tackle", 1, "Low Kick", 5, "Karate Chop", 10, "Seismic Toss", 15, "Cross Chop", 20, "Scary Face", 25, "Focus Energy", 35, "Wake-Up Slap", 40, "Dynamic Punch", 45, "Revenge", 55, "Vital Throw", 60, "Submission", 65, "Bulk Up", 70 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_HUMAN_LIKE },
    eggId = 14005,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.GUTS, POKEMON_SPECIAL_ABILITY_IDS.NO_GUARD },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.POISON_JAB, TM_IDS.FLAMETHROWER, TM_IDS.ROCK_TOMB, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.RAIN_DANCE, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE, TM_IDS.FOCUS_PUNCH, TM_IDS.BULK_UP, TM_IDS.LIGHT_SCREEN, TM_IDS.BRICK_BREAK },
    eggMoves = { "Bullet Punch", "Close Combat", "Counter", "Encore", "Fire Punch", "Heavy Slam", "Ice Punch", "Knock Off", "Meditate", "Power Trick", "Quick Guard", "Rolling Kick", "Smelling Salts", "Thunder Punch", "Tickle" }
}

POKEMON["RC Machamp"] = table.deepcopy(POKEMON["Machamp"])
POKEMON["RC Machamp"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Machamp"].blocTraknsform = true

POKEMON["Cloned Machamp"] = table.deepcopy(POKEMON["Machamp"])
POKEMON["Cloned Machamp"].blockTransform = true