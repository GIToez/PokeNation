POKEMON["Espeon"] = {
    pTypes = { ELEMENT_PSYCHIC },
    dexStorage = 10196,
    atk = 65,
    def = 60,
    spAtk = 130,
    spDef = 95,
    energy = 100,
    chance = 2000,
    portrait = 17485,
    dexPortrait = 15843,
    fastcallPortrait = 16043,
    catchStorage = 16196,
    evolutions = {},
    description = "By reading air currents, it can predict things such as the weather or its foe's next move.",
    skills = { "Tackle", 1, "Quick Attack", 5, "Sand-Attack", 10, "Confusion", 15, "Swift", 20, "Psybeam", 25, "Wish", 35, "Stored Power", 40, "Psychic", 45, "Yawn", 50, "Zen Headbutt", 55, "Magic Coat", 60, "Future Sight", 65, "Last Resort", 70 },
    abilities = { POKEMON_ABILITIES.DIG, "Find", "Flash", "Cut", "Blink", "Teleport", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 14044,
    eggChance = 1,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.SYNCHRONIZE },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DREAM_EATER, TM_IDS.SWIFT, TM_IDS.REFLECT, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, },
    eggMoves = { "Captivate", "Charm", "Covet", "Curse", "Detect", "Endure", "Fake Tears", "Flail", "Natural Gift", "Stored Power", "Synchronoise", "Tickle", "Wish", "Yawn" }
}

POKEMON["RC Espeon"] = table.deepcopy(POKEMON["Espeon"])
POKEMON["RC Espeon"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Espeon"].blockTransform = true