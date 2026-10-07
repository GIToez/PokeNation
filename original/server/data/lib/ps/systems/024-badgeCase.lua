local BADGE_CASES = {}
-- Use badges in inverse order, because it will reverse when added on the case container
BADGE_CASES[BADGE_CASE_IDS.KANTO] = {itemId = 12280, upgrade = BADGE_CASE_IDS.ORANGE_ARCHIPELAGO,
    badges = {BADGES.EARTH, BADGES.VOLCANO, BADGES.MARSH, BADGES.SOUL, BADGES.RAINBOW, BADGES.THUNDER,
        BADGES.CASCADE, BADGES.BOULDER}}

BADGE_CASES[BADGE_CASE_IDS.ORANGE_ARCHIPELAGO] = {itemId = 18623, badges = {BADGES.JADE_STAR,
    BADGES.SPIKE_SHELL, BADGES.SEA_RUBY, BADGES.CORAL_EYE}}

local BADGE_CASE_BY_ITEMID = {}
for k, v in pairs(BADGE_CASES) do
    BADGE_CASE_BY_ITEMID[v.itemId] = k
end

function doPlayerUpgradeBadgeCase(cid, oldCase)
    local item = getPlayerSlotItem(cid, PLAYER_SLOT_BADGES)
    if (not isItem(item)) then
        return
    end

    if (not BADGE_CASES[oldCase].upgrade) then
        return
    end


    if (doPlayerRemoveItem(cid, BADGE_CASES[oldCase].itemId, 1)) then
        local case = doPlayerAddItem(cid, BADGE_CASES[BADGE_CASES[oldCase].upgrade].itemId, 1, false)
        if (not case) then
            return
        end

        -- TODO: When the 3rd case got added, this need to be reworked cuz now it will fix only old and new cases
        for _, badge in pairs(BADGE_CASES[oldCase].badges) do
            doAddContainerItem(case, badge.newItemId, 1)
        end

        for _, badge in pairs(BADGE_CASES[BADGE_CASES[oldCase].upgrade].badges) do
            doAddContainerItem(case, badge.oldItemId, 1)
        end

        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Your badge case has been upgraded!")
    end
end