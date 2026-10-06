POKEMON["Seadra"] = {
    pTypes = {ELEMENT_WATER}, dexStorage = 10117, atk = 65, def = 95, spAtk = 95, spDef = 45, energy = 100, chance = 250, portrait = 12818, dexPortrait = 13618, fastcallPortrait = 10751, catchStorage = 16117,
    evolutions = {{name = "Kingdra", requiredLevel = 60, requiredItems = {ITEMS.DRAGON_SCALE}}},
    description = "Its body bristles with sharp spikes. Carelessly trying to touch it could cause fainting from the spikes.",
    skills = {"Tackle", 1, "Bubble", 5, "Twister", 10, "Water Gun", 15, "Brine", 20, "Bubblebeam", 25, "Agility", 30, "Mud Shot", 40, "Smoke Screen", 45, "Hydro Pump", 50, "Focus Energy", 55},
    abilities = {POKEMON_ABILITIES.WATERFALL, "Surf", "Dive", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_WATER_1, POKEMON_EGG_GROUP_DRAGON}, eggId = 14032, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.POISON_POINT, POKEMON_SPECIAL_ABILITY_IDS.SNIPER},
    learnableTms = {TM_IDS.SOFTBOILED, TM_IDS.WATER_PULSE, TM_IDS.RAIN_DANCE, TM_IDS.ICY_WIND, TM_IDS.HEADBUTT, TM_IDS.TOXIC, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.BUBBLEBEAM, TM_IDS.WATER_GUN, TM_IDS.ICE_BEAM, TM_IDS.BLIZZARD, TM_IDS.HYPER_BEAM, TM_IDS.RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.BIDE, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE},
    eggMoves = {"Aurora Beam", "Clear Smog", "Disable", "Dragon Breath", "Dragon Rage", "Flail", "Muddy Water", "Octazooka", "Outrage", "Razor Wind", "Signal Beam", "Splash", "Water Pulse"}
}

POKEMON["RC Seadra"] = table.deepcopy(POKEMON["Seadra"])
POKEMON["RC Seadra"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Seadra"].blockTransform = true