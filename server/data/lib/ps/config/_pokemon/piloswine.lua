POKEMON["Piloswine"] = {
    pTypes = { ELEMENT_ICE, ELEMENT_GROUND },
    dexStorage = 10221,
    atk = 100,
    def = 80,
    spAtk = 60,
    spDef = 60,
    energy = 100,
    chance = 700,
    portrait = 17510,
    dexPortrait = 15868,
    fastcallPortrait = 16068,
    catchStorage = 16221,
    evolutions = {},
    description = "If it charges at an enemy, the hairs on its back stand up straight. It is very sensitive to sound.",
    skills = { "Tackle", 1, "Mud-Slap", 5, "Ice Shard", 10, "Powder Snow", 15, "Mud Bomb", 20, "Icy Wind", 25, "Freeze-Dry", 30, "Earthquake", 35, "Ancient Power", 45, "Ice Fang", 50, "Endeavor", 55, "Thrash", 60, "Blizzard", 65, "Mud Sport", 70 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Ride", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 17773,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.OBLIVIOUS, POKEMON_SPECIAL_ABILITY_IDS.SNOW_CLOAK },
    learnableTms = { TM_IDS.AVALANCHE, TM_IDS.ROCK_TOMB, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.BLIZZARD, TM_IDS.ROCK_SLIDE, TM_IDS.REFLECT, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.ICE_BEAM, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, },
    eggMoves = { "Ancient Power", "Avalanche", "Bite", "Body Slam", "Curse", "Double-Edge", "Fissure", "Freeze-Dry", "Iciel Crash", "Icicle Spear", "Mud Shot", "Stealth Rock", "Take Down" }
}

POKEMON["Cloned Piloswine"] = table.deepcopy(POKEMON["Piloswine"])
POKEMON["Cloned Piloswine"].blockTransform = true