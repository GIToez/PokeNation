POKEMON["Caterpie"] = {
    pTypes = {ELEMENT_BUG}, dexStorage = 10010, atk = 30, def = 35, spAtk = 20, spDef = 20, energy = 100, chance = 2, portrait = 12711, dexPortrait = 13511, fastcallPortrait = 10644, catchStorage = 16010,
    evolutions = {{name = "Metapod", requiredLevel = 15}},
    description = "It is covered with a green skin. When it grows, it sheds the skin, covers itself with silk, and becomes a cocoon.",
    skills = {"Tackle", 1, "Bug Bite", 5, "String Shot", 7, "Headbutt", 10},
    abilities = {"Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_BUG}, eggId = 13981, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST},
    learnableTms = false
}

POKEMON["RC Caterpie"] = table.deepcopy(POKEMON["Caterpie"])
POKEMON["RC Caterpie"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Caterpie"].blockTransform = true

POKEMON["Christmas Caterpie"] = table.deepcopy(POKEMON["Caterpie"])
POKEMON["Christmas Caterpie"].blockTransform = true
POKEMON["Christmas Caterpie"].evolutions = {}
POKEMON["Christmas Caterpie"].ignoreBallCounter = true
POKEMON["Christmas Caterpie"].allowedBall = "christmas"