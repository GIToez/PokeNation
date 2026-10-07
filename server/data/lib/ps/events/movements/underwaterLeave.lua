function onStepOut(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    return OxygenMask.onLeave(cid, item, position, lastPosition, fromPosition, toPosition, actor, item.itemid ~= 13291)
end
