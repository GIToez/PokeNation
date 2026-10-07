POKEMON["Umbreon"] = {
    pTypes = { ELEMENT_DARK },
    dexStorage = 10197,
    atk = 65,
    def = 110,
    spAtk = 60,
    spDef = 130,
    energy = 100,
    chance = 2000,
    portrait = 17486,
    dexPortrait = 15844,
    fastcallPortrait = 16044,
    catchStorage = 16197,
    evolutions = {},
    description = "When darkness falls, the rings on the body begin to glow, striking fear in the hearts of anyone nearby.",
    skills = { "Tackle", 1, "Quick Attack", 5, "Sand-Attack", 10, "Pursuit", 15, "Faint Attack", 20, "Bite", 25, "Moonlight", 35, "Assurance", 40, "Confuse Ray", 45, "Dark Pulse", 50, "Hyper Voice", 55, "Iron Tail", 60, "Foul Play", 65, "Last Resort", 70 },
    abilities = { POKEMON_ABILITIES.DIG, "Find", "Flash", "Cut", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 14044,
    eggChance = 1,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.SYNCHRONIZE },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.NIGHTMARE, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DREAM_EATER, TM_IDS.SWIFT, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.PSYCHIC, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, TM_IDS.TAUNT },
    eggMoves = { "Captivate", "Charm", "Covet", "Curse", "Detect", "Endure", "Fake Tears", "Flail", "Natural Gift", "Stored Power", "Synchronoise", "Tickle", "Wish", "Yawn" }
}

POKEMON["RC Umbreon"] = table.deepcopy(POKEMON["Umbreon"])
POKEMON["RC Umbreon"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Umbreon"].blockTransform = true