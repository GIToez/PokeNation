function onUse(cid, item, fromPosition, itemEx, toPosition)
    doShowTextDialog(cid, item.itemid, "I know I did a bad thing for you, but, please, take me back.\nI will always remember you as a beautiful girl I spoke to was nice to hear.\nI'll be waiting in the square ever, in our time and in our day.\n\nCome my love!")
    doCreatureSetStorage(cid, 8344, QUEST_STATUS.FINISHED)
	return true
end
