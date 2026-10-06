POKEMON["Raichu"] = {
    pTypes = { ELEMENT_ELECTRIC },
    dexStorage = 10026,
    atk = 90,
    def = 55,
    spAtk = 90,
    spDef = 80,
    energy = 100,
    chance = 500,
    portrait = 12727,
    dexPortrait = 13527,
    fastcallPortrait = 10660,
    catchStorage = 16026,
    evolutions = {},
    description = "Its electric charges can reach even 100,000 volts. Careless contact can cause even an Indian elephant to faint.",
    skills = { "Tackle", 1, "Thunder Shock", 5, "Double Team", 10, "Quick Attack", 15, "Slam", 20, "Thunderbolt", 25, "Agility", 30, "Discharge", 40, "Electro Ball", 45, "Thunder Wave", 50, "Thunder", 55, "Charge", 60, "Wild Charge", 65 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Flash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD, POKEMON_EGG_GROUP_FAIRY },
    eggId = 13987,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.STATIC },
    learnableTms = { TM_IDS.THUNDER_PUNCH, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.PAY_DAY, TM_IDS.SUBMISSION, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.SUBSTITUTE, TM_IDS.FOCUS_PUNCH, TM_IDS.LIGHT_SCREEN, TM_IDS.BRICK_BREAK, TM_IDS.SHOCK_WAVE },
    eggMoves = { "Bestow", "Bide", "Charge", "Disarming Voice", "Double Slap", "Encore", "Endure", "Fake Out", "Flail", "Lucky Chant", "Present", "Reversal", "Thunder Punch", "Tickle", "Wish" }
}

POKEMON["RC Raichu"] = table.deepcopy(POKEMON["Raichu"])
POKEMON["RC Raichu"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Raichu"].blockTransform = true