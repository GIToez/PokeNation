local SKILL_NAME = "Rolling Kick"

local OUTFIT_HITMONLEE_KICKING = createConditionObject(CONDITION_OUTFIT)
setConditionParam(OUTFIT_HITMONLEE_KICKING, CONDITION_PARAM_TICKS, -1)
addOutfitCondition(OUTFIT_HITMONLEE_KICKING, {lookType = 609})

local OUTFIT_HITMONTOP_KICKING = createConditionObject(CONDITION_OUTFIT)
setConditionParam(OUTFIT_HITMONTOP_KICKING, CONDITION_PARAM_TICKS, -1)
addOutfitCondition(OUTFIT_HITMONTOP_KICKING, {lookType = 1126})

local OUTFIT_SHINYHITMONLEE_KICKING = createConditionObject(CONDITION_OUTFIT)
setConditionParam(OUTFIT_SHINYHITMONLEE_KICKING, CONDITION_PARAM_TICKS, -1)
addOutfitCondition(OUTFIT_SHINYHITMONLEE_KICKING, {lookType = 883})

local kickingOutfits = {
	["Hitmonlee"] = OUTFIT_HITMONLEE_KICKING,
	["Hitmontop"] = OUTFIT_HITMONTOP_KICKING,
	["Shiny Hitmonlee"] = OUTFIT_SHINYHITMONLEE_KICKING
}

function onTargetCreature_RollingKick(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_RollingKick")

local function doSpell(cid, ticks)
	if (isCreature(cid)) then
		local target = getCreatureTarget(cid)
		if (isCreature(target)) then
			local cidPos = getCreaturePosition(cid)
			local targetPos = getCreaturePosition(target)
			if (isSightClear(cidPos, targetPos, true) and getDistanceBetween(cidPos, targetPos) <= 1) then
				doCombat(cid, combat, numberToVariant(target))
                if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                        (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 6 or 3)) then -- 30% / 10
                    doCreatureAddStatus(target, CREATURE_STATUS_FLINCH, nil, cid)
                end
			end
		end
		if (ticks > 0) then
			addEvent(doSpell, 500, cid, ticks - 1)
		else
			doRemoveCondition(cid, CONDITION_OUTFIT)
		end
	end
end

function onCastSpell(cid, var)
	local name = getPokemonReferenceName(cid)
	if (kickingOutfits[name] and not hasCondition(cid, CONDITION_OUTFIT)) then
		doAddCondition(cid, kickingOutfits[name])
	end
	doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPEED, nil, cid)
	doSpell(cid, 10)
	return true
end
