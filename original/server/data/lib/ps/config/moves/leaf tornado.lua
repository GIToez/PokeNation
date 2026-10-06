MOVES["Leaf Tornado"] = {
    description = "Leaf Tornado deals damage and has a 30% chance of lowering the target's Accuracy by one stage.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 12100,
    iconId = 0,
    dType = DAMAGE_TYPE_GRASS,
    functionName = "LeafTornado",
    type = SKILLS_TYPES.AREA,
    requiredEnergy = 75,
    requiredLevel = 30,
    damage = 65,
    damageType = ELEMENT_GRASS,
    effect = EFFECT_LEAVES,
    areaEffect = EFFECT_WIND,
    projectile = PROJECTILE_LEAF,
    cooldownTime = 18,
    cooldownStorage = 15198
}