local SKILL_NAME = "Reflect Type"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_ReflectType(cid, target)
    local cidPos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    doSendDistanceShoot(cidPos, targetPos, SKILL_PROJECTILE)
    doSendMagicEffect(targetPos, SKILL_EFFECT)
    doSendMagicEffect(cidPos, SKILL_EFFECT)
    if (isPokemon(target)) then
        setPokemonCustomType(cid, getPokemonTypes(target)[1])
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ReflectType")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
