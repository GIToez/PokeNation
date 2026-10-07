local SKILL_NAME = "Selfdestruct"
local SKILL_AREAS = {
  createCombatArea(AREA_CIRCLE3X3)
}

local combats = {}
for i, skillArea in ipairs(SKILL_AREAS) do
  combats[i] = createCombatObject()
  onTargetCreature_Selfdestruct = function(cid, target) doSkillDamage(cid, target, SKILL_NAME) end
  setCombatCallback(combats[i], CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Selfdestruct")
  setCombatParam(combats[i], COMBAT_PARAM_EFFECT, getPokemonSkillAreaEffect(SKILL_NAME))
  setCombatArea(combats[i], skillArea)
end

local function doSpell(cid, combat, ticks)
  if (isCreature(cid)) then
    if (ticks > 0) then
      local cidPos = getCreaturePosition(cid)
      doSendMagicEffect(cidPos, EFFECT_PURPLE_ENERGIZE)
      doSendAnimatedText(cidPos, ticks, COLOR_RED)
      addEvent(doSpell, 1000, cid, combat, ticks - 1)
    else
      doCombat(cid, combat, positionToVariant(getCreaturePosition(cid)))
      doCreatureDie(cid)
    end
  end
end

function onCastSpell(cid, var)
  for i, combat in ipairs(combats) do
    doSpell(cid, combat, 3)
  end
  return true
end
