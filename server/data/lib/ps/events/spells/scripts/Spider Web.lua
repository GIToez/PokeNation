local SKILL_NAME = "Spider Web"
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

function onTargetCreature_SpiderWeb(cid, target)
    doSendDistanceShoot(getCreaturePosition(cid), getCreaturePosition(target), PROJECTILE)
	doCreatureAddStatus(target, CREATURE_STATUS_PARALYSIS, nil, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_SpiderWeb")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
