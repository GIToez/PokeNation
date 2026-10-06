function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
	return OxygenMask.onEnter(cid, item, position, lastPosition, fromPosition, toPosition, actor, item.itemid ~= 8632)
end
