POKEMON["Ponyta"] = {
    pTypes = {ELEMENT_FIRE}, dexStorage = 10077, atk = 85, def = 55, spAtk = 65, spDef = 65, energy = 100, chance = 70, portrait = 12778, dexPortrait = 13578, fastcallPortrait = 10711, catchStorage = 16077,
    evolutions = {{name = "Rapidash", requiredLevel = 35}},
    description = "Its body is light, and its legs are incredibly powerful. It can clear Ayers Rock in one leap.",
    skills = {"Tackle", 1, "Ember", 5, "Flame Wheel", 10, "Stomp", 15,"Fire Spin", 20, "Take Down", 25, "Agility", 30},
    abilities = {POKEMON_ABILITIES.STRENGTH, "Ride", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_FIELD}, eggId = 14009, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.RUN_AWAY, POKEMON_SPECIAL_ABILITY_IDS.FLASH_FIRE},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.FLAMETHROWER, TM_IDS.IRON_TAIL, TM_IDS.HEADBUTT, TM_IDS.SOLAR_BEAM, TM_IDS.TOXIC, TM_IDS.HORN_DRILL, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE},
    eggMoves = {"Ally Switch", "Captivate", "Charm", "Double Kick", "Double-Edge", "Flame Wheel", "Horn Drill", "Hypnosis", "Low Kick", "Morning Sun", "Thrash"}
}

POKEMON["RC Ponyta"] = table.deepcopy(POKEMON["Ponyta"])
POKEMON["RC Ponyta"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Ponyta"].blockTransform = true