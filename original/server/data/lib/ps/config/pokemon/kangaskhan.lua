POKEMON["Kangaskhan"] = {
    pTypes = { ELEMENT_NORMAL },
    dexStorage = 10115,
    atk = 95,
    def = 80,
    spAtk = 40,
    spDef = 80,
    energy = 100,
    chance = 300,
    portrait = 12816,
    dexPortrait = 13616,
    fastcallPortrait = 10749,
    catchStorage = 16115,
    evolutions = {},
    description = "The female raises its offspring in a pouch on its belly. It is skilled at attacking using COMET PUNCH.",
    skills = { "Tackle", 1, "Bite", 5, "Double Hit", 10, "Comet Punch", 15, "Stomp", 20, "Dizzy Punch", 25, "Mega Punch", 30, "Crunch", 35, "Drain Punch", 40, "Sucker Punch", 45, "Chip Away", 50, "Outrage", 55, "Endure", 60 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_MONSTER },
    eggId = 14031,
    eggChance = 5,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.EARLY_BIRD, POKEMON_SPECIAL_ABILITY_IDS.SCRAPPY },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.AVALANCHE, TM_IDS.DRAIN_PUNCH, TM_IDS.FLAMETHROWER, TM_IDS.AERIAL_ACE, TM_IDS.ROCK_TOMB, TM_IDS.WATER_PULSE, TM_IDS.FURY_CUTTER, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.ICE_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.SOLAR_BEAM, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.HORN_DRILL, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE, TM_IDS.FOCUS_PUNCH, TM_IDS.ROAR, TM_IDS.HAIL, TM_IDS.SAFEGUARD, TM_IDS.BRICK_BREAK, TM_IDS.SHOCK_WAVE, TM_IDS.SANDSTORM },
    eggMoves = { "Circle Throw", "Counter", "Crush Claw", "Disable", "Double-Edge", "Endeavor", "Focus Energy", "Focus Punch", "Foresight", "Hammer Arm", "Stomp", "Trump Card", "Uproar" }
}

POKEMON["RC Kangaskhan"] = table.deepcopy(POKEMON["Kangaskhan"])
POKEMON["RC Kangaskhan"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Kangaskhan"].blockTransform = true