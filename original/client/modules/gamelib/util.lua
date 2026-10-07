function postostring(pos)
  return pos.x .. " " .. pos.y .. " " .. pos.z
end

function dirtostring(dir)
  for k,v in pairs(Directions) do
    if v == dir then
      return k
    end
  end
end

function getVocationNameById(vocation)
  if (vocation >= 10 and vocation <= 15) then
    return "blaze"
  elseif (vocation >= 20 and vocation <= 25) then
    return "hurricane"
  elseif (vocation >= 30 and vocation <= 35) then
    return "voltagic"
  elseif (vocation >= 40 and vocation <= 45) then
    return "spectrum"
  elseif (vocation >= 50 and vocation <= 55) then
    return "vital"
  elseif (vocation >= 60 and vocation <= 65) then
    return "gaia"
  elseif (vocation >= 70 and vocation <= 75) then
    return "avalanche"
  elseif (vocation >= 80 and vocation <= 85) then
    return "heremit"
  elseif (vocation >= 90 and vocation <= 95) then
    return "zen"
  end

  return "trainer"
end