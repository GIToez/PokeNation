POKEMON["Cubone"] = {
    pTypes = {ELEMENT_GROUND}, dexStorage = 10104, atk = 50, def = 95, spAtk = 40, spDef = 50, energy = 100, chance = 100, portrait = 12805, dexPortrait = 13605, fastcallPortrait = 10738, catchStorage = 16104,
    evolutions = {{name = "Marowak", requiredLevel = 35}},
    description = "It wears the skull of its dead mother on its head. When it becomes lonesome, it is said to cry loudly.",
    skills = {"Tackle", 1, "Bone Club", 5, "Headbutt", 10, "Focus Energy", 15, "Bonemerang", 20, "Rage", 25, "Bone Rush", 30},
    abilities = {POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Headbutt", "Rock Smash"}, eggGroup = {POKEMON_EGG_GROUP_MONSTER}, eggId = 14023, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.ROCK_HEAD, POKEMON_SPECIAL_ABILITY_IDS.LIGHTNINGROD},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.FLAMETHROWER, TM_IDS.AERIAL_ACE, TM_IDS.ROCK_TOMB, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.ROCK_SLIDE, TM_IDS.SWORDS_DANCE, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE},
    eggMoves = {"Ancient Power", "Belly Drum", "Chip Away", "Detect", "Double Kick", "Endure", "Iron Head", "Perish Song", "Screech", "Skull Bash"}
}

POKEMON["RC Cubone"] = table.deepcopy(POKEMON["Cubone"])
POKEMON["RC Cubone"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Cubone"].blockTransform = true

POKEMON["Angry Cubone"] = table.deepcopy(POKEMON["Cubone"])