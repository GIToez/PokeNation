POKEMON["Weedle"] = {
    pTypes = { ELEMENT_BUG, ELEMENT_POISON },
    dexStorage = 10013,
    atk = 35,
    def = 30,
    spAtk = 20,
    spDef = 20,
    energy = 100,
    chance = 2,
    portrait = 12714,
    dexPortrait = 13514,
    fastcallPortrait = 10647,
    catchStorage = 16013,
    evolutions = { { name = "Kakuna", requiredLevel = 15 } },
    description = "Often found in forests and grasslands. It has a sharp, toxic barb of around two inches on top of its head.",
    skills = { "Tackle", 1, "Bug Bite", 5, "String Shot", 7, "Poison Sting", 10 },
    abilities = {},
    eggGroup = { POKEMON_EGG_GROUP_BUG },
    eggId = 13982,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST },
    learnableTms = false
}

POKEMON["Christmas Weedle"] = table.deepcopy(POKEMON["Weedle"])
POKEMON["Christmas Weedle"].blockTransform = true
POKEMON["Christmas Weedle"].evolutions = {}
POKEMON["Christmas Weedle"].ignoreBallCounter = true