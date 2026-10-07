POKEMON["Azumarill"] = {
    pTypes = {ELEMENT_WATER, ELEMENT_FAIRY}, dexStorage = 10184, atk = 50, def = 80, spAtk = 60, spDef = 80, energy = 100, chance = 700, portrait = 17473, dexPortrait = 15831, fastcallPortrait = 16031, catchStorage = 16184,
    evolutions = {},
    description = "When it plays in water, it rolls up its elongated ears to prevent their insides from getting wet.",
    skills = {"Tackle", 1, "Bubble", 5, "Water Gun", 10, "Muddy Water", 15, "Aqua Tail", 20, "Double-Edge", 25, "Aqua Ring", 30, "Bubblebeam", 40, "Rain Dance", 45, "Superpower", 50, "Hydro Pump", 55, "Defense Curl", 60},
    abilities = {POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, POKEMON_ABILITIES.WATERFALL, "Rock Smash", "Surf", "Dive", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_WATER_1, POKEMON_EGG_GROUP_FAIRY}, eggId = 17752, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.THICK_FAT, POKEMON_SPECIAL_ABILITY_IDS.HUGE_POWER},
    learnableTms = {TM_IDS.WATER_PULSE, TM_IDS.DEFENSE_CURL, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.BLIZZARD, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.ICE_BEAM, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, },
    eggMoves = {"Amnesia", "Aqua Jet", "Belly Drum", "Body Slam", "Camouflage", "Copycate", "Encore", "Fake Tears", "Future Sight", "Muddy Water", "Perish Song", "Present", "Refresh", "Sing", "Slam", "Soak", "Superpower", "Supersonic", "Tickle", "Water Sport"}
}

POKEMON["Cloned Azumarill"] = table.deepcopy(POKEMON["Azumarill"])
POKEMON["Cloned Azumarill"].blockTransform = true