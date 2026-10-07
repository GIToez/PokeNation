POKEMON["Gyarados"] = {
    pTypes = { ELEMENT_WATER, ELEMENT_FLYING },
    dexStorage = 10130,
    atk = 125,
    def = 79,
    spAtk = 60,
    spDef = 100,
    energy = 100,
    chance = 800,
    portrait = 12831,
    dexPortrait = 13631,
    fastcallPortrait = 10764,
    catchStorage = 16130,
    evolutions = {},
    description = "It has an extremely aggressive nature. The HYPER BEAM it shoots from its mouth totally incinerates all targets.",
    skills = { "Tackle", 1, "Bite", 5, "Headbutt", 10, "Dragon Rage", 15, "Ice Fang", 20, "Thrash", 25, "Aqua Tail", 30, "Twister", 35, "Hydro Pump", 40, "Crunch", 45, "Hydro Cannon", 50, "Dragon Dance", 55, "Hyper Beam", 60, "Bounce", 65 },
    abilities = { POKEMON_ABILITIES.STRENGTH, POKEMON_ABILITIES.WATERFALL, "Headbutt", "Surf", "Dive", "Rock Smash" },
    eggGroup = { POKEMON_EGG_GROUP_WATER_2, POKEMON_EGG_GROUP_DRAGON },
    eggId = 14042,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.INTIMIDATE },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.AVALANCHE, TM_IDS.FLAMETHROWER, TM_IDS.WATER_PULSE, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.THUNDER_WAVE, TM_IDS.EARTHQUAKE, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.DRAGON_RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE }
}

POKEMON["RC Gyarados"] = table.deepcopy(POKEMON["Gyarados"])
POKEMON["RC Gyarados"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Gyarados"].blockTransform = true

POKEMON["Suramoon Gyarados"] = table.deepcopy(POKEMON["Gyarados"])
POKEMON["Suramoon Gyarados"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["Suramoon Gyarados"].blockTransform = true
POKEMON["Suramoon Gyarados"].atk = 105 * 6
POKEMON["Suramoon Gyarados"].def = 60 * 3
POKEMON["Suramoon Gyarados"].spAtk = 60 * 6
POKEMON["Suramoon Gyarados"].spDef = 70 * 3