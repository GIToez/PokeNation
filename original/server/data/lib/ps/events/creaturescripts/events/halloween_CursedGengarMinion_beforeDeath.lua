local CURSED_SHEETS = {27982, 27983, 27984, 27985, 27986, 27987, 27988, 27989, 27990, 27991, 27992, 27993, 27994}

function onPrepareDeath(cid)
  local pos = getCreaturePosition(cid)
  doCreateItem(table.random(CURSED_SHEETS), 1, pos)
  doSendMagicEffect(pos, EFFECT_DARK_ENERGY_TWO)
  doRemoveCreature(cid)
  return false
end