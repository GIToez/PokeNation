POKEMON["Cyndaquil"] = {
    pTypes = { ELEMENT_FIRE },
    dexStorage = 10155,
    atk = 52,
    def = 43,
    spAtk = 60,
    spDef = 50,
    energy = 100,
    chance = 150,
    portrait = 17444,
    dexPortrait = 15802,
    fastcallPortrait = 16002,
    catchStorage = 16155,
    evolutions = { { name = "Quilava", requiredLevel = 35 } },
    description = "It usually stays hunched over. If it is angry or surprised, it shoots flames out of its back.",
    skills = { "Tackle", 1, "Ember", 5, "Quick Attack", 10, "Flame Wheel", 15, "Smoke Screen", 20, "Swift", 25, "Flamethrower", 30 },
    abilities = { POKEMON_ABILITIES.DIG, "Cut", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 17742,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.BLAZE },
    learnableTms = { TM_IDS.FLAMETHROWER, TM_IDS.AERIAL_ACE, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.HEADBUTT, TM_IDS.SWIFT, TM_IDS.FIRE_BLAST, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, TM_IDS.OVERHEAT },
    eggMoves = { "Covet", "Crush Claw", "Double Kick", "Double-Edge", "Extrasensory", "Flame Burst", "Flare Blitz", "Foresight", "Fury Swipes", "Howl", "Nature Power", "Quick Attack", "Reversal", "Thrash" }
}

POKEMON["RC Cyndaquil"] = table.deepcopy(POKEMON["Cyndaquil"])
POKEMON["RC Cyndaquil"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Cyndaquil"].blockTransform = true