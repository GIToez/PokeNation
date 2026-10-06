POKEMON["Grimer"] = {
    pTypes = { ELEMENT_POISON },
    dexStorage = 10088,
    atk = 80,
    def = 50,
    spAtk = 40,
    spDef = 50,
    energy = 100,
    chance = 15,
    portrait = 12789,
    dexPortrait = 13589,
    fastcallPortrait = 10722,
    catchStorage = 16088,
    evolutions = { { name = "Muk", requiredLevel = 35 } },
    description = "Sludge exposed to X rays from the moon transformed into GRIMER. It loves feeding on filthy things.",
    skills = { "Tackle", 1, "Pound", 5, "Sludge", 10, "Acid Armor", 15, "Poison Gas", 20, "Mud Bomb", 25, "Sludge Bomb", 30 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH },
    eggGroup = { POKEMON_EGG_GROUP_AMORPHOUS },
    eggId = 14015,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.STENCH , POKEMON_SPECIAL_ABILITY_IDS.STICKY_HOLD },
    learnableTms = { TM_IDS.POISON_JAB, TM_IDS.FLAMETHROWER, TM_IDS.ROCK_TOMB, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.SLUDGE_BOMB, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.GIGA_DRAIN, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.DYNAMIC_PUNCH, TM_IDS.ROCK_SLIDE, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.RAGE, TM_IDS.MEGA_DRAIN, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SELFDESTRUCT, TM_IDS.FIRE_BLAST, TM_IDS.REST, TM_IDS.EXPLOSION, TM_IDS.SUBSTITUTE },
    eggMoves = { "Acid Spray", "Curse", "Haze", "Imprison", "Lick", "Mean Look", "Scary Face", "Shadow Punch", "Shadow Sneak" --[[, "Spit Up", "Stockpile", "Swallow"]] }
}

POKEMON["Christmas Grimer"] = table.deepcopy(POKEMON["Grimer"])
POKEMON["Christmas Grimer"].blockTransform = true
POKEMON["Christmas Grimer"].evolutions = {}
POKEMON["Christmas Grimer"].ignoreBallCounter = true