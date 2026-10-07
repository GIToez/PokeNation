POKEMON["Pineco"] = {
    pTypes = { ELEMENT_BUG },
    dexStorage = 10204,
    atk = 65,
    def = 90,
    spAtk = 35,
    spDef = 35,
    energy = 100,
    chance = 100,
    portrait = 17493,
    dexPortrait = 15851,
    fastcallPortrait = 16051,
    catchStorage = 16204,
    evolutions = { { name = "Forretress", requiredLevel = 35 } },
    description = "It hangs and waits for flying insect prey to come near. It does not move about much on its own.",
    skills = { "Tackle", 1, "Bug Bite", 5, "Protect", 10, "Toxic Spikes", 15, "Take Down", 20, "Selfdestruct", 25, "Struggle Bug", 30 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_BUG },
    eggId = 17763,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.STURDY },
    learnableTms = { TM_IDS.ROCK_TOMB, TM_IDS.DEFENSE_CURL, TM_IDS.GIGA_DRAIN, TM_IDS.HEADBUTT, TM_IDS.ROCK_SLIDE, TM_IDS.EXPLOSION, TM_IDS.REFLECT, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.SOLAR_BEAM, TM_IDS.EARTHQUAKE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, TM_IDS.LIGHT_SCREEN, TM_IDS.SANDSTORM },
    eggMoves = { "Counter", "Double-Edge", "Endure", "Flail", "Pin Missile", "Power Trick", "Revenge", "Sand Tomb", "Stealth Rock", "Swift", "Toxic Spikes" }
}

POKEMON["RC Pineco"] = table.deepcopy(POKEMON["Pineco"])
POKEMON["RC Pineco"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Pineco"].blockTransform = true