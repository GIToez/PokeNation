POKEMON["Pikachu"] = {
    pTypes = { ELEMENT_ELECTRIC },
    dexStorage = 10025,
    atk = 55,
    def = 40,
    spAtk = 50,
    spDef = 50,
    energy = 100,
    chance = 150,
    portrait = 12726,
    dexPortrait = 13526,
    fastcallPortrait = 10659,
    catchStorage = 16025,
    evolutions = { { name = "Raichu", requiredLevel = 35, requiredItems = { ITEMS.THUNDERSTONE } } },
    description = "It has small electric sacs on both its cheeks. If threatened, it looses electric charges from the sacs.",
    skills = { "Tackle", 1, "Thunder Shock", 5, "Double Team", 10, "Quick Attack", 15, "Slam", 20, "Thunderbolt", 25, "Agility", 30 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Flash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_FIELD, POKEMON_EGG_GROUP_FAIRY },
    eggId = 13987,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.STATIC },
    learnableTms = { TM_IDS.THUNDER_PUNCH, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.DYNAMIC_PUNCH, TM_IDS.MEGA_PUNCH, TM_IDS.MEGA_KICK, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.PAY_DAY, TM_IDS.SUBMISSION, TM_IDS.SEISMIC_TOSS, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.SUBSTITUTE, TM_IDS.FOCUS_PUNCH, TM_IDS.LIGHT_SCREEN, TM_IDS.BRICK_BREAK, TM_IDS.SHOCK_WAVE },
    eggMoves = { "Bestow", "Bide", "Charge", "Disarming Voice", "Double Slap", "Encore", "Endure", "Fake Out", "Flail", "Lucky Chant", "Present", "Reversal", "Thunder Punch", "Tickle", "Wish" }
}

POKEMON["Easter Rabbit Shadow"] = table.deepcopy(POKEMON["Pikachu"])
POKEMON["Easter Rabbit Shadow"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["Easter Rabbit Shadow"].skills = { "Ancient Power", 1, "Dream Eater", 1, "Fire Punch", 1, "Aurora Beam", 1, "Blizzard", 1, "Earthquake", 1, "Hydro Pump", 1, "Hyper Voice", 1, "Psychic", 1, "Thunder", 1, "Inferno", 1, "Leaf Storm", 1, "Dark Pulse", 1, "Rock Slide", 1 }
POKEMON["Easter Rabbit Shadow"].specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.SUMMI }
POKEMON["Easter Rabbit Shadow"].atk = 105 * 6
POKEMON["Easter Rabbit Shadow"].def = 60 * 3
POKEMON["Easter Rabbit Shadow"].spAtk = 60 * 6
POKEMON["Easter Rabbit Shadow"].spDef = 70 * 3
POKEMON["Easter Rabbit Shadow"].blockTransform = true

POKEMON["Easter Pikachu"] = table.deepcopy(POKEMON["Pikachu"])
POKEMON["Easter Pikachu"].blockTransform = true
POKEMON["Easter Pikachu"].evolutions = {}
POKEMON["Easter Pikachu"].allowedBall = "white easter"
POKEMON["Easter Pikachu"].ignoreBallCounter = true

POKEMON["Christmas Pikachu"] = table.deepcopy(POKEMON["Pikachu"])
POKEMON["Christmas Pikachu"].blockTransform = true
POKEMON["Christmas Pikachu"].evolutions = {}
POKEMON["Christmas Pikachu"].ignoreBallCounter = true

POKEMON["Darkchu"] = table.deepcopy(POKEMON["Pikachu"])
POKEMON["Darkchu"].chance = 250
POKEMON["Darkchu"].pTypes = {ELEMENT_GROUND, ELEMENT_PSYCHIC}
POKEMON["Darkchu"].skills = {"Tackle", 1, "Mud Bomb", 5, "Mud Shot", 10, "Zen Headbutt", 15, "Recover", 20, "Metronome", 25, "Earthquake", 30, "Softboiled", 35, "Psywave", 40, "Magnitude", 45, "Psycho Cut", 50, "Earth Power", 55, "Future Sight", 60, "Fissure", 65, "Psychic", 70}
POKEMON["Darkchu"].abilities = {POKEMON_ABILITIES.ROCK_SMASH, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.CUT, POKEMON_ABILITIES.FLASH, POKEMON_ABILITIES.BLINK, POKEMON_ABILITIES.TELEPORT}
POKEMON["Darkchu"].blockTransform = true
POKEMON["Darkchu"].evolutions = {}
POKEMON["Darkchu"].ignoreBallCounter = true
POKEMON["Darkchu"].allowedBall = "enchanted"
POKEMON["Darkchu"].portrait = 28069
POKEMON["Darkchu"].fastcallPortrait = 26699
POKEMON["Darkchu"].specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.GUTS, POKEMON_SPECIAL_ABILITY_IDS.VOLT_ABSORB}
-- Nidoking Base Stats
POKEMON["Darkchu"].atk = 102
POKEMON["Darkchu"].def = 77
POKEMON["Darkchu"].spAtk = 85
POKEMON["Darkchu"].spDef = 75