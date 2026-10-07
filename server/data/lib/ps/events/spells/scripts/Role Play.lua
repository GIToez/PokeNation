local SKILL_NAME = "Role Play"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_RolePlay(cid, target)
    local cidPos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    doSendDistanceShoot(cidPos, targetPos, SKILL_PROJECTILE)
    doSendMagicEffect(targetPos, SKILL_EFFECT)
    doSendMagicEffect(cidPos, SKILL_EFFECT)
    setMonsterSpecialAbility(cid, getMonsterSpecialAbility(target))
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_RolePlay")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
