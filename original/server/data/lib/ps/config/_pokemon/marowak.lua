POKEMON["Marowak"] = {
    pTypes = { ELEMENT_GROUND },
    dexStorage = 10105,
    atk = 80,
    def = 110,
    spAtk = 50,
    spDef = 80,
    energy = 100,
    chance = 400,
    portrait = 12806,
    dexPortrait = 13606,
    fastcallPortrait = 10739,
    catchStorage = 16105,
    evolutions = {},
    description = "It is small and was originally very weak. Its temperament turned ferocious when it began using bones.",
    skills = { "Tackle", 1, "Bone Club", 5, "Headbutt", 10, "Bonemerang", 15, "Rage", 20, "Bone Rush", 25, "Focus Energy", 30, "Earth Power", 40, "Iron Tail", 45, "Thrash", 50, "Earthquake", 55, "Smack Down", 60, "Double-Edge", 65, "Skull Bash", 70 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Headbutt", "Rock Smash" },
    eggGroup = { POKEMON_EGG_GROUP_MONSTER },
    eggId = 14023,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.ROCK_HEAD, POKEMON_SPECIAL_ABILITY_IDS.LIGHTNINGROD },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.FLAMETHROWER, TM_IDS.AERIAL_ACE, TM_IDS.ROCK_TOMB, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.ROCK_SLIDE, TM_IDS.SWORDS_DANCE, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE },
    eggMoves = { "Ancient Power", "Belly Drum", "Chip Away", "Detect", "Double Kick", "Endure", "Iron Head", "Perish Song", "Screech", "Skull Bash" }
}

POKEMON["RC Marowak"] = table.deepcopy(POKEMON["Marowak"])
POKEMON["RC Marowak"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Marowak"].blockTransform = true

POKEMON["Cloned Marowak"] = table.deepcopy(POKEMON["Marowak"])
POKEMON["Cloned Marowak"].blockTransform = true