local SKILL_NAME = "Foresight"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_Foresight(cid, target)
    local cidPos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    doSendDistanceShoot(cidPos, targetPos, SKILL_PROJECTILE)
    doSendMagicEffect(targetPos, SKILL_EFFECT)
    doSendMagicEffect(cidPos, SKILL_EFFECT)
    setPokemonCustomType(target, ELEMENT_FIGHT)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Foresight")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end