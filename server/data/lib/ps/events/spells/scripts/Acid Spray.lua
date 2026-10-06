local SKILL_NAME = "Acid Spray"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE2X2)
}
local SKILL_PROJECTILE = PROJECTILE_EARTH
local SKILL_AREAEFFECT = getPokemonSkillAreaEffect(SKILL_NAME)

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_AcidSpray = function(cid, target)
		doSkillDamage(cid, target, SKILL_NAME)
        if (not isCreature(target)) then return end -- Defeated
        if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil)) then
            doCreatureAddStatus(target, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_VAR_BADMEDIUM, cid)
        end
    end
    onTargetTile_AcidSpray = function(cid, position)
		position.x = position.x + math.random(0, 2)
		position.y = position.y + math.random(0, 2)
		doSendDistanceShoot(getSkyPosition(position), position, SKILL_PROJECTILE)
		addEvent(doSendMagicEffect, 300, position, SKILL_AREAEFFECT)
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_AcidSpray")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_AcidSpray")
	setCombatArea(combats[i], skillArea)
end

function onTargetCreature_AcidSpray(cid, target)
	local var, i, combat = positionToVariant(getCreaturePosition(target))
	for i, combat in ipairs(combats) do
		addEvent(function(cid, combat, var)
            if (isCreature(cid)) then
                doCombat(cid, combat, var)
            end
        end, 500 * (i - 1) + 1, cid, combat, var)
	end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_AcidSpray")
function onCastSpell(cid, var)
  local pos = getCreaturePosition(cid)
  local skyPos, i = getSkyPosition(pos)
  for i = 1, 6 do
      addEvent(doSendDistanceShoot, 100 * (i - 1) + 1, pos, skyPos, SKILL_PROJECTILE)
  end
  addEvent(function(cid, combat, var)
      if (isCreature(cid)) then
          doCombat(cid, combat, var)
      end
  end, 1000, cid, combat, var)
  return true
end