local questStorage = 8555
local itemStorage = 8558

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (getCreatureStorage(cid, questStorage) ~= QUEST_STATUS.STARTED or
			getCreatureStorage(cid, itemStorage) == QUEST_STATUS.FINISHED) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	doPlayerSafeAddItem(cid, 25195, 1, true, true)
  doCreatureSetStorage(cid, itemStorage, QUEST_STATUS.FINISHED)
  doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The key was taken!")
  doRemoveItem(item.uid)
  doSendMagicEffect(fromPosition, EFFECT_TELEPORT_UP)

	return true
end
