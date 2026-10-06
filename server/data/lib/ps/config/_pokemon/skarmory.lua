POKEMON["Skarmory"] = {
    pTypes = { ELEMENT_STEEL, ELEMENT_FLYING },
    dexStorage = 10227,
    atk = 80,
    def = 140,
    spAtk = 40,
    spDef = 70,
    energy = 100,
    chance = 900,
    portrait = 17516,
    dexPortrait = 15874,
    fastcallPortrait = 16074,
    catchStorage = 16227,
    evolutions = {},
    description = "After nesting in bramble bushes, the wings of its chicks grow hard from scratches by thorns.",
    skills = { "Tackle", 1, "Peck", 5, "Sand-Attack", 10, "Drill Peck", 15, "Metal Claw", 20, "Swift", 25, "Agility", 30, "Steel Wing", 35, "Roost", 40, "Slash", 45, "Air Cutter", 50, "Iron Head", 55, "Night Slash", 60, "Air Slash", 65, "Metal Sound", 70 },
    abilities = { "Find", "Cut", "Fly" },
    eggGroup = { POKEMON_EGG_GROUP_FLYING },
    eggId = 17778,
    eggChance = 20,
    specialAbilities = { POKEMON_SPECIAL_ABILITY_IDS.KEEN_EYE, POKEMON_SPECIAL_ABILITY_IDS.STURDY },
    learnableTms = { TM_IDS.AERIAL_ACE, TM_IDS.ROCK_TOMB, TM_IDS.STEEL_WING, TM_IDS.MUD_SLAP, TM_IDS.SWIFT, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REST, TM_IDS.BIDE, TM_IDS.SUBSTITUTE, TM_IDS.ROCK_SLIDE },
    eggMoves = { "Assurance", "Brave Bird", "Curse", "Drill Peck", "Endure", "Guard Swap", "Pursuit", "Sky Attack", "Stealth Rock", "Whirlwind" }
}

POKEMON["Cloned Skarmory"] = table.deepcopy(POKEMON["Skarmory"])
POKEMON["Cloned Skarmory"].blockTransform = true