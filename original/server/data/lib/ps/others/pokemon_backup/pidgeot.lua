POKEMON["Pidgeot"] = {
    pTypes = {ELEMENT_NORMAL, ELEMENT_FLYING}, dexStorage = 10018, atk = 80, def = 75, spAtk = 70, spDef = 70, energy = 100, chance = 600, portrait = 12719, dexPortrait = 13519, fastcallPortrait = 10652, catchStorage = 16018,
    evolutions = {},
    description = "It spreads its gorgeous wings widely to intimidate enemies. It races through the skies at Mach-2 speed.",
    skills = {"Tackle", 1, "Sand-Attack", 5, "Gust", 10, "Quick Attack", 15, "Drill Peck", 20, "Hurricane", 25, "Feather Dance", 30, "Wing Attack", 35, "Roost", 40, "Air Cutter", 45, "Steel Wing", 50, "Tailwind", 55, "Agility", 60, "Air Slash", 65},
    abilities = {"Find", "Fly"}, eggGroup = {POKEMON_EGG_GROUP_FLYING}, eggId = 13983, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.KEEN_EYE, POKEMON_SPECIAL_ABILITY_IDS.TANGLED_FEET},
    learnableTms = {TM_IDS.AERIAL_ACE, TM_IDS.STEEL_WING, TM_IDS.MUD_SLAP, TM_IDS.RAIN_DANCE, TM_IDS.RAZOR_WIND, TM_IDS.WHIRLWIND, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.SKY_ATTACK, TM_IDS.REST, TM_IDS.SUBSTITUTE},
    eggMoves = {"Air Cutter", "Air Slash", "Brave Bird", "Defog", "Faint Attack", "Foresight", "Pursuit", "Steel Wing", "Uproar"}
}

POKEMON["RC Pidgeot"] = table.deepcopy(POKEMON["Pidgeot"])
POKEMON["RC Pidgeot"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Pidgeot"].blockTransform = true

POKEMON["Cloned Pidgeot"] = table.deepcopy(POKEMON["Pidgeot"])
POKEMON["Cloned Pidgeot"].blockTransform = true