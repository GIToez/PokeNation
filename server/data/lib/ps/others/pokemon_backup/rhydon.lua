POKEMON["Rhydon"] = {
    pTypes = {ELEMENT_GROUND, ELEMENT_ROCK}, dexStorage = 10112, atk = 130, def = 120, spAtk = 45, spDef = 45, energy = 100, chance = 700, portrait = 12813, dexPortrait = 13613, fastcallPortrait = 10746, catchStorage = 16112,
    evolutions = {},
    description = "It begins walking on its hind legs after evolution. It can punch holes through boulders with its horn.",
    skills = {"Tackle", 1, "Horn Attack", 5, "Stomp", 10, "Rock Throw", 15, "Scary Face", 20, "Rock Blast", 25, "Earthquake", 30, "Drill Run", 35, "Take Down", 45, "Horn Drill", 50, "Earth Power", 55, "Megahorn", 60},
    abilities = {POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Rock Smash", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_MONSTER, POKEMON_EGG_GROUP_FIELD}, eggId = 14028, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.LIGHTNINGROD, POKEMON_SPECIAL_ABILITY_IDS.ROCK_HEAD},
    learnableTms = {TM_IDS.AVALANCHE, TM_IDS.POISON_JAB, TM_IDS.FLAMETHROWER, TM_IDS.ROCK_TOMB, TM_IDS.FURY_CUTTER, TM_IDS.FIRE_PUNCH, TM_IDS.THUNDER_PUNCH, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.SWORDS_DANCE, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.HORN_DRILL, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.PAY_DAY, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.EARTHQUAKE, TM_IDS.FISSURE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.ROCK_SLIDE, TM_IDS.SUBSTITUTE},
    eggMoves = {"Counter", "Crunch", "Crush Claw", "Curse", "Dragon Rush", "Fire Fang", "Guard Split", "Ice Fang", "Iron Tail", "Magnitude", "Metal Burst", "Reversal", "Rock Climb", "Rototiller", "Skull Bash", "Thunder Fang"}
}

POKEMON["RC Rhydon"] = table.deepcopy(POKEMON["Rhydon"])
POKEMON["RC Rhydon"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Rhydon"].blockTransform = true