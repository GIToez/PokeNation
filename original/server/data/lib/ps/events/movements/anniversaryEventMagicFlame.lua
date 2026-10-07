function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    AnniversaryEvent.onMagicFlameStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
end

function onStepOut(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    AnniversaryEvent.onMagicFlameStepOut(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    return true
end