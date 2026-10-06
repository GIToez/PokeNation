function onUse(cid, item, fromPosition, itemEx, toPosition)
    doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.TASTY_CAKE)
    if (not doExtraExpRateStart(cid, 3 * 60 * 60, 0.4)) then
        doPlayerSendCancel(cid, "You already have got the experience bonus.")
    end
    doTeleportThing(cid, TRADE_ROOM_POSITION, false)
    return true
end
