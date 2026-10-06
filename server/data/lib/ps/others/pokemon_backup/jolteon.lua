POKEMON["Jolteon"] = {
    pTypes = {ELEMENT_ELECTRIC}, dexStorage = 10135, atk = 65, def = 60, spAtk = 110, spDef = 95, energy = 100, chance = 500, portrait = 12836, dexPortrait = 13636, fastcallPortrait = 10769, catchStorage = 16135,
    evolutions = {},
    description = "If it is angered or startled, the fur all over its body bristles like sharp needles that pierce foes.",
    skills = {"Tackle", 1, "Quick Attack", 5, "Discharge", 10, "Thunder Shock", 15, "Double Kick", 20, "Thunder Fang", 25, "Pin Missile", 35, "Thunder Wave", 40, "Agility", 45, "Thunder", 50, "Sand-Attack", 55},
    abilities = {POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Find", "Flash", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_FIELD}, eggId = 14044, eggChance = 1,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.VOLT_ABSORB},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.MUD_SLAP, TM_IDS.SHADOW_BALL, TM_IDS.IRON_TAIL, TM_IDS.RAIN_DANCE, TM_IDS.ZAP_CANNON, TM_IDS.HEADBUTT, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.THUNDERBOLT, TM_IDS.THUNDER, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.THUNDER_WAVE, TM_IDS.SUBSTITUTE},
    eggMoves = {"Captivate", "Charm", "Covet", "Curse", "Detect", "Endure", "Fake Tears", "Flail", "Natural Gift", "Stored Power", "Synchronoise", "Tickle", "Wish", "Yawn"}
}

POKEMON["RC Jolteon"] = table.deepcopy(POKEMON["Jolteon"])
POKEMON["RC Jolteon"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Jolteon"].blockTransform = true

POKEMON["Darkeon"] = table.deepcopy(POKEMON["Jolteon"])
POKEMON["Darkeon"].blockTransform = true
POKEMON["Darkeon"].pTypes = {ELEMENT_DARK, ELEMENT_ELECTRIC}
POKEMON["Darkeon"].skills = {"Discharge", 1, "Thunder Fang", 1, "Thunder", 1, "Agility" , 1, "Dark Pulse", 1, "Sucker Punch", 1, "Zap Cannon", 1, "Electro Ball", 1, "Thunder Punch", 1, "Shadow Ball", 1, "Shadow Sneak", 1}
POKEMON["Darkeon"].specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.SUMMI}
POKEMON["Darkeon"].atk = POKEMON["Darkeon"].atk * 3
POKEMON["Darkeon"].def = POKEMON["Darkeon"].def * 3
POKEMON["Darkeon"].spAtk = POKEMON["Darkeon"].spAtk * 3
POKEMON["Darkeon"].spDef = POKEMON["Darkeon"].spDef * 3