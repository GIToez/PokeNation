MOVES["Hex"] = {
    description = "Hex inflicts damage, but if the target has a status ailment (i.e. is burned, poisoned, paralyzed, asleep or frozen) it will double in power.",
    category = MOVE_CATEGORY.SPECIAL,
    clientIconId = 12113,
    iconId = 0,
    dType = DAMAGE_TYPE_GHOST,
    functionName = "Hex",
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 90,
    requiredLevel = 45,
    damage = 65,
    damageType = ELEMENT_GHOST,
    effect = EFFECT_DARK_ENERGY,
    projectile = PROJECTILE_NIGHT_SHADE,
    maxDistance = 6,
    cooldownTime = 12,
    cooldownStorage = 15211
}