local SKILL_NAME = "Toxic"
local SKILL_PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)

function onTargetCreature_Toxic(cid, target)
	doSendDistanceShoot(getCreaturePosition(cid), getCreaturePosition(target), SKILL_PROJECTILE)
    doCreatureAddStatus(target, CREATURE_STATUS_BADPOISON, getMonsterLevel(cid), cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Toxic")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
