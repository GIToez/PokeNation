POKEMON["Charmander"] = {
    pTypes = { ELEMENT_FIRE },
    dexStorage = 10004,
    atk = 52,
    def = 43,
    spAtk = 60,
    spDef = 50,
    energy = 100,
    chance = 150,
    portrait = 12705,
    dexPortrait = 13505,
    fastcallPortrait = 10638,
    catchStorage = 16004,
    evolutions = { { name = "Charmeleon", requiredLevel = 35 } },
    description = "From the time it is born, a flame burns at the tip of its tail. Its life would end if the flame were to go out.",
    skills = { "Tackle", 1, "Scratch", 5, "Ember", 10, "Slash", 15, "Fire Fang", 20, "Fire Spin", 25, "Flamethrower", 30 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Cut", "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_MONSTER, POKEMON_EGG_GROUP_DRAGON },
    eggId = 13979,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.BLAZE },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.FLAMETHROWER, TM_IDS.AERIAL_ACE, TM_IDS.ROCK_TOMB, TM_IDS.FURY_CUTTER, TM_IDS.FIRE_PUNCH, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.ROCK_SLIDE, TM_IDS.MEGA_PUNCH, TM_IDS.SWORDS_DANCE, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.SUBMISSION, TM_IDS.COUNTER, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.DRAGON_RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE, TM_IDS.FOCUS_PUNCH, TM_IDS.DRAGON_CLAW, TM_IDS.BRICK_BREAK, TM_IDS.OVERHEAT },
    eggMoves = { "Air Cutter", "Ancient Power", "Beat Up", "Belly Drum", "Bite", "Counter", "Crunch", "Dragon Dance", "Dragon Pulse", "Dragon Rush", "Flare Blitz", "Focus Punch", "Metal Claw", "Outrage" }
}

POKEMON["RC Charmander"] = table.deepcopy(POKEMON["Charmander"])
POKEMON["RC Charmander"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Charmander"].blockTransform = true

POKEMON["Easter Charmander"] = table.deepcopy(POKEMON["Charmander"])
POKEMON["Easter Charmander"].blockTransform = true
POKEMON["Easter Charmander"].evolutions = {}
POKEMON["Easter Charmander"].allowedBall = "white easter"
POKEMON["Easter Charmander"].ignoreBallCounter = true

POKEMON["Christmas Charmander"] = table.deepcopy(POKEMON["Charmander"])
POKEMON["Christmas Charmander"].blockTransform = true
POKEMON["Christmas Charmander"].evolutions = {}
POKEMON["Christmas Charmander"].ignoreBallCounter = true

POKEMON["Chartle"] = table.deepcopy(POKEMON["Charmander"])
POKEMON["Chartle"].chance = 250
POKEMON["Chartle"].pTypes = { ELEMENT_ICE, ELEMENT_STEEL }
POKEMON["Chartle"].skills = { "Tackle", 1, "Icy Wind", 5, "Bullet Punch", 10, "Magnet Bomb", 15, "Iron Head", 20, "Aqua Ring", 25, "Aurora Beam", 30, "Iron Tail", 35, "Avalanche", 40, "Ice Beam", 45, "Double Team", 50, "Blizzard", 55, "Metal Claw", 60, "Reflect", 65 }
POKEMON["Chartle"].abilities = { POKEMON_ABILITIES.ROCK_SMASH, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.CUT, POKEMON_ABILITIES.FLASH, POKEMON_ABILITIES.BLINK, POKEMON_ABILITIES.TELEPORT }
POKEMON["Chartle"].blockTransform = true
POKEMON["Chartle"].evolutions = {}
POKEMON["Chartle"].ignoreBallCounter = true
POKEMON["Chartle"].allowedBall = "enchanted"
POKEMON["Chartle"].portrait = 28067
POKEMON["Chartle"].fastcallPortrait = 26697
POKEMON["Chartle"].specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.WATER_VEIL, POKEMON_SPECIAL_ABILITY_IDS.SNOW_CLOAK }
-- Scizor Base Stats
POKEMON["Chartle"].atk = 130
POKEMON["Chartle"].def = 100
POKEMON["Chartle"].spAtk = 55
POKEMON["Chartle"].spDef = 80