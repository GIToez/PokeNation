local SKILL_NAME = "Charge"
local PROJECTILE = getPokemonSkillProjectile(SKILL_NAME)
local EFFECT = getPokemonSkillEffect(SKILL_NAME)

local function doEffect(pos)
    doSendDistanceShoot(getSkyPosition(pos), pos, PROJECTILE)
    addEvent(doSendMagicEffect, 250, pos, EFFECT)
end

function onTargetCreature_Charge(cid, target)
    local pos = getCreaturePosition(cid)
	for i = 0, 5 do
        doEffect({x = pos.x + getRandom(-2, 2), y = pos.y + getRandom(-2, 2), z = pos.z})
    end
    doCreatureAddStatus(cid, CREATURE_STATUS_CHARGE, nil, cid)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Charge")
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
