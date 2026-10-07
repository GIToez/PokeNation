local SKILL_NAME = "Softboiled"
local SKILL_AREAS = {
  createCombatArea(AREA_SQUARE1X1)
}
local SKILL_EFFECT = getPokemonSkillEffect(SKILL_NAME)

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
  combats[i] = createCombatObject()
  onTargetCreature_Softboiled = function(cid, target)
    if (isFriend(cid, target)) then
      doSendMagicEffect(getCreaturePosition(target), SKILL_EFFECT)
      doCreatureAddHealth(target, math.ceil((getCreatureMaxHealth(target) / 2)))
    end
  end
  setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Softboiled")
  setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
  setCombatArea(combats[i], skillArea)
  setCombatParam(combats[i], COMBAT_PARAM_AGGRESSIVE, false)
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