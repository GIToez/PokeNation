POKEMON["Machop"] = {
    pTypes = { ELEMENT_FIGHT },
    dexStorage = 10066,
    atk = 80,
    def = 50,
    spAtk = 35,
    spDef = 35,
    energy = 100,
    chance = 50,
    portrait = 12767,
    dexPortrait = 13567,
    fastcallPortrait = 10700,
    catchStorage = 16066,
    evolutions = { { name = "Machoke", requiredLevel = 30 } },
    description = "Its whole body is composed of muscles. Even though it's the size of a human child, it can hurl 100 grown-ups.",
    skills = { "Tackle", 1, "Low Kick", 5, "Karate Chop", 10, "Seismic Toss", 15, "Cross Chop", 20, "Scary Face", 25 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_HUMAN_LIKE },
    eggId = 14005,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.GUTS, POKEMON_SPECIAL_ABILITY_IDS.NO_GUARD },
    learnableTms = { TM_IDS.POISON_JAB, TM_IDS.FLAMETHROWER, TM_IDS.ROCK_TOMB, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.RAIN_DANCE, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE, TM_IDS.FOCUS_PUNCH, TM_IDS.BULK_UP, TM_IDS.LIGHT_SCREEN, TM_IDS.BRICK_BREAK },
    eggMoves = { "Bullet Punch", "Close Combat", "Counter", "Encore", "Fire Punch", "Heavy Slam", "Ice Punch", "Knock Off", "Meditate", "Power Trick", "Quick Guard", "Rolling Kick", "Smelling Salts", "Thunder Punch", "Tickle" }
}

POKEMON["Christmas Machop"] = table.deepcopy(POKEMON["Machop"])
POKEMON["Christmas Machop"].blockTransform = true
POKEMON["Christmas Machop"].evolutions = {}
POKEMON["Christmas Machop"].ignoreBallCounter = true