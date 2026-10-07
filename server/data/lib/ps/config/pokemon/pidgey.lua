POKEMON["Pidgey"] = {
    pTypes = { ELEMENT_NORMAL, ELEMENT_FLYING },
    dexStorage = 10016,
    atk = 45,
    def = 40,
    spAtk = 35,
    spDef = 35,
    energy = 100,
    chance = 10,
    portrait = 12717,
    dexPortrait = 13517,
    fastcallPortrait = 10650,
    catchStorage = 16016,
    evolutions = { { name = "Pidgeotto", requiredLevel = 30 } },
    description = "Does not like to fight. It hides in tall grass and so on, foraging for food such as small bugs.",
    skills = { "Tackle", 1, "Gust", 5, "Quick Attack", 10, "Sand-Attack", 15, "Drill Peck", 20, "Wing Attack", 25 },
    abilities = { "Find" },
    eggGroup = { POKEMON_EGG_GROUP_FLYING },
    eggId = 13983,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.KEEN_EYE, POKEMON_SPECIAL_ABILITY_IDS.TANGLED_FEET },
    learnableTms = { TM_IDS.AERIAL_ACE, TM_IDS.STEEL_WING, TM_IDS.MUD_SLAP, TM_IDS.RAIN_DANCE, TM_IDS.RAZOR_WIND, TM_IDS.WHIRLWIND, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.SKY_ATTACK, TM_IDS.REST, TM_IDS.SUBSTITUTE },
    eggMoves = { "Air Cutter", "Air Slash", "Brave Bird", "Defog", "Faint Attack", "Foresight", "Pursuit", "Steel Wing", "Uproar" }
}

POKEMON["RC Pidgey"] = table.deepcopy(POKEMON["Pidgey"])
POKEMON["RC Pidgey"].blockTransform = true

POKEMON["Christmas Pidgey"] = table.deepcopy(POKEMON["Pidgey"])
POKEMON["Christmas Pidgey"].blockTransform = true
POKEMON["Christmas Pidgey"].evolutions = {}
POKEMON["Christmas Pidgey"].ignoreBallCounter = true