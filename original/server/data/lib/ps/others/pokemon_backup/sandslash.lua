POKEMON["Sandslash"] = {
    pTypes = {ELEMENT_GROUND}, dexStorage = 10028, atk = 100, def = 110, spAtk = 45, spDef = 55, energy = 100, chance = 350, portrait = 12729, dexPortrait = 13529, fastcallPortrait = 10662, catchStorage = 16028,
    evolutions = {},
    description = "It is adept at attacking with the spines on its back and its sharp claws while quickly scurrying about.",
    skills = {"Tackle", 1, "Defense Curl", 5, "Earth Power", 10, "Sand-Attack", 15, "Mud Shot", 20, "Rollout", 25, "Sand Tomb", 30, "Rock Slide", 35, "Swift", 45, "Fury Swipes", 50, "Crush Claw", 55, "Slash", 60, "Poison Sting", 65},
    abilities = {POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Cut", "Rock Smash", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_FIELD}, eggId = 13988, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.SAND_VEIL},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.POISON_JAB, TM_IDS.AERIAL_ACE, TM_IDS.ROCK_TOMB, TM_IDS.FURY_CUTTER, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.SUBMISSION, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE},
    eggMoves = {"Chip Away", "Counter", "Crush Claw", "Endure", "Flail", "Metal Claw", "Mud Shot", "Night Slash", "Rapid Spin", "Rock Climb", "Rototiller"}
}

POKEMON["RC Sandslash"] = table.deepcopy(POKEMON["Sandslash"])
POKEMON["RC Sandslash"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Sandslash"].blockTransform = true