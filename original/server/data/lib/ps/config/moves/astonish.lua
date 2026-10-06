MOVES["Astonish"] = {
    description = "The user attacks the target while shouting in a startling fashion. This may also make the target flinch.",
    makeContact = true,
    category = MOVE_CATEGORY.PHYSICAL,
    clientIconId = 26961,
    dType = DAMAGE_TYPE_GHOST,
    type = SKILLS_TYPES.TARGET,
    requiredEnergy = 30,
    damage = 30,
    damageType = ELEMENT_GHOST,
    effect = EFFECT_SCARY_FACE,
    projectile = PROJECTILE_TONGUE,
    maxDistance = 1,
    cooldownTime = 5,
    cooldownStorage = 15385
}