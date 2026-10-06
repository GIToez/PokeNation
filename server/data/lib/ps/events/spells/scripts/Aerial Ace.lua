local SKILL_NAME = "Aerial Ace"

function onTargetCreature_AerialAce(cid, target)
	local pos = getPositionAdjacent(cid, getCreaturePosition(target), false)
    if (pos) then
        doSendMagicEffect(getCreaturePosition(cid), EFFECT_TELEPORT_FRAME)
        doTeleportThing(cid, pos, false)
        doSendMagicEffect(pos, EFFECT_TELEPORT_FRAME)
    end
    pos = getCreaturePosition(target)
	doSendMagicEffect({x = pos.x, y = pos.y + 1, z = pos.z}, EFFECT_WING_ATTACK_RIGHT)
	doSendMagicEffect({x = pos.x, y = pos.y + 1, z = pos.z}, EFFECT_WING_ATTACK_LEFT)
    doSendMagicEffect({x = pos.x + 1, y = pos.y , z = pos.z}, EFFECT_WING_ATTACK_RIGHT)
	doSendMagicEffect({x = pos.x + 1, y = pos.y, z = pos.z}, EFFECT_WING_ATTACK_LEFT)
    doSkillDamage(cid, target, SKILL_NAME)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_AerialAce")
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, getPokemonSkillProjectile(SKILL_NAME))
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
