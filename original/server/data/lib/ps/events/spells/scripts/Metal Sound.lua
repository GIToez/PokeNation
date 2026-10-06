-- local SKILL_NAME = "Metal Sound"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE3X3)
}
local EFFECTS = {EFFECT_GRAY_WING_ATTACK_UP, EFFECT_GRAY_WING_ATTACK_RIGHT, EFFECT_GRAY_WING_ATTACK_DOWN,
    EFFECT_GRAY_WING_ATTACK_LEFT}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_MetalSound = function(cid, target)
        if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SOUNDPROOF, nil)) then
            doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_BADMEDIUM, cid)
        end
    end
	onTargetTile_MetalSound = function(cid, position)
        doSendMagicEffect(position, table.random(EFFECTS))
        addEvent(doSendMagicEffect, 300, position, table.random(EFFECTS))
    end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_MetalSound")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_MetalSound")
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onCastSpell(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
	end
	return true
end