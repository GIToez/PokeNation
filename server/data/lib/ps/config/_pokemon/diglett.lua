POKEMON["Diglett"] = {
    pTypes = { ELEMENT_GROUND },
    dexStorage = 10050,
    atk = 55,
    def = 25,
    spAtk = 35,
    spDef = 45,
    energy = 100,
    chance = 10,
    portrait = 12751,
    dexPortrait = 13551,
    fastcallPortrait = 10684,
    catchStorage = 16050,
    evolutions = { { name = "Dugtrio", requiredLevel = 30 } },
    description = "It burrows through the ground at a shallow depth. It leaves raised earth in its wake, making it easy to spot.",
    skills = { "Tackle", 1, "Scratch", 5, "Sand-Attack", 10, "Magnitude", 15, "Mud Bomb", 20, "Slash", 25 },
    abilities = { POKEMON_ABILITIES.DIG, "Cut" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 13998,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.SAND_VEIL, POKEMON_SPECIAL_ABILITY_IDS.ARENA_TRAP },
    learnableTms = { TM_IDS.AERIAL_ACE, TM_IDS.ROCK_TOMB, TM_IDS.SLUDGE_BOMB, TM_IDS.MUD_SLAP, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.REST, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE },
    eggMoves = { "Ancient Power", "Astonish", "Beat Up", "Endure", "Faint Attack", "Final Gambit", "Headbutt", "Memento", "Mud Bomb", "Pursuit", "Reversal", "Screech", "Uproar" }
}

POKEMON["Angry Diglett"] = table.deepcopy(POKEMON["Diglett"])

POKEMON["Christmas Diglett"] = table.deepcopy(POKEMON["Diglett"])
POKEMON["Christmas Diglett"].blockTransform = true
POKEMON["Christmas Diglett"].evolutions = {}
POKEMON["Christmas Diglett"].ignoreBallCounter = true