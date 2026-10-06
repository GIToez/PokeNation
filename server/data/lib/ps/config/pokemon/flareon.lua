POKEMON["Flareon"] = {
    pTypes = { ELEMENT_FIRE },
    dexStorage = 10136,
    atk = 130,
    def = 60,
    spAtk = 95,
    spDef = 110,
    energy = 100,
    chance = 500,
    portrait = 12837,
    dexPortrait = 13637,
    fastcallPortrait = 10770,
    catchStorage = 16136,
    evolutions = {},
    description = "It has a flame bag inside its body. After inhaling deeply, it blows out flames of nearly 3,100 degrees Fahrenheit.",
    skills = { "Tackle", 1, "Quick Attack", 5, "Sand-Attack", 10, "Ember", 15, "Bite", 20, "Fire Fang", 25, "Wish", 35, "Flamethrower", 40, "Flame Charge", 45, "Lava Plume", 50, "Smog", 55, "Flare Blitz", 60, "Overheat", 65, "Last Resort", 70 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Find", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 14044,
    eggChance = 1,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.FLASH_FIRE },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.FLAMETHROWER, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE, TM_IDS.ROAR, TM_IDS.OVERHEAT },
    eggMoves = { "Captivate", "Charm", "Covet", "Curse", "Detect", "Endure", "Fake Tears", "Flail", "Natural Gift", "Stored Power", "Synchronoise", "Tickle", "Wish", "Yawn" }
}

POKEMON["RC Flareon"] = table.deepcopy(POKEMON["Flareon"])
POKEMON["RC Flareon"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Flareon"].blockTransform = true