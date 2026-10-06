POKEMON["Rhyhorn"] = {
    pTypes = { ELEMENT_GROUND, ELEMENT_ROCK },
    dexStorage = 10111,
    atk = 85,
    def = 95,
    spAtk = 30,
    spDef = 30,
    energy = 100,
    chance = 300,
    portrait = 12812,
    dexPortrait = 13612,
    fastcallPortrait = 10745,
    catchStorage = 16111,
    evolutions = { { name = "Rhydon", requiredLevel = 40 } },
    description = "Strong, but not too bright, this POKEMON can shatter even a skyscraper with its charging TACKLES.",
    skills = { "Tackle", 1, "Horn Attack", 5, "Stomp", 10, "Rock Throw", 15, "Take Down", 20, "Rock Blast", 25, "Scary Face", 30, "Drill Run", 35 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Ride", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_MONSTER, POKEMON_EGG_GROUP_FIELD },
    eggId = 14028,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.LIGHTNINGROD, POKEMON_SPECIAL_ABILITY_IDS.ROCK_HEAD },
    learnableTms = { TM_IDS.POISON_JAB, TM_IDS.FLAMETHROWER, TM_IDS.ROCK_TOMB, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.BLIZZARD, TM_IDS.ICE_BEAM, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.HORN_DRILL, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE },
    eggMoves = { "Counter", "Crunch", "Crush Claw", "Curse", "Dragon Rush", "Fire Fang", "Guard Split", "Ice Fang", "Iron Tail", "Magnitude", "Metal Burst", "Reversal", "Rock Climb", "Rototiller", "Skull Bash", "Thunder Fang" }
}

POKEMON["RC Rhyhorn"] = table.deepcopy(POKEMON["Rhyhorn"])
POKEMON["RC Rhyhorn"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Rhyhorn"].blockTransform = true