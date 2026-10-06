local SKILL_NAME = "Stored Power"
local SKILL_AREAS = {
	createCombatArea(AREA_SQUARE1X1),
	createCombatArea(AREA_CIRCLE2X2_EMPTY),
	createCombatArea(AREA_CIRCLE3X3_EMPTY),
	createCombatArea(AREA_CIRCLE4X4_EMPTY)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_StoredPower = function(cid, target)
        local power = 20
        if (getCreatureStatus(cid, CREATURE_STATUS_EXTRASPDEF)) then
            power = power + 20
        end
        if (getCreatureStatus(cid, CREATURE_STATUS_EXTRASPATK)) then
            power = power + 20
        end
        if (getCreatureStatus(cid, CREATURE_STATUS_EXTRASPEED)) then
            power = power + 20
        end
        doSkillDamage(cid, target, SKILL_NAME, power)
    end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_StoredPower")
	setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
	setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
	if (isCreature(cid)) then
		doCombat(cid, combat, var)
	end
end

function onCastSpell(cid, var)
	for i, combat in ipairs(combats) do
		addEvent(doSpell, 250 * (i - 1) + 1, cid, combat, var)
	end
	return true
end
