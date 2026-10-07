local CLOTHES_FEMALE =	{615, 617, 621, 623, 625, 627, 629, 631, 633, 635}
local CLOTHES_MALE = {616, 618, 622, 624, 626, 628, 630, 632, 634, 636}

function onUse(cid, item)
    local out = getCreatureOutfit(cid)
	doSetCreatureOutfit(cid,
        {
            lookType = table.random((getPlayerSex(cid) == PLAYERSEX_FEMALE and CLOTHES_FEMALE or CLOTHES_MALE)),
            lookHead = out.lookHead,
            lookBody = out.lookBody,
            lookLegs = out.lookLegs,
            lookFeet = out.lookFeet
        }, 5000)
	return true
end
