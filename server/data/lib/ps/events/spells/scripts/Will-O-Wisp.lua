local SKILL_NAME = "Will-O-Wisp"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

function onTargetCreature_WillOWisp(cid, target)
    doSendDistanceShoot(getCreaturePosition(cid), getCreaturePosition(target), SKILL_PROJECTILE)
    doSendMagicEffect(getCreaturePosition(target), SKILL_EFFECT)
    if (isPokemon(target) and isInArray(getPokemonTypes(target), ELEMENT_FIRE)) then -- Fire Immunity
        doCreatureAddStatus(target, CREATURE_STATUS_BURN, 1, cid)
    else
        doCreatureAddStatus(target, CREATURE_STATUS_BURN, getMonsterLevel(cid), cid)
    end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_WillOWisp")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
