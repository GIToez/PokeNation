local SKILL_NAME = "String Shot"
local SKILL_DISTANCE = getPokemonSkillMaxDistance(SKILL_NAME)

function onTargetCreature_StringShot(cid, target)
	local cidPos, targetPos, i = getCreaturePosition(cid), getCreaturePosition(target), 0
    for i = 0, SKILL_DISTANCE do
        addEvent(doSendDistanceShoot, 100 * (i - 1), cidPos, targetPos, PROJECTILE_STRING_SHOT)
    end
    doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BAD, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_StringShot")
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, getPokemonSkillProjectile(SKILL_NAME))
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end