local coins = {
	[12100] = {
		to = 23502, effect = TEXTCOLOR_LIGHTBLUE
	},
	[23502] = {
        from = 12100, effect = TEXTCOLOR_LIGHTBLUE
	},

	[12101] = {
		to = 23498, effect = TEXTCOLOR_RED
	},
	[23498] = {
        from = 12101, effect = TEXTCOLOR_RED
	},

	[12102] = {
        to = 23501, effect = TEXTCOLOR_GREEN
	},
	[23501] = {
        from = 12102, effect = TEXTCOLOR_GREEN
	},

    [12103] = {
        to = 23499, effect = TEXTCOLOR_GREY
    },
    [23499] = {
        from = 12103, effect = TEXTCOLOR_GREY
    },

    [12104] = {
        to = 23500, effect = TEXTCOLOR_PURPLE
    },
    [23500] = {
        from = 12104, effect = TEXTCOLOR_PURPLE
    }
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (getPlayerFlagValue(cid, PLAYERFLAG_CANNOTPICKUPITEM)) then
		return false
	end

	local coin = coins[item.itemid]
	if(not coin) then
		return false
	end

	if(coin.to ~= nil and item.type == ITEMCOUNT_MAX) then
		doChangeTypeItem(item.uid, item.type - item.type)
		doPlayerAddItem(cid, coin.to, 1)
		doSendAnimatedText(fromPosition, "Puff", coins[coin.to].effect)
	elseif(coin.from ~= nil) then
		doChangeTypeItem(item.uid, item.type - 1)
		doPlayerAddItem(cid, coin.from, ITEMCOUNT_MAX)
		doSendAnimatedText(fromPosition, "Poff", coins[coin.from].effect)
	end
	return true
end
