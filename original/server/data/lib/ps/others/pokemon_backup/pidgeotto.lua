POKEMON["Pidgeotto"] = {
    pTypes = {ELEMENT_NORMAL, ELEMENT_FLYING}, dexStorage = 10017, atk = 60, def = 55, spAtk = 50, spDef = 50, energy = 100, chance = 200, portrait = 12718, dexPortrait = 13518, fastcallPortrait = 10651, catchStorage = 16017,
    evolutions = {{name = "Pidgeot", requiredLevel = 55}},
    description = "The claws on its feet are well developed. It can carry prey such as an EXEGGCUTE to its nest over 60 miles away.",
    skills = {"Tackle", 1, "Sand-Attack", 5, "Gust", 10, "Quick Attack", 15, "Drill Peck", 20, "Hurricane", 25, "Feather Dance", 30, "Wing Attack", 35, "Roost", 40, "Air Cutter", 45, "Steel Wing", 50},
    abilities = {"Find"}, eggGroup = {POKEMON_EGG_GROUP_FLYING}, eggId = 13983, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.KEEN_EYE, POKEMON_SPECIAL_ABILITY_IDS.TANGLED_FEET},
    learnableTms = {TM_IDS.AERIAL_ACE, TM_IDS.STEEL_WING, TM_IDS.MUD_SLAP, TM_IDS.RAIN_DANCE, TM_IDS.RAZOR_WIND, TM_IDS.WHIRLWIND, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.SKY_ATTACK, TM_IDS.REST, TM_IDS.SUBSTITUTE},
    eggMoves = {"Air Cutter", "Air Slash", "Brave Bird", "Defog", "Faint Attack", "Foresight", "Pursuit", "Steel Wing", "Uproar"}
}

POKEMON["RC Pidgeotto"] = table.deepcopy(POKEMON["Pidgeotto"])
POKEMON["RC Pidgeotto"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Pidgeotto"].blockTransform = true