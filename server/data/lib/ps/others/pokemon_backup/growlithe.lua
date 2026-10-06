POKEMON["Growlithe"] = {
    pTypes = {ELEMENT_FIRE}, dexStorage = 10058, atk = 70, def = 45, spAtk = 70, spDef = 50, energy = 100, chance = 60, portrait = 12759, dexPortrait = 13559, fastcallPortrait = 10692, catchStorage = 16058,
    evolutions = {{name = "Arcanine", requiredLevel = 35, requiredItems = {ITEMS.FIRE_STONE}}},
    description = "Very friendly and faithful to people. It will try to repel enemies by barking and biting.",
    skills = {"Tackle", 1, "Bite", 5, "Ember", 10, "Flame Wheel", 15, "Fire Fang", 20, "Flamethrower", 25, "Agility", 30},
    abilities = {POKEMON_ABILITIES.DIG, POKEMON_ABILITIES.STRENGTH, "Find", "Headbutt"}, eggGroup = {POKEMON_EGG_GROUP_FIELD}, eggId = 14002, eggChance = 20,
    specialAbilities = {POKEMON_SPECIAL_ABILITY_IDS.INTIMIDATE, POKEMON_SPECIAL_ABILITY_IDS.FLASH_FIRE},
    learnableTms = {TM_IDS.FLAMETHROWER, TM_IDS.AERIAL_ACE, TM_IDS.IRON_TAIL, TM_IDS.HEADBUTT, TM_IDS.TOXIC, TM_IDS.BODY_SLAM, TM_IDS.TAKE_DOWN, TM_IDS.DOUBLE_EDGE, TM_IDS.RAGE, TM_IDS.DRAGON_RAGE, TM_IDS.MIMIC, TM_IDS.DOUBLE_TEAM, TM_IDS.REFLECT, TM_IDS.BIDE, TM_IDS.FIRE_BLAST, TM_IDS.SWIFT, TM_IDS.EGG_BOMB, TM_IDS.SKULL_BASH, TM_IDS.REST, TM_IDS.SUBSTITUTE},
    eggMoves = {"Body Slam", "Close Combat", "Covet", "Crunch", "Double Kick", "Double-Edge", "Fire Spin", "Flare Blitz", "Heat Wave", "Howl", "Iron Tail", "Morning Sun", "Thrash"}
}

POKEMON["RC Growlithe"] = table.deepcopy(POKEMON["Growlithe"])
POKEMON["RC Growlithe"].pTypes = {ELEMENT_POISON, ELEMENT_NORMAL}
POKEMON["RC Growlithe"].blockTransform = true