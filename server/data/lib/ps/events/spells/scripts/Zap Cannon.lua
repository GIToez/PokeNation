local SKILL_NAME = "Zap Cannon"
local LOOK_DIRS = {
	[NORTH] = {x = 0, y = -1, effectS = EFFECT_YELLOW_BEAM_UP_START, effectM = EFFECT_YELLOW_BEAM_UP_MIDDLE, effectE = EFFECT_YELLOW_BEAM_UP_END},
	[EAST] =  {x = 1, y = 0, effectS = EFFECT_YELLOW_BEAM_RIGHT_START, effectM = EFFECT_YELLOW_BEAM_RIGHT_MIDDLE, effectE = EFFECT_YELLOW_BEAM_RIGHT_END},
	[SOUTH] = {x = 0, y = 1, effectS = EFFECT_YELLOW_BEAM_DOWN_START, effectM = EFFECT_YELLOW_BEAM_DOWN_MIDDLE, effectE = EFFECT_YELLOW_BEAM_DOWN_END},
	[WEST] =  {x = -1, y = 0, effectS = EFFECT_YELLOW_BEAM_LEFT_START, effectM = EFFECT_YELLOW_BEAM_LEFT_MIDDLE, effectE = EFFECT_YELLOW_BEAM_LEFT_END}
}
local HALF_POWER = math.floor(getPokemonSkillDamage(SKILL_NAME) / 2)

function onTargetCreature_ZapCannon(cid, target)
    doSkillDamage(cid, target, SKILL_NAME)
    if (not isCreature(target)) then return end -- Defeated
    if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil)) then
        doCreatureAddStatus(target, CREATURE_STATUS_PARALYSIS, nil, cid)
    end
end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ZapCannon")
setCombatArea(combat, createCombatArea({{1}}))

function onTargetCreature_ZapCannonHalf(cid, target)
    doSkillDamage(cid, target, SKILL_NAME, HALF_POWER)
end
local combatEffect = createCombatObject()
setCombatArea(combatEffect, createCombatArea({{1, 2, 1}}))
setCombatParam(combatEffect, COMBAT_PARAM_EFFECT, EFFECT_YELLOW_ENERGIZE)
setCombatCallback(combatEffect, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ZapCannonHalf")

local function doSpell(cid, toDirection, lastPosition, ticks)
	if (isCreature(cid)) then
		lastPosition.x = lastPosition.x + LOOK_DIRS[toDirection].x
		lastPosition.y = lastPosition.y + LOOK_DIRS[toDirection].y
		if (ticks == 7) then
			doSendMagicEffect(lastPosition, LOOK_DIRS[toDirection].effectS)
		elseif (ticks == 0) then
			doSendMagicEffect(lastPosition, LOOK_DIRS[toDirection].effectE)
		else
			doSendMagicEffect(lastPosition, LOOK_DIRS[toDirection].effectM)
		end
		doCombat(cid, combat, positionToVariant(lastPosition))
        doCombat(cid, combatEffect, positionToVariant(lastPosition))
		if (ticks > 0) then
			doSpell(cid, toDirection, lastPosition, ticks - 1)
		end
	end
end

function onCastSpell(cid, var)
	doSpell(cid, getCreatureLookDirection(cid), getCreaturePosition(cid), 7)
	return true
end