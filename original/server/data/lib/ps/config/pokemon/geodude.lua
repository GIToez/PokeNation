POKEMON["Geodude"] = {
    pTypes = { ELEMENT_ROCK, ELEMENT_GROUND },
    dexStorage = 10074,
    atk = 80,
    def = 100,
    spAtk = 30,
    spDef = 30,
    energy = 100,
    chance = 30,
    portrait = 12775,
    dexPortrait = 13575,
    fastcallPortrait = 10708,
    catchStorage = 16074,
    evolutions = { { name = "Graveler", requiredLevel = 30 } },
    description = "Its round form makes it easy to pick up. Some people have used them to hurl at each other in a snowball fight.",
    skills = { "Tackle", 1, "Rock Throw", 5, "Defense Curl", 10, "Magnitude", 15, "Rock Blast", 20, "Selfdestruct", 25 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_MINERAL },
    eggId = 14008,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.ROCK_HEAD, POKEMON_SPECIAL_ABILITY_IDS.STURDY },
    learnableTms = { TM_IDS.FLAMETHROWER, TM_IDS.ROCK_TOMB, TM_IDS.FIRE_PUNCH, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.SELFDESTRUCT, TM_IDS.FIRE_BLAST, TM_IDS.REST, TM_IDS.EXPLOSION, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE, TM_IDS.FOCUS_PUNCH, TM_IDS.BRICK_BREAK, TM_IDS.SANDSTORM },
    eggMoves = { "Autotomize", "Block", "Curse", "Endure", "Flail", "Focus Punch", "Hammer Arm", "Mega Punch", "Rock Climb", "Wide Guard" }
}

POKEMON["Christmas Geodude"] = table.deepcopy(POKEMON["Geodude"])
POKEMON["Christmas Geodude"].blockTransform = true
POKEMON["Christmas Geodude"].evolutions = {}
POKEMON["Christmas Geodude"].ignoreBallCounter = true