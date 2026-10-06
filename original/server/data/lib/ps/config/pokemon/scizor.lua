POKEMON["Scizor"] = {
    pTypes = { ELEMENT_BUG, ELEMENT_STEEL },
    dexStorage = 10212,
    atk = 130,
    def = 100,
    spAtk = 55,
    spDef = 80,
    energy = 100,
    chance = 2000,
    portrait = 17501,
    dexPortrait = 15859,
    fastcallPortrait = 16059,
    catchStorage = 16212,
    evolutions = {},
    description = "Its wings are not used for flying. They are flapped at high speed to adjust its body temperature.",
    skills = { "Tackle", 1, "Quick Attack", 5, "Focus Energy", 10, "Bug Buzz", 15, "Bullet Punch", 20, "Agility", 25, "Metal Claw", 30, "Razor Wind", 35, "Night Slash", 40, "X-Scissor", 45, "Double Team", 50, "Air Slash", 55, "Swords Dance", 65, "Iron Head", 70 },
    abilities = { POKEMON_ABILITIES.STRENGTH, "Cut", "Rock Smash", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_BUG },
    eggId = 14036,
    eggChance = 5,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.SWARM, POKEMON_SPECIAL_ABILITY_IDS.TECHNICIAN },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.AERIAL_ACE, TM_IDS.FURY_CUTTER, TM_IDS.STEEL_WING, TM_IDS.RAIN_DANCE, TM_IDS.HEADBUTT, TM_IDS.SWIFT, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, TM_IDS.LIGHT_SCREEN, TM_IDS.SAFEGUARD, TM_IDS.BRICK_BREAK, TM_IDS.SANDSTORM },
    eggMoves = { "Baton Pass", "Bug Buzz", "Counter", "Defog", "Endure", "Night Slash", "Quick Guard", "Razor Wind", "Reversal", "Silver Wind", "Steel Wing" }
}

POKEMON["RC Scizor"] = table.deepcopy(POKEMON["Scizor"])
POKEMON["RC Scizor"].pTypes = { ELEMENT_POISON, ELEMENT_NORMAL }
POKEMON["RC Scizor"].blockTransform = true

POKEMON["Cloned Scizor"] = table.deepcopy(POKEMON["Scizor"])
POKEMON["Cloned Scizor"].blockTransform = true