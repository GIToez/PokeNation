local SKILL_NAME = "Triple Kick"

local OUTFIT_HITMONTOP = createConditionObject(CONDITION_OUTFIT)
setConditionParam(OUTFIT_HITMONTOP, CONDITION_PARAM_TICKS, -1)
addOutfitCondition(OUTFIT_HITMONTOP, {lookType = 1107})

local outfits = {
	["Hitmontop"] = OUTFIT_HITMONTOP
}

function onTargetCreature_TripleKick(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_TripleKick")
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, getPokemonSkillProjectile(SKILL_NAME))
setCombatArea(combat, createCombatArea(AREA_CIRCLE2X2))

local function doSpell(cid, ticks)
	if (isCreature(cid)) then
        local pos = getCreaturePosition(cid)
        doSendMagicEffect({x = pos.x + 1, y = pos.y - 1, z = pos.z}, EFFECT_GRAY_WING_ATTACK_UP)
        doSendMagicEffect({x = pos.x + 2, y = pos.y + 1, z = pos.z}, EFFECT_GRAY_WING_ATTACK_RIGHT)
        doSendMagicEffect({x = pos.x + 1, y = pos.y + 2, z = pos.z}, EFFECT_GRAY_WING_ATTACK_DOWN)
        doSendMagicEffect({x = pos.x - 1, y = pos.y + 1, z = pos.z}, EFFECT_GRAY_WING_ATTACK_LEFT)
		doCombat(cid, combat, positionToVariant(pos))
		if (ticks > 0) then
			addEvent(doSpell, 500, cid, ticks - 1)
		else
			doRemoveCondition(cid, CONDITION_OUTFIT)
		end
	end
end

function onCastSpell(cid, var)
	local name = getPokemonReferenceName(cid)
	if (outfits[name] and not hasCondition(cid, CONDITION_OUTFIT)) then
		doAddCondition(cid, outfits[name])
	end
	doSpell(cid, 3)
	return true
end
