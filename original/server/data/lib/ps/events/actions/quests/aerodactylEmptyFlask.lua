local FLASK_OF_OIL_ITEMID = 18762
local BUCKET_OF_OIL_ITEMID = 18764
local BUCKET_OF_OIL_ACTIONID = 100

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx) or itemEx.itemid ~= BUCKET_OF_OIL_ITEMID or itemEx.actionid ~= BUCKET_OF_OIL_ACTIONID) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(fromPosition, EFFECT_POISON_GAS)
    doTransformItem(item.uid, FLASK_OF_OIL_ITEMID)
    return true
end
