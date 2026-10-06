POKEMON["Dunsparce"] = {
    pTypes = {ELEMENT_NORMAL}, dexStorage = 10206, atk = 70, def = 70, spAtk = 65, spDef = 65, energy = 100, chance = 200, portrait = 17495, dexPortrait = 15853, fastcallPortrait = 16053, catchStorage = 16206,
    evolutions = {},
    description = "If spotted, it escapes by burrowing with its tail. It can float just slightly using its wings.",
    skills = {"Tackle", 1, "Rage", 5, "Defense Curl", 10, "Spite", 15, "Pursuit", 20, "Ancient Power", 25, "Take Down", 30, "Glare", 35, "Double-Edge", 40, "Drill Run", 45, "Aqua Tail", 55, "Zen Headbutt", 60},
    abilities = {POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_FIELD}, eggId = 17764, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, POKEMON_SPECIAL_ABILITY_IDS.RUN_AWAY},
    learnableTms = {TM_IDS.POISON_JAB, TM_IDS.FLAMETHROWER, TM_IDS.ROCK_TOMB, TM_IDS.WATER_PULSE, TM_IDS.NIGHTMARE, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.BLIZZARD, TM_IDS.ROCK_SLIDE, TM_IDS.THUNDER_WAVE, TM_IDS.DREAM_EATER, TM_IDS.FIRE_BLAST, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.ICE_BEAM, TM_IDS.RAGE, TM_IDS.SOLAR_BEAM, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.EARTHQUAKE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, },
    eggMoves = {"Agility", "Ancient Power", "Astonish", "Bide", "Bite", "Curse", "Headbutt", "Hex", "Magic Coat", "Secret Power", "Sleep Talk", "Snore", "Trump Card"}
}

POKEMON["RC Dunsparce"] = table.deepcopy(POKEMON["Dunsparce"])
POKEMON["RC Dunsparce"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Dunsparce"].blockTransform = true