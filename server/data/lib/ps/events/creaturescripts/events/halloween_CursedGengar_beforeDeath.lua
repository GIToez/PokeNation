local CURSED_SHEETS = {27982, 27983, 27984, 27985, 27986, 27987, 27988, 27989, 27990, 27991, 27992, 27993, 27994}

function onPrepareDeath(cid)
  local pos = getCreaturePosition(cid)
  for i = 0, 5 do
    local randomPos = getPositionRandomAdjacent(pos, getRandom(1, 5))
    doCreateItem(table.random(CURSED_SHEETS), 1, randomPos)
    doSendMagicEffect(randomPos, EFFECT_DARK_ENERGY_TWO)
  end
  return true
end