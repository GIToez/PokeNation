POKEMON["Bulbasaur"] = {
    pTypes = { ELEMENT_GRASS, ELEMENT_POISON },
    dexStorage = 10001,
    atk = 49,
    def = 49,
    spAtk = 65,
    spDef = 65,
    energy = 100,
    chance = 150,
    portrait = 12702,
    dexPortrait = 13502,
    fastcallPortrait = 10635,
    catchStorage = 16001,
    evolutions = { { name = "Ivysaur", requiredLevel = 35 } },
    description = "There is a plant seed on its back right from the day this POKEMON is born. The seed slowly grows larger.",
    skills = { "Tackle", 1, "Headbutt", 5, "Razor Leaf", 10, "Vine Whip", 15, "Leech Seed", 20, "Poison Powder", 25, "Sleep Powder", 30 },
    abilities = { POKEMON_ABILITIES.STRENGTH, "Cut", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_MONSTER, POKEMON_EGG_GROUP_GRASS },
    eggId = 13978,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.OVERGROW },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.ENERGY_BALL, TM_IDS.FURY_CUTTER, TM_IDS.DEFENSE_CURL, TM_IDS.SLUDGE_BOMB, TM_IDS.MUD_SLAP, TM_IDS.GIGA_DRAIN, TM_IDS.HEADBUTT, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.MEGA_DRAIN, TM_IDS.SOLAR_BEAM, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.REST, TM_IDS.SUBSTITUTE, TM_IDS.BULLET_SEED, TM_IDS.LIGHT_SCREEN, TM_IDS.SAFEGUARD },
    eggMoves = { "Amnesia", "Charm", "Curse", "Endure", "Giga Drain", "Grass Whistle", "Grassy Terrain", "Ingrain", "Leaf Storm", "Magical Leaf", "Nature Power", "Petal Dance", "Power Whip", "Skull Bash", "Sludge" }
}

POKEMON["RC Bulbasaur"] = table.deepcopy(POKEMON["Bulbasaur"])
POKEMON["RC Bulbasaur"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Bulbasaur"].blockTransform = true

POKEMON["Easter Bulbasaur"] = table.deepcopy(POKEMON["Bulbasaur"])
POKEMON["Easter Bulbasaur"].blockTransform = true
POKEMON["Easter Bulbasaur"].evolutions = {}
POKEMON["Easter Bulbasaur"].allowedBall = "white easter"
POKEMON["Easter Bulbasaur"].ignoreBallCounter = true

POKEMON["Christmas Bulbasaur"] = table.deepcopy(POKEMON["Bulbasaur"])
POKEMON["Christmas Bulbasaur"].blockTransform = true
POKEMON["Christmas Bulbasaur"].evolutions = {}
POKEMON["Christmas Bulbasaur"].ignoreBallCounter = true
--POKEMON["Christmas Bulbasaur"].allowedBall = "christmas"

POKEMON["Bulmander"] = table.deepcopy(POKEMON["Bulbasaur"])
POKEMON["Bulmander"].chance = 250
POKEMON["Bulmander"].pTypes = {ELEMENT_FIRE, ELEMENT_GHOST}
POKEMON["Bulmander"].skills = {"Tackle", 1, "Ember", 5, "Fire Fang", 10, "Lick", 15, "Hex", 20, "Fire Spin", 25, "Flame Burst", 30, "Moonlight", 35, "Shadow Punch", 40, "Flare Blitz", 45, "Flamethrower", 50, "Dark Pulse", 55, "Shadow Ball", 60, "Inferno", 65, "Fire Blast", 70}
POKEMON["Bulmander"].abilities = {POKEMON_ABILITIES.ROCK_SMASH, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.CUT, POKEMON_ABILITIES.FLASH, POKEMON_ABILITIES.BLINK, POKEMON_ABILITIES.TELEPORT}
POKEMON["Bulmander"].blockTransform = true
POKEMON["Bulmander"].evolutions = {}
POKEMON["Bulmander"].ignoreBallCounter = true
POKEMON["Bulmander"].allowedBall = "enchanted"
POKEMON["Bulmander"].chance = 100
POKEMON["Bulmander"].portrait = 28066
POKEMON["Bulmander"].fastcallPortrait = 26696
POKEMON["Bulmander"].specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.FLASH_FIRE, POKEMON_SPECIAL_ABILITY_IDS.INSOMNIA}
-- Houndoom Base Stats
POKEMON["Bulmander"].atk = 90
POKEMON["Bulmander"].def = 50
POKEMON["Bulmander"].spAtk = 110
POKEMON["Bulmander"].spDef = 80