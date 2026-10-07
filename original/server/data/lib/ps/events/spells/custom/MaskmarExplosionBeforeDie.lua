local SKILL_NAME = "Explosion"
local SKILL_AREAS = {
  createCombatArea(AREA_CROSS5X5)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
  combats[i] = createCombatObject()
  onTargetCreature_Explosion = function(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
  setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Explosion")
  setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
  setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, var)
  if (isCreature(cid)) then
    doCombat(cid, combat, var)
    doCreatureAddHealth(cid, getCreatureMaxHealth(cid) / 20)
  end
end

function onCastSpell(cid, var)
  if (getCreatureHealth(cid) / getCreatureMaxHealth(cid) <= 0.10) then  -- Only works when HP 10% or below
    for i, combat in ipairs(combats) do
      addEvent(doSpell, 500 * (i - 1) + 1, cid, combat, var)
    end
  end
  return true
end