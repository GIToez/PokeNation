POKEMON["Nidoqueen"] = {
    pTypes = { ELEMENT_POISON, ELEMENT_GROUND },
    dexStorage = 10031,
    atk = 92,
    def = 87,
    spAtk = 75,
    spDef = 85,
    energy = 100,
    chance = 500,
    portrait = 12732,
    dexPortrait = 13532,
    fastcallPortrait = 10665,
    catchStorage = 16031,
    evolutions = {},
    description = "The body is covered by stiff, needle-like scales. If it becomes excited, the needles bristle outwards.",
    skills = { "Tackle", 1, "Scratch", 5, "Double Kick", 10, "Poison Sting", 15, "Bite", 20, "Poison Fang", 25, "Fury Swipes", 35, "Crunch", 40, "Captivate", 45, "Earth Power", 50, "Acid", 60, "Body Slam", 65, "Skull Bash", 70, "Superpower", 75, "Stealth Rock", 80 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Headbutt" },
    eggGroup = {},
    eggId = 0,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.POISON_POINT, POKEMON_SPECIAL_ABILITY_IDS.RIVALRY },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.AVALANCHE, TM_IDS.POISON_JAB, TM_IDS.FLAMETHROWER, TM_IDS.AERIAL_ACE, TM_IDS.ROCK_TOMB, TM_IDS.WATER_PULSE, TM_IDS.FURY_CUTTER, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.DEFENSE_CURL, TM_IDS.SLUDGE_BOMB, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.HORN_DRILL, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.PAY_DAY, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE },
    eggMoves = { "Beat Up", "Charm", "Chip Away", "Counter", "Disable", "Endure", "Focus Energy", "Iron Tail", "Pursuit", "Skull Bash", "Supersonic", "Take Down", "Venom Drench" }
}

POKEMON["RC Nidoqueen"] = table.deepcopy(POKEMON["Nidoqueen"])
POKEMON["RC Nidoqueen"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Nidoqueen"].blockTransform = true

POKEMON["Cloned Nidoqueen"] = table.deepcopy(POKEMON["Nidoqueen"])
POKEMON["Cloned Nidoqueen"].blockTransform = true