POKEMON["Golbat"] = {
    pTypes = {ELEMENT_POISON, ELEMENT_FLYING}, dexStorage = 10042, atk = 80, def = 70, spAtk = 65, spDef = 75, energy = 100, chance = 200, portrait = 12743, dexPortrait = 13543, fastcallPortrait = 10676, catchStorage = 16042,
    evolutions = {{name = "Crobat", requiredLevel = 50, requiredItems = {ITEMS.SOOTHE_BELL}}},
    description = "It clamps down on its prey with needle-sharp fangs and drains over 10 ounces of blood in one gulp.",
    skills = {"Tackle", 1, "Leech Life", 5, "Bite", 10, "Supersonic", 15, "Wing Attack", 20, "Confuse Ray", 25, "Poison Fang", 30, "Air Slash", 40, "Air Cutter", 45},
    abilities = {"Find"}, eggGroup = {POKEMON_EGG_GROUP_FLYING}, eggId = 13994, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.INNER_FOCUS},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.AERIAL_ACE, TM_IDS.STEEL_WING, TM_IDS.SLUDGE_BOMB, TM_IDS.SHADOW_BALL, TM_IDS.GIGA_DRAIN, TM_IDS.RAIN_DANCE, TM_IDS.RAZOR_WIND, TM_IDS.WHIRLWIND, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MEGA_DRAIN, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.REST, TM_IDS.SUBSTITUTE},
    eggMoves = {"Brave Bird", "Curse", "Defog", "Faint Attack", "Giga Drain", "Gust", "Hypnosis", "Nasty Plot", "Pursuit", "Quick Attack", "Steel Wing", "Venom Drench", "Whirlwind", "Zen Headbutt"}
}

POKEMON["RC Golbat"] = table.deepcopy(POKEMON["Golbat"])
POKEMON["RC Golbat"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Golbat"].blockTransform = true