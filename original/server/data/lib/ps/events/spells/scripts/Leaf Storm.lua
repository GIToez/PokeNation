local SKILL_NAME = "Leaf Storm"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
    createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3),
	createCombatArea(AREA_CIRCLE3X3)
}
local EFFECTS = {EFFECT_LEAVES, EFFECT_LEAVES_TWO, EFFECT_ROOTS}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_LeafStorm = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
    end
    onTargetTile_LeafStorm = function(cid, position)
		doSendDistanceShoot(getCreaturePosition(cid), position, PROJECTILE_LEAF)
        doSendMagicEffect(position, table.random(EFFECTS))
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_LeafStorm")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_LeafStorm")
	setCombatParam(combats[i], COMBAT_PARAM_DISTANCEEFFECT, getPokemonSkillProjectile(SKILL_NAME))
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
    addEvent(function(cid)
        if (isCreature(cid)) then
            doCreatureAddStatus(cid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_BADMEDIUM, cid)
        end
    end, 500 * (#SKILL_AREAS + 1), cid)
	return true
end