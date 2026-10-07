MOVES["Eruption"] = {
    description = "Eruption does damage proportionately based on the user's HP. This move's base power reduces as the user's HP reduces and is calculated by the formula: Power = 150 x current HP / maximum HP. Hence, at maximum HP (100% HP), the move's base power would be 150.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 16308,
    iconId = 0,
    dType = DAMAGE_TYPE_FIRE,
    functionName = "Eruption",
    type = SKILLS_TYPES.AREA,
    requiredEnergy = 150,
    requiredLevel = 23,
    damage = 150,
    damageType = ELEMENT_FIRE,
    effect = EFFECT_FIRE_FIELD,
    projectile = PROJECTILE_FIRE,
    cooldownTime = 30,
    cooldownStorage = 15269,
    damageText = "??"
}