POKEMON["Arcanine"] = {
    pTypes = { ELEMENT_FIRE },
    dexStorage = 10059,
    atk = 110,
    def = 80,
    spAtk = 100,
    spDef = 80,
    energy = 100,
    chance = 500,
    portrait = 12760,
    dexPortrait = 13560,
    fastcallPortrait = 10693,
    catchStorage = 16059,
    evolutions = {},
    description = "A POKEMON that is described in Chinese legends. It is said to race at an unbelievable speed.",
    skills = { "Tackle", 1, "Crunch", 5, "Ember", 10, "Flame Wheel", 15, "Fire Fang", 20, "Flamethrower", 25, "Agility", 30, "Take Down", 40, "Flame Burst", 45, "Thunder Fang", 50, "Flare Blitz", 55, "Extreme Speed", 60, "Overheat", 65 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Find", "Ride", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 14002,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.INTIMIDATE, POKEMON_SPECIAL_ABILITY_IDS.FLASH_FIRE },
    learnableTms = { TM_IDS.FLAMETHROWER, TM_IDS.AERIAL_ACE, TM_IDS.IRON_TAIL, TM_IDS.HEADBUTT, TM_IDS.SOLAR_BEAM, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.DRAGON_RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE, TM_IDS.TAUNT, TM_IDS.SAFEGUARD, TM_IDS.OVERHEAT },
    eggMoves = { "Body Slam", "Close Combat", "Covet", "Crunch", "Double Kick", "Double-Edge", "Fire Spin", "Flare Blitz", "Heat Wave", "Howl", "Iron Tail", "Morning Sun", "Thrash" }
}

POKEMON["RC Arcanine"] = table.deepcopy(POKEMON["Arcanine"])
POKEMON["RC Arcanine"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Arcanine"].blockTransform = true

POKEMON["Cloned Arcanine"] = table.deepcopy(POKEMON["Arcanine"])
POKEMON["Cloned Arcanine"].blockTransform = true