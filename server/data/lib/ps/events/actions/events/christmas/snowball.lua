local OUTFIT = createConditionObject(CONDITION_OUTFIT, -1, nil, CONDITION_SUBID.OUTFITS.CHRISTMAS)
addOutfitCondition(OUTFIT, {lookType = 1222})

function onUse(cid, item, fromPosition, itemEx, toPosition)
  if (isPlayer(itemEx.uid) and cid ~= itemEx.uid and not getPlayerMounted(itemEx.uid) and not isBiking(itemEx.uid)) then
    if (isGamemaster(itemEx.uid)) then
      if (getPlayerMounted(cid) or isBiking(cid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
      end

      if (getCreatureCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.CHRISTMAS)) then
        doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.CHRISTMAS)
      end

      doSendDistanceShoot(pos, fromPosition, PROJECTILE_ICE_BALL)
      doSendMagicEffect(fromPosition, EFFECT_FREEZE)
      doAddCondition(cid, OUTFIT)
      doRemoveItem(item.uid, 1)
      doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.CHRISTMAS_SNOWBALL)
      doCreatureAddStatus(cid, CREATURE_STATUS_FREEZE, nil, itemEx.uid)
      return true
    end

    if (getCreatureCondition(itemEx.uid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.CHRISTMAS)) then
      doRemoveCondition(itemEx.uid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.CHRISTMAS)
    end
    local pos = getCreaturePosition(itemEx.uid)
    doSendDistanceShoot(fromPosition, pos, PROJECTILE_ICE_BALL)
    doSendMagicEffect(pos, EFFECT_FREEZE)
    doAddCondition(itemEx.uid, OUTFIT)
    doRemoveItem(item.uid, 1)
    doPlayerAchievementCheck(itemEx.uid, ACHIEVEMENT_IDS.CHRISTMAS_SNOWBALL)

    if (getCreatureCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.CHRISTMAS)) then
      doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.CHRISTMAS)
      doSendMagicEffect(getCreaturePosition(cid), EFFECT_POFF)
    end
  else
    doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
  end
  return true
end
