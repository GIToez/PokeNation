MOVES["Stored Power"] = {
    description = "Stored Power deals variable damage depending on the stat modifications of the user. When the user has no stat modifications, Stored Power's base power is 20. Its power increases by 20 for each stat boost the user has.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 16330,
    iconId = 0,
    dType = DAMAGE_TYPE_PSYCHIC,
    functionName = "StoredPower",
    type = SKILLS_TYPES.AREA,
    requiredEnergy = 80,
    requiredLevel = 23,
    damage = 20,
    damageType = ELEMENT_PSYCHIC,
    effect = EFFECT_BLOW,
    areaEffect = EFFECT_BIG_YELLOW_ENERGY_BALL,
    cooldownTime = 18,
    cooldownStorage = 15291,
    damageText = "??"
}