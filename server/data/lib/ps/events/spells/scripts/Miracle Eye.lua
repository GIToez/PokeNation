local SKILL_NAME = "Miracle Eye"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_MiracleEye(cid, target)
    local cidPos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    doSendDistanceShoot(cidPos, targetPos, SKILL_PROJECTILE)
    doSendMagicEffect(targetPos, SKILL_EFFECT)
    doSendMagicEffect(cidPos, SKILL_EFFECT)
    doCreatureAddStatus(target, CREATURE_STATUS_MIRACLE_EYE, nil, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MiracleEye")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
