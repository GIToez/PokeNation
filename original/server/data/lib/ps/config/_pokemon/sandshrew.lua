POKEMON["Sandshrew"] = {
    pTypes = { ELEMENT_GROUND },
    dexStorage = 10027,
    atk = 75,
    def = 85,
    spAtk = 20,
    spDef = 30,
    energy = 100,
    chance = 30,
    portrait = 12728,
    dexPortrait = 13528,
    fastcallPortrait = 10661,
    catchStorage = 16027,
    evolutions = { { name = "Sandslash", requiredLevel = 40 } },
    description = "It burrows and lives underground. If threatened, it curls itself up into a ball for protection.",
    skills = { "Tackle", 1, "Sand-Attack", 5, "Rollout", 10, "Mud Shot", 15, "Poison Sting", 20, "Swift", 25, "Sand Tomb", 30, "Magnitude", 35 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Cut", "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 13988,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.SAND_VEIL },
    learnableTms = { TM_IDS.POISON_JAB, TM_IDS.AERIAL_ACE, TM_IDS.ROCK_TOMB, TM_IDS.FURY_CUTTER, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.SUBMISSION, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE },
    eggMoves = { "Chip Away", "Counter", "Crush Claw", "Endure", "Flail", "Metal Claw", "Mud Shot", "Night Slash", "Rapid Spin", "Rock Climb", "Rototiller" }
}

POKEMON["RC Sandshrew"] = table.deepcopy(POKEMON["Sandshrew"])
POKEMON["RC Sandshrew"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Sandshrew"].blockTransform = true

POKEMON["Angry Sandshrew"] = table.deepcopy(POKEMON["Sandshrew"])

POKEMON["Christmas Sandshrew"] = table.deepcopy(POKEMON["Sandshrew"])
POKEMON["Christmas Sandshrew"].blockTransform = true
POKEMON["Christmas Sandshrew"].evolutions = {}
POKEMON["Christmas Sandshrew"].ignoreBallCounter = true