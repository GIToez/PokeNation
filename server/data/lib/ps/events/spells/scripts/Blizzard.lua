local SKILL_NAME = "Blizzard"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE3X3)
}
local SKILL_PROJECTILE = PROJECTILE_ICE

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_Blizzard = function(cid, target)
        doSkillDamage(cid, target, SKILL_NAME)
        if (not isCreature(target)) then return end -- Defeated
        if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil) and getRandom(0, 100) <=
                (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE, nil) and 20 or 10)) then
            doCreatureAddStatus(target, CREATURE_STATUS_FREEZE, nil, cid)
        end
    end
    onTargetTile_Blizzard = function(cid, position)
        if (math.random(0, 1) == 1) then
            doSendDistanceShoot(getSkyPosition(position), position, SKILL_PROJECTILE)
            addEvent(doSendMagicEffect, 150, position, EFFECT_ICEBERG_TWO)
        end
    end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Blizzard")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_Blizzard")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

local function doSpells(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
end

function onCastSpell(cid, var)
    local pos, i = getCreaturePosition(cid)
	for i = 1, 5 do
	    if (i < 5) then
            addEvent(doSendDistanceShoot, 150 * (i - 1) + 1, pos, getSkyPosition(pos), SKILL_PROJECTILE)
        else
            addEvent(doSpells, 150 * (i - 1) + 1, cid, var)
        end
    end
	return true
end
