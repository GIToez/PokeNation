POKEMON["Steelix"] = {
    pTypes = { ELEMENT_STEEL, ELEMENT_GROUND },
    dexStorage = 10208,
    atk = 85,
    def = 200,
    spAtk = 55,
    spDef = 65,
    energy = 100,
    chance = 2000,
    portrait = 17497,
    dexPortrait = 15855,
    fastcallPortrait = 16055,
    catchStorage = 16208,
    evolutions = {},
    description = "It is said that if an ONIX lives for over 100 years, its composition changes to become diamond-like.",
    skills = { "Tackle", 1, "Rock Throw", 5, "Thunder Fang", 10, "Ice Fang", 15, "Fire Fang", 20, "Harden", 25, "Smack Down", 30, "Stealth Rock", 35, "Iron Tail", 40, "Rock Slide", 45, "Earthquake", 50, "Crunch", 60, "Double-Edge", 65, "Dragon Breath", 70 },
    abilities = { POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.ROCK_CLIMB, POKEMON_ABILITIES.STRENGTH, "Cut", "Rock Smash", "Ride", "Headbutt" },
    eggGroup = { POKEMON_EGG_GROUP_MINERAL },
    eggId = 14018,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.ROCK_HEAD, POKEMON_SPECIAL_ABILITY_IDS.STURDY },
    learnableTms = { TM_IDS.SOFTBOILED, TM_IDS.ROCK_TOMB, TM_IDS.DEFENSE_CURL, TM_IDS.MUD_SLAP, TM_IDS.IRON_TAIL, TM_IDS.HEADBUTT, TM_IDS.ROCK_SLIDE, TM_IDS.EXPLOSION, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.EARTHQUAKE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, TM_IDS.ROAR, TM_IDS.TAUNT, TM_IDS.SANDSTORM},
    eggMoves = { "Block", "Defense Curl", "Flail", "Heavy Slam", "Rock Blast", "Rock Climb", "Rollout", "Rototiller", "Stealth Rock" }
}

POKEMON["Cloned Steelix"] = table.deepcopy(POKEMON["Steelix"])
POKEMON["Cloned Steelix"].blockTransform = true