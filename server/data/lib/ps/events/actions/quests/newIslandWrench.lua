local QUEST_STORAGE = 8560

local function getUsedOnRightSpot(pos)
  local spots = {
      [{x = 5499, y = 225, z = 6}] = {storage = 8560, itemId = 27428, messageComp = "Ash"},
      [{x = 5502, y = 245, z = 5}] = {storage = 8654, itemId = 27429, messageComp = "Corey"},
      [{x = 5541, y = 207, z = 5}] = {storage = 8655, itemId = 27430, messageComp = "Neesha"},
      [{x = 5514, y = 223, z = 3}] = {storage = 8656, itemId = 27431, messageComp = "Misty"},
      [{x = 5536, y = 212, z = 3}] = {storage = 8657, itemId = 27432, messageComp = "Brock"},
      [{x = 5536, y = 238, z = 3}] = {storage = 8658, itemId = 27433, messageComp = "Fergu"},
  }  
  for k, v in pairs(spots) do
    if (getSamePosition(pos, k)) then
      return v
    end
  end
  return false
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local spot = getUsedOnRightSpot(toPosition)
    if (not spot or getCreatureStorage(cid, spot.storage) == QUEST_STATUS.FINISHED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    
    if (getRandom(1, 100) <= 20) then    
      doSendMagicEffect(toPosition, EFFECT_EXPLOSION)
      doPlayerSafeAddItem(cid, spot.itemId, 1, true, true)
      doCreatureSetStorage(cid, spot.storage, QUEST_STATUS.FINISHED)
      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "%s's Pokemon were recovered!"), spot.messageComp))
          --doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, "Late kid, I do not need your Pokemon. I'm waiting for you in my battle arena, if you are so good come here without problems.")
          --doCreatureSay(cid, "Late kid, I do not need your Pokemon. I'm waiting for you in my battle arena, if you are so good come here without problems.", TALKTYPE_MONSTER_YELL)
          --doMakeClonedAppearOnCastle()
          --todo storage the player pokemon info to use later ???
          --[[addEvent(function(pos)
              doCreateItem(ITEMEX_ID, 1, pos)
          end, 5 * 60 * 1000, toPosition)]]
    else
      doSendMagicEffect(toPosition, EFFECT_ELECTRIC_SPARK)
      doSendAnimatedText(toPosition, "Poff", TEXTCOLOR_YELLOW)
    end
    return true
end
