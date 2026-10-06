POKEMON["Ditto"] = {
    pTypes = { ELEMENT_NORMAL },
    dexStorage = 10132,
    atk = 48,
    def = 48,
    spAtk = 48,
    spDef = 48,
    energy = 100,
    chance = 1500,
    portrait = 12833,
    dexPortrait = 13633,
    fastcallPortrait = 10766,
    catchStorage = 16132,
    evolutions = {},
    description = "It can freely recombine its own cellular structure to transform into other life-forms.",
    skills = { "Tackle", 1 --[[, "Transform", 10]] },
    abilities = { "Transform" },
    eggGroup = { POKEMON_EGG_GROUP_DITTO },
    eggId = 0,
    eggChance = 10,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.LIMBER },
    learnableTms = false
}

POKEMON["Unsettled Ditto"] = table.deepcopy(POKEMON["Ditto"])