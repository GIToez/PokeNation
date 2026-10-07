POKEMON["Spearow"] = {
    pTypes = {ELEMENT_NORMAL, ELEMENT_FLYING}, dexStorage = 10021, atk = 60, def = 30, spAtk = 31, spDef = 31, energy = 100, chance = 20, portrait = 12722, dexPortrait = 13522, fastcallPortrait = 10655, catchStorage = 16021,
    evolutions = {{name = "Fearow", requiredLevel = 35}},
    description = "It busily flits around here and there. Even if it is frail, it can be a tough foe that uses MIRROR MOVE.",
    skills = {"Tackle", 1, "Peck", 5, "Drill Run", 10, "Gust", 15, "Pursuit", 20, "Agility", 25, "Roost", 30},
    abilities = {"Find"}, eggGroup = {POKEMON_EGG_GROUP_FLYING}, eggId = 13985, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.KEEN_EYE},
    learnableTms = {TM_IDS.AERIAL_ACE, TM_IDS.STEEL_WING, TM_IDS.MUD_SLAP, TM_IDS.RAIN_DANCE, TM_IDS.RAZOR_WIND, TM_IDS.WHIRLWIND, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.SKY_ATTACK, TM_IDS.REST, TM_IDS.SUBSTITUTE},
    eggMoves = {"Astonish", "Feather Dance", "Faint Attack", "Quick Attack", "Razor Wind", "Sacry Face", "Sky Attack", "Steel Wing", "Tri Attack", "Uproar", "Whirlwind"}
}

POKEMON["Christmas Spearow"] = table.deepcopy(POKEMON["Spearow"])
POKEMON["Christmas Spearow"].blockTransform = true
POKEMON["Christmas Spearow"].evolutions = {}
POKEMON["Christmas Spearow"].ignoreBallCounter = true
POKEMON["Christmas Spearow"].allowedBall = "christmas"