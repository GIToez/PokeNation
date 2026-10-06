local SKILL_NAME = "Toxic Spikes"
local SKILL_AREAS = {
	createCombatArea(AREA_CIRCLE2X2)
}
local SKILL_PROJECTILE = PROJECTILE_POISON_BLAST
local SKILL_AREAEFFECT = getPokemonSkillAreaEffect(SKILL_NAME)

local function isImmune(target)
    if (isMonster(target)) then
        local types = getPokemonTypes(target)
        for k, v in pairs(types) do
            if (v == ELEMENT_FLYING or v == ELEMENT_POISON or v == ELEMENT_STEEL) then
                return true
            end
        end
        return table.find({POKEMON_SPECIAL_ABILITY_IDS.IMMUNITY, POKEMON_SPECIAL_ABILITY_IDS.LEVITATE,
            POKEMON_SPECIAL_ABILITY_IDS.MAGIC_GUARD}, getMonsterSpecialAbility(target))
    end
    return false
end

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
	combats[i] = createCombatObject()
	onTargetCreature_ToxicSpikes = function(cid, target)
        if (not isImmune(target)) then
            doSkillDamage(cid, target, SKILL_NAME)
            if (not isCreature(target)) then return end -- Defeated
            if (not doPokemonSpecialAbilityCheck(target, POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST, nil)) then
                doCreatureAddStatus(target, (getCreatureStatus(target, CREATURE_STATUS_POISON) and
                        CREATURE_STATUS_BADPOISON or CREATURE_STATUS_POISON), getMonsterLevel(cid), cid)
            end
        end
    end
    onTargetTile_ToxicSpikes = function(cid, position)
		position.x = position.x + math.random(0, 2)
		position.y = position.y + math.random(0, 2)
		doSendDistanceShoot(getSkyPosition(position), position, SKILL_PROJECTILE)
		addEvent(doSendMagicEffect, 300, position, SKILL_AREAEFFECT)
	end
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ToxicSpikes")
	setCombatCallback(combats[i], CALLBACK_PARAM_TARGETTILE, "onTargetTile_ToxicSpikes")
	setCombatArea(combats[i], skillArea)
end

function onTargetCreature_ToxicSpikes(cid, target)
	local var = positionToVariant(getCreaturePosition(target))
	for i, combat in ipairs(combats) do
		addEvent(function(cid, combat, var)
            if (isCreature(cid)) then
                doCombat(cid, combat, var)
            end
        end, 500 * (i - 1) + 1, cid, combat, var)
	end
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_ToxicSpikes")
function onCastSpell(cid, var)
  local pos = getCreaturePosition(cid)
  local skyPos = getSkyPosition(pos)
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