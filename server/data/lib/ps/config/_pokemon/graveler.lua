POKEMON["Graveler"] = {
    pTypes = { ELEMENT_ROCK, ELEMENT_GROUND },
    dexStorage = 10075,
    atk = 95,
    def = 115,
    spAtk = 45,
    spDef = 45,
    energy = 100,
    chance = 250,
    portrait = 12776,
    dexPortrait = 13576,
    fastcallPortrait = 10709,
    catchStorage = 16075,
    evolutions = { { name = "Golem", requiredLevel = 50 } },
    description = "Be careful while hiking on mountain trails. GRAVELER may come rolling down the path without slowing.",
    skills = { "Tackle", 1, "Rock Throw", 5, "Defense Curl", 10, "Magnitude", 15, "Rock Blast", 20, "Explosion", 25, "Earthquake", 35, "Double-Edge", 40, "Rock Slide", 45 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_MINERAL },
    eggId = 14008,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.ROCK_HEAD, POKEMON_SPECIAL_ABILITY_IDS.STURDY },
    learnableTms = { TM_IDS.FLAMETHROWER, TM_IDS.ROCK_TOMB, TM_IDS.FIRE_PUNCH, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.SELFDESTRUCT, TM_IDS.FIRE_BLAST, TM_IDS.REST, TM_IDS.EXPLOSION, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE },
    eggMoves = { "Autotomize", "Block", "Curse", "Endure", "Flail", "Focus Punch", "Hammer Arm", "Mega Punch", "Rock Climb", "Wide Guard" }
}

POKEMON["RC Graveler"] = table.deepcopy(POKEMON["Graveler"])
POKEMON["RC Graveler"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Graveler"].blockTransform = true