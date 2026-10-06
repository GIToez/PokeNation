POKEMON["Hoppip"] = {
    pTypes = {ELEMENT_GRASS, ELEMENT_FLYING}, dexStorage = 10187, atk = 35, def = 40, spAtk = 35, spDef = 55, energy = 100, chance = 80, portrait = 17476, dexPortrait = 15834, fastcallPortrait = 16034, catchStorage = 16187,
    evolutions = {{name = "Skiploom", requiredLevel = 35}},
    description = "Its body is so light, it must grip the ground firmly with its feet to keep from being blown away.",
    skills = {"Tackle", 1, "Leech Seed", 5, "Mega Drain", 10, "Stun Spore", 15, "Synthesis", 20, "Bullet Seed", 25, "Giga Drain", 30},
    abilities = {"Flash", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_FAIRY, POKEMON_EGG_GROUP_GRASS}, eggId = 17754, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.CHLOROPHYLL, POKEMON_SPECIAL_ABILITY_IDS.LEAF_GUARD},
    learnableTms = {TM_IDS.ENERGY_BALL, TM_IDS.AERIAL_ACE, TM_IDS.DEFENSE_CURL, TM_IDS.GIGA_DRAIN, TM_IDS.HEADBUTT, TM_IDS.REFLECT, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.SOLAR_BEAM, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, },
    eggMoves = {"Amnesia", "Aromatherapy", "Confusion", "Cotton Guard", "Double-Edge", "Encore", "Endure", "Grassy Terrain", "Helping Hand", "Seed Bomb", "Worry Seed"}
}

POKEMON["RC Hoppip"] = table.deepcopy(POKEMON["Hoppip"])
POKEMON["RC Hoppip"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Hoppip"].blockTransform = true