local CLOTHES_KIT = {
    [13481] = { outfits = { 615, 616 }, addons = 0 }, -- Adventurer
    [13482] = { outfits = { 617, 618 }, addons = 0 }, -- Academy
    [13483] = { outfits = { 621, 622 }, addons = 0 }, -- Social
    [13484] = { outfits = { 623, 624 }, addons = 0 }, -- Jamaica
    [13485] = { outfits = { 625, 626 }, addons = 0 }, -- Punk
    [13486] = { outfits = { 627, 628 }, addons = 0 }, -- Fisher
    [13487] = { outfits = { 629, 630 }, addons = 0 }, -- Hiker
    [13488] = { outfits = { 631, 632 }, addons = 0 }, -- Mercenary
    [13489] = { outfits = { 633, 634 }, addons = 0 }, -- Rapper
    [13490] = { outfits = { 635, 636 }, addons = 0 }, -- Oriental
    [18717] = { outfits = { 1184, 1185 }, addons = 0 }, -- Catcher
    [18719] = { outfits = { 886, 887 }, addons = 0 }, -- Halloween #1 (skull / frankenstein)
    [18720] = { outfits = { 888, 889 }, addons = 0 }, -- Halloween #2 (witch / mummy)
    [18721] = { outfits = { 1213, 1214 }, addons = 0 }, -- Halloween #3 (naughty devil / skeleton)
    [18722] = { outfits = { 1215, 1216 }, addons = 0 }, -- Halloween #4 (dark witch / vampire)
    [18748] = { outfits = { 891, 892 }, addons = 0 }, -- Christmas #1
    [18749] = { outfits = { 893, 894 }, addons = 0 }, -- Christmas #2
    [18750] = { outfits = { 1223, 1224 }, addons = 0 }, -- Christmas #3
    [18851] = { outfits = { 1251, 1252 }, addons = 0 }, -- Christmas #3
    [18911] = { outfits = { 1180, 1181 }, addons = 0 }, -- Researcher
    [28165] = { outfits = { 1294, 1294 }, addons = 0 }, -- Phantomaniac Kit (Halloween)
    [19091] = { outfits = { 1295, 1296 }, addons = 0 }, -- Halloween #5 (halloween monster)
    [24715] = { outfits = { 1322, 1321 }, addons = 0 }, -- Halloween #5 (halloween monster)
    [25071] = { outfits = { 617, 618 }, addons = 1 }, -- academy addon #1 kit
    [25072] = { outfits = { 617, 618 }, addons = 2 }, -- academy addon #2 kit
    [25073] = { outfits = { 615, 616 }, addons = 1 }, -- adventurer addon #1 kit
    [25074] = { outfits = { 615, 616 }, addons = 2 }, -- adventurer addon #2 kit
    [25075] = { outfits = { 613, 614 }, addons = 1 }, -- elite trainer addon #1 kit
    [25076] = { outfits = { 613, 614 }, addons = 2 }, -- elite trainer addon #2 kit
    [25077] = { outfits = { 629, 630 }, addons = 1 }, -- hiker addon #1 kit
    [25078] = { outfits = { 629, 630 }, addons = 2 }, -- hiker addon #2 kit
    [25079] = { outfits = { 623, 624 }, addons = 1 }, -- jamaica addon #1 kit
    [25080] = { outfits = { 623, 624 }, addons = 2 }, -- jamaica addon #2 kit
    [25081] = { outfits = { 631, 632 }, addons = 1 }, -- mercenary addon #1 kit
    [25082] = { outfits = { 631, 632 }, addons = 2 }, -- mercenary addon #2 kit
    [25083] = { outfits = { 633, 634 }, addons = 1 }, -- rapper addon #1 kit
    [25084] = { outfits = { 633, 634 }, addons = 2 }, -- rapper addon #2 kit
    [25157] = { outfits = { 1388, 1389 }, addons = 0 }, -- Halloween #6 kit
    [25158] = { outfits = { 1390, 1391 }, addons = 0 }, -- Halloween #7 kit
    [25316] = { outfits = { 1428, 1428 }, addons = 0 }, -- Elfin kit
    [25317] = { outfits = { 1405, 1405 }, addons = 0 }, -- Helper Grinch kit
    [29864] = { outfits = { 1132, 1138 }, addons = 0, canWear = function(cid) return getPlayerMastery(cid) == MASTERYID_BLAZE end }, -- ultimate blaze clothes kit
    [29865] = { outfits = { 1131, 1139 }, addons = 0, canWear = function(cid) return getPlayerMastery(cid) == MASTERYID_HURRICANE end }, -- ultimate hurricane clothes kit
    [29866] = { outfits = { 1128, 1143 }, addons = 0, canWear = function(cid) return getPlayerMastery(cid) == MASTERYID_VOLTAGIC end }, -- ultimate voltagic clothes kit
    [29867] = { outfits = { 1135, 1136 }, addons = 0, canWear = function(cid) return getPlayerMastery(cid) == MASTERYID_SPECTRUM end }, -- ultimate spectrum clothes kit
    [29868] = { outfits = { 2538, 1137 }, addons = 0, canWear = function(cid) return getPlayerMastery(cid) == MASTERYID_VITAL end }, -- ultimate vital clothes kit
    [29869] = { outfits = { 1130, 1140 }, addons = 0, canWear = function(cid) return getPlayerMastery(cid) == MASTERYID_GAIA end }, -- ultimate gaia clothes kit
    [29870] = { outfits = { 1129, 1144 }, addons = 0, canWear = function(cid) return getPlayerMastery(cid) == MASTERYID_AVALANCHE end }, -- ultimate avalanche clothes kit
    [29871] = { outfits = { 1134, 1142 }, addons = 0, canWear = function(cid) return getPlayerMastery(cid) == MASTERYID_HEREMIT end }, -- ultimate heremit clothes kit
    [29872] = { outfits = { 1133, 1141 }, addons = 0, canWear = function(cid) return getPlayerMastery(cid) == MASTERYID_ZEN end }, -- ultimate zen clothes kit
    [29885] = { outfits = { 2560, 2554 }, addons = 0 }, -- azurill/blastoise costume
    [29886] = { outfits = { 2553, 2548 }, addons = 0 }, -- azurill/blastoise costume
}

function onUse(cid, item)
    local alreadyGot = false
    for _, cloth in pairs(CLOTHES_KIT[item.itemid].outfits) do
        if (canPlayerWearOutfit(cid, cloth, CLOTHES_KIT[item.itemid].addons)) then
            alreadyGot = true
            break
        end
    end

    if (alreadyGot) then
        doPlayerSendCancel(cid, "You already own this outfit.")
        return true
    end

    if (CLOTHES_KIT[item.itemid].canWear and not CLOTHES_KIT[item.itemid].canWear(cid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    for _, cloth in pairs(CLOTHES_KIT[item.itemid].outfits) do
        doPlayerAddOutfit(cid, cloth, CLOTHES_KIT[item.itemid].addons)
    end

    doPlayerSendOutfitWindow(cid)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! You got a new outfit.")
    doRemoveItem(item.uid)

    return true
end
