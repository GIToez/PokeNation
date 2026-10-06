POKEMON["Beedrill"] = {
    pTypes = {ELEMENT_BUG, ELEMENT_POISON}, dexStorage = 10015, atk = 90, def = 40, spAtk = 45, spDef = 80, energy = 100, chance = 250, portrait = 12716, dexPortrait = 13516, fastcallPortrait = 10649, catchStorage = 16015,
    evolutions = {},
    description = "May appear in a swarm. Flies at violent speeds, all the while stabbing with the toxic stinger on its rear.",
    skills = {"Tackle", 1, "Bug Bite", 5, "Pin Missile", 10, "Harden", 15, "Endeavor", 20, "Twineedle", 30, "Poison Jab", 35, "Toxic Spikes", 40, "Fury Attack", 45, "Agility", 50, "Rage", 55, "Focus Energy", 60},
    abilities = {"Find", "Cut"}, eggGroup = {POKEMON_EGG_GROUP_BUG}, eggId = 13982, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.SWARM},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.POISON_JAB, TM_IDS.AERIAL_ACE, TM_IDS.FURY_CUTTER, TM_IDS.SLUDGE_BOMB, TM_IDS.SWORDS_DANCE, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MEGA_DRAIN, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE}
}

POKEMON["RC Beedrill"] = table.deepcopy(POKEMON["Beedrill"])
POKEMON["RC Beedrill"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Beedrill"].blockTransform = true