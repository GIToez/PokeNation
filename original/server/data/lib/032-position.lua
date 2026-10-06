function isInRange(position, fromPosition, toPosition, ignoreFloor)
  if (ignoreFloor) then
    return (position.x >= fromPosition.x and position.y >= fromPosition.y and position.x <= toPosition.x and position.y <= toPosition.y)
  else
    return (position.x >= fromPosition.x and position.y >= fromPosition.y and position.z >= fromPosition.z and position.x <= toPosition.x and position.y <= toPosition.y and position.z <= toPosition.z)
  end
end

function getDistanceBetween(fromPosition, toPosition)
  local x, y = math.abs(fromPosition.x - toPosition.x), math.abs(fromPosition.y - toPosition.y)
  local diff = math.max(x, y)
  if(fromPosition.z ~= toPosition.z) then
    diff = diff + 9 + 6
  end
  return diff
end

function getDirectionTo(pos1, pos2, excludeDiagonal)
  local dir = NORTH
  if(pos1.x > pos2.x) then
    dir = WEST
    if (not excludeDiagonal) then
      if(pos1.y > pos2.y) then
        dir = NORTHWEST
      elseif(pos1.y < pos2.y) then
        dir = SOUTHWEST
      end
    end
  elseif(pos1.x < pos2.x) then
    dir = EAST
    if (not excludeDiagonal) then
      if(pos1.y > pos2.y) then
        dir = NORTHEAST
      elseif(pos1.y < pos2.y) then
        dir = SOUTHEAST
      end
    end
  else
    if(pos1.y > pos2.y) then
      dir = NORTH
    elseif(pos1.y < pos2.y) then
      dir = SOUTH
    end
  end

  return dir
end

function getCreatureLookPosition(cid)
  return getPosByDir(getThingPos(cid), getCreatureLookDirection(cid))
end

function getPositionByDirection(position, direction, size)
  local n = size or 1
  if(direction == NORTH) then
    position.y = position.y - n
  elseif(direction == SOUTH) then
    position.y = position.y + n
  elseif(direction == WEST) then
    position.x = position.x - n
  elseif(direction == EAST) then
    position.x = position.x + n
  elseif(direction == NORTHWEST) then
    position.y = position.y - n
    position.x = position.x - n
  elseif(direction == NORTHEAST) then
    position.y = position.y - n
    position.x = position.x + n
  elseif(direction == SOUTHWEST) then
    position.y = position.y + n
    position.x = position.x - n
  elseif(direction == SOUTHEAST) then
    position.y = position.y + n
    position.x = position.x + n
  end

  return position
end

function doComparePositions(position, positionEx)
  return position.x == positionEx.x and position.y == positionEx.y and position.z == positionEx.z
end

function getArea(position, x, y)
  local t = {}
  for i = (position.x - x), (position.x + x) do
    for j = (position.y - y), (position.y + y) do
      table.insert(t, {x = i, y = j, z = position.z})
    end
  end
  return t
end

function getPositionRandomAdjacent(pos, size, checkFunc)
  if (not checkFunc) then
    return getPositionByDirection({x = pos.x, y = pos.y, z = pos.z},
      table.random({NORTH, EAST, SOUTH, WEST, SOUTHWEST, SOUTHEAST, NORTHWEST, NORTHEAST}), size or 1)
  end

  local dirs = {NORTH, EAST, SOUTH, WEST, SOUTHWEST, SOUTHEAST, NORTHWEST, NORTHEAST}
  for i = 1, #dirs do
    local dir = table.randomRemove(dirs)
    local tmpPos = getPositionByDirection({x = pos.x, y = pos.y, z = pos.z}, dir, size or 1)
    if (checkFunc(tmpPos)) then
      return tmpPos
    end
  end
  return nil
end

function doConcatPositions(main, add)
  main.x = main.x + (add.x or 0)
  main.y = main.y + (add.y or 0)
  main.z = main.z + (add.z or 0)
  return main
end

local origDoTeleportThing = doTeleportThing
function doTeleportThing(cid, newpos, pushmove) -- Remake doTeleportThing to prevent wild pokemon teleport to sea
  if (isMonster(cid)) then
    local thing = getThingFromPos({x = newpos.x, y = newpos.y, z = newpos.z, stackpos = STACKPOS_GROUND})
    if (isItem(thing) and table.find(WATER_IDS, thing.itemid)) then
      return false
    end
  end

  return origDoTeleportThing(cid, newpos, pushmove)
end

function getSameFloor(posA, posB)
  return posA.z == posB.z
end