local SKILL_NAME = "Simple Beam"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_SimpleBeam(cid, target)
    local cidPos, targetPos = getCreaturePosition(cid), getCreaturePosition(target)
    doSendDistanceShoot(cidPos, targetPos, SKILL_PROJECTILE)
    doSendMagicEffect(targetPos, SKILL_EFFECT)
    doSendMagicEffect(cidPos, SKILL_EFFECT)
    setMonsterSpecialAbility(target, POKEMON_SPECIAL_ABILITY_IDS.SIMPLE)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SimpleBeam")
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
