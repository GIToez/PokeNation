POKEMON["Golem"] = {
    pTypes = { ELEMENT_ROCK, ELEMENT_GROUND },
    dexStorage = 10076,
    atk = 120,
    def = 130,
    spAtk = 55,
    spDef = 65,
    energy = 100,
    chance = 500,
    portrait = 12777,
    dexPortrait = 13577,
    fastcallPortrait = 10710,
    catchStorage = 16076,
    evolutions = {},
    description = "It is enclosed in a hard shell that is as rugged as slabs of rock. It sheds skin once a year to grow larger.",
    skills = { "Tackle", 1, "Rock Throw", 5, "Defense Curl", 10, "Magnitude", 15, "Rock Blast", 20, "Explosion", 25, "Earthquake", 35, "Rock Slide", 40, "Double-Edge", 45, "Stealth Rock", 55, "Rollout", 60 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_MINERAL },
    eggId = 14008,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.ROCK_HEAD, POKEMON_SPECIAL_ABILITY_IDS.STURDY },
    learnableTms = { TM_IDS.FLAMETHROWER, TM_IDS.ROCK_TOMB, TM_IDS.FURY_CUTTER, TM_IDS.FIRE_PUNCH, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.METRONOME, TM_IDS.SELFDESTRUCT, TM_IDS.FIRE_BLAST, TM_IDS.REST, TM_IDS.EXPLOSION, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE },
    eggMoves = { "Autotomize", "Block", "Curse", "Endure", "Flail", "Focus Punch", "Hammer Arm", "Mega Punch", "Rock Climb", "Wide Guard" }
}

POKEMON["RC Golem"] = table.deepcopy(POKEMON["Golem"])
POKEMON["RC Golem"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Golem"].blockTransform = true

POKEMON["Suramoon Golem"] = table.deepcopy(POKEMON["Golem"])
POKEMON["Suramoon Golem"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["Suramoon Golem"].blockTransform = true
POKEMON["Suramoon Golem"].atk = 105 * 6
POKEMON["Suramoon Golem"].def = 60 * 3
POKEMON["Suramoon Golem"].spAtk = 60 * 6
POKEMON["Suramoon Golem"].spDef = 70 * 3

POKEMON["Cloned Golem"] = table.deepcopy(POKEMON["Golem"])
POKEMON["Cloned Golem"].blockTransform = true