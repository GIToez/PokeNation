POKEMON["Dragonite"] = {
    pTypes = { ELEMENT_DRAGON, ELEMENT_FLYING },
    dexStorage = 10149,
    atk = 134,
    def = 95,
    spAtk = 100,
    spDef = 100,
    energy = 100,
    chance = 800,
    portrait = 12850,
    dexPortrait = 13650,
    fastcallPortrait = 10783,
    catchStorage = 16149,
    evolutions = {},
    description = "It can fly in spite of its big and bulky physique. It circles the globe in just 16 hours.",
    skills = { "Tackle", 1, "Slam", 5, "Twister", 10, "Aqua Tail", 15, "Thunder Wave", 20, "Dragon Tail", 25, "Agility", 30, "Outrage", 40, "Hyper Beam", 45, "Wing Attack", 55, "Hurricane", 60, "Fire Punch", 65, "Thunder Punch", 70, "Dragon Dance", 75, "Dragon Rush", 80 },
    abilities = { POKEMON_ABILITIES.WATERFALL, "Find", "Fly", "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_WATER_1, POKEMON_EGG_GROUP_DRAGON },
    eggId = 14047,
    eggChance = 1,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.INNER_FOCUS },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.FLAMETHROWER, TM_IDS.AERIAL_ACE, TM_IDS.ROCK_TOMB, TM_IDS.WATER_PULSE, TM_IDS.FURY_CUTTER, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.EARTHQUAKE, TM_IDS.RAZOR_WIND, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.DRAGON_RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.SUBSTITUTE },
    eggMoves = { "Aqua Jet", "Dragon Breath", "Dragon Dance", "Dragon Pulse", "Dragon Rush", "Extreme Speed", "Haze", "Iron Tail", "Mist", "Supersonic", "Water Pulse" }
}

POKEMON["RC Dragonite"] = table.deepcopy(POKEMON["Dragonite"])
POKEMON["RC Dragonite"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Dragonite"].blockTransform = true

POKEMON["Suramoon Dragonite"] = table.deepcopy(POKEMON["Dragonite"])
POKEMON["Suramoon Dragonite"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["Suramoon Dragonite"].blockTransform = true
POKEMON["Suramoon Dragonite"].atk = 105 * 6
POKEMON["Suramoon Dragonite"].def = 60 * 3
POKEMON["Suramoon Dragonite"].spAtk = 60 * 6
POKEMON["Suramoon Dragonite"].spDef = 70 * 3

POKEMON["Cloned Dragonite"] = table.deepcopy(POKEMON["Dragonite"])
POKEMON["Cloned Dragonite"].blockTransform = true