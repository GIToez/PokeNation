Position = {}

function Position.equals(pos1, pos2)
  return pos1.x == pos2.x and pos1.y == pos2.y and pos1.z == pos2.z
end

function Position.greaterThan(pos1, pos2, orEqualTo)
  if orEqualTo then
    return pos1.x >= pos2.x or pos1.y >= pos2.y or pos1.z >= pos2.z
  else
    return pos1.x > pos2.x or pos1.y > pos2.y or pos1.z > pos2.z
  end
end

function Position.lessThan(pos1, pos2, orEqualTo)
  if orEqualTo then
    return pos1.x <= pos2.x or pos1.y <= pos2.y or pos1.z <= pos2.z
  else
    return pos1.x < pos2.x or pos1.y < pos2.y or pos1.z < pos2.z
  end
end

function Position.isInRange(pos1, pos2, xRange, yRange)
  return math.abs(pos1.x-pos2.x) <= xRange and math.abs(pos1.y-pos2.y) <= yRange and pos1.z == pos2.z;
end

function Position.isValid(pos)
  return not (pos.x == 65535 and pos.y == 65535 and pos.z == 255)
end

function Position.distance(pos1, pos2)
  return math.sqrt(math.pow((pos2.x - pos1.x), 2) + math.pow((pos2.y - pos1.y), 2))
end

function Position.manhattanDistance(pos1, pos2)
  return math.abs(pos2.x - pos1.x) + math.abs(pos2.y - pos1.y)
end

function Position.isIn(pos, fromPos, toPos)
    return pos.x >= fromPos.x and pos.y >= fromPos.y and pos.z >= fromPos.z and
            pos.x <= toPos.x and pos.y <= toPos.y and pos.z <= toPos.z
end

function Position.getPositionByDirection(position, direction, size)
  local n = size or 1
  if(direction == North) then
    position.y = position.y - n
  elseif(direction == South) then
    position.y = position.y + n
  elseif(direction == West) then
    position.x = position.x - n
  elseif(direction == East) then
    position.x = position.x + n
  elseif(direction == NorthWest) then
    position.y = position.y - n
    position.x = position.x - n
  elseif(direction == NorthEast) then
    position.y = position.y - n
    position.x = position.x + n
  elseif(direction == SouthWest) then
    position.y = position.y + n
    position.x = position.x - n
  elseif(direction == SouthEast) then
    position.y = position.y + n
    position.x = position.x + n
  end

  return position
end