local SKILL_NAME = "Wing Attack"
local LOOK_DIRS = {
	[NORTH] = {x = 1, y = -1, effect = EFFECT_WING_ATTACK_UP},
	[EAST] =  {x = 2, y = 1, effect = EFFECT_WING_ATTACK_RIGHT},
	[SOUTH] = {x = 1, y = 2, effect = EFFECT_WING_ATTACK_DOWN},
	[WEST] =  {x = -1, y = 1, effect = EFFECT_WING_ATTACK_LEFT}
}

function onTargetCreature_WingAttack(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
local combat = createCombatObject()
setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_WingAttack")
setCombatArea(combat, createCombatArea(AREA_WAVE3X3))

local function doSpell(cid, var)
	local dir, pos = getCreatureLookDirection(cid), getCreaturePosition(cid)
	doSendMagicEffect({x = pos.x + LOOK_DIRS[dir].x, y = pos.y + LOOK_DIRS[dir].y, z = pos.z}, LOOK_DIRS[dir].effect)
	doCombat(cid, combat, var)
end

function onCastSpell(cid, var)
	doSpell(cid, var)
	return true
end