local QUEST_STORAGE = 8433
local ITEM_STORAGE = 8434

local NPC_ANIMATION = {
    [533] = 1330,
    [1330] = 1331,
    [1331] = 1332,
    [1332] = 1333,
    [1333] = 1334,
    [1334] = 1335,
    [1335] = 1336,
    [1336] = 1337,
    [1337] = 1338,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (getCreatureStorage(cid, QUEST_STORAGE) ~= QUEST_STATUS.FINISHED or
            getCreatureStorage(cid, ITEM_STORAGE) ~= QUEST_STATUS.UNSTARTED) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
    doSendMagicEffect(toPosition, EFFECT_EMOTION_EXCLAMATION)
    doCreatureSetStorage(cid, ITEM_STORAGE, QUEST_STATUS.FINISHED)
    doSendMagicEffect(getCreaturePosition(getCreatureByName("Captain Neil Pace")), EFFECT_EMOTION_EXCLAMATION)

    local npc = doCreateNpc("Rocket Curt Denny", {x = 3856, y = 638, z = 5}, false)
    doCreatureSay(npc, __L(cid, "HAHAHAHAHA, you never come out with this boat again. Give me this key and keep quiet!"))
    local doAnim
    doAnim = function(npc)
        local out = getCreatureOutfit(npc)
        if (NPC_ANIMATION[out.lookType]) then
            out.lookType = NPC_ANIMATION[out.lookType]
            doCreatureChangeOutfit(npc, out)
            addEvent(doAnim, 250, npc)
        else
            doSendMagicEffect(getCreaturePosition(npc), EFFECT_TELEPORT_UP)
            doRemoveCreature(npc)
        end
    end
    doAnim(npc)

    return true
end
