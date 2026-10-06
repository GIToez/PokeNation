POKEMON["Eevee"] = {
    pTypes = { ELEMENT_NORMAL },
    dexStorage = 10133,
    atk = 55,
    def = 50,
    spAtk = 45,
    spDef = 65,
    energy = 100,
    chance = 200,
    portrait = 12834,
    dexPortrait = 13634,
    fastcallPortrait = 10767,
    catchStorage = 16133,
    evolutions = {
        { name = "Vaporeon", requiredLevel = 30, requiredItems = { ITEMS.WATER_STONE } },
        { name = "Jolteon", requiredLevel = 30, requiredItems = { ITEMS.THUNDERSTONE } },
        { name = "Flareon", requiredLevel = 30, requiredItems = { ITEMS.FIRE_STONE } },
        { name = "Espeon", requiredLevel = 30, requiredItems = { ITEMS.SOOTHE_BELL }, requiredTime = WORLD_LIGHT_STATE_DAY },
        { name = "Umbreon", requiredLevel = 30, requiredItems = { ITEMS.SOOTHE_BELL }, requiredTime = WORLD_LIGHT_STATE_NIGHT }
    },
    description = "An extremely rare POKEMON that may evolve in a number of different ways depending on stimuli.",
    skills = { "Tackle", 1, "Quick Attack", 5, "Sand-Attack", 10, "Bite", 15, "Headbutt", 20, "Agility", 25 },
    abilities = { POKEMON_ABILITIES.DIG, "Headbutt", "Find" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 14044,
    eggChance = 1,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.RUN_AWAY, POKEMON_SPECIAL_ABILITY_IDS.ADAPTABILITY },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.HEADBUTT, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE },
    eggMoves = { "Captivate", "Charm", "Covet", "Curse", "Detect", "Endure", "Fake Tears", "Flail", "Natural Gift", "Stored Power", "Synchronoise", "Tickle", "Wish", "Yawn" }
}

POKEMON["RC Eevee"] = table.deepcopy(POKEMON["Eevee"])
POKEMON["RC Eevee"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Eevee"].blockTransform = true