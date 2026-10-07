POKEMON["Rapidash"] = {
    pTypes = { ELEMENT_FIRE },
    dexStorage = 10078,
    atk = 100,
    def = 70,
    spAtk = 80,
    spDef = 80,
    energy = 100,
    chance = 400,
    portrait = 12779,
    dexPortrait = 13579,
    fastcallPortrait = 10712,
    catchStorage = 16078,
    evolutions = {},
    description = "It can gallop at a top speed of 150 miles per hour. It can race as fast as a bullet train while ablaze.",
    skills = { "Tackle", 1, "Ember", 5, "Flame Wheel", 10, "Stomp", 15, "Fire Spin", 20, "Take Down", 25, "Agility", 30, "Bounce", 40, "Inferno", 45, "Flame Burst", 50, "Fire Blast", 55, "Flare Blitz", 60, "Megahorn", 65, "Overheat", 70 },
    abilities = { POKEMON_ABILITIES.STRENGTH, "Ride", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD },
    eggId = 14009,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.RUN_AWAY, POKEMON_SPECIAL_ABILITY_IDS.FLASH_FIRE },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.POISON_JAB, TM_IDS.FLAMETHROWER, TM_IDS.IRON_TAIL, TM_IDS.HEADBUTT, TM_IDS.SOLAR_BEAM, TM_IDS.TOXIC, TM_IDS.HORN_DRILL, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE, TM_IDS.OVERHEAT },
    eggMoves = { "Ally Switch", "Captivate", "Charm", "Double Kick", "Double-Edge", "Flame Wheel", "Horn Drill", "Hypnosis", "Low Kick", "Morning Sun", "Thrash" }
}

POKEMON["RC Rapidash"] = table.deepcopy(POKEMON["Rapidash"])
POKEMON["RC Rapidash"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Rapidash"].blockTransform = true