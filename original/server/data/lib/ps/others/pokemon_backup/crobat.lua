POKEMON["Crobat"] = {
    pTypes = {ELEMENT_POISON, ELEMENT_FLYING}, dexStorage = 10169, atk = 90, def = 80, spAtk = 70, spDef = 80, energy = 100, chance = 800, portrait = 17458, dexPortrait = 15816, fastcallPortrait = 16016, catchStorage = 16169,
    evolutions = {},
    description = "The development of wings on its legs enables it to fly fast but also makes it tough to stop and rest.",
    skills = {"Tackle", 1, "Leech Life", 5, "Bite", 10, "Supersonic", 15, "Wing Attack", 20, "Confuse Ray", 25, "Poison Fang", 30, "Air Slash", 40, "Air Cutter", 45, "Cross Poison", 55, "Screech", 60, "Swift", 65, "Acrobatics", 70, "Haze", 75},
    abilities = {"Find", "Fly"}, eggGroup = {POKEMON_EGG_GROUP_FLYING}, eggId = 13994, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.INNER_FOCUS},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.AERIAL_ACE, TM_IDS.STEEL_WING, TM_IDS.SLUDGE_BOMB, TM_IDS.SHADOW_BALL, TM_IDS.GIGA_DRAIN, TM_IDS.RAIN_DANCE, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, },
    eggMoves = {"Brave Bird", "Curse", "Defog", "Faint Attack", "Giga Drain", "Gust", "Hypnosis", "Nasty Plot", "Pursuit", "Quick Attack", "Steel Wing", "Venom Drench", "Whirlwind", "Zen Headbutt"}
}

POKEMON["Cloned Crobat"] = table.deepcopy(POKEMON["Crobat"])
POKEMON["Cloned Crobat"].blockTransform = true