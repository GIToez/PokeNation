local ON, OFF = 14809, 14810

local paths = {
    {
        [100] = {
            {{x = 3932, y = 668, z = 7}, ON}
        },
        [101] = {
            {{x = 3922, y = 660, z = 7}, ON},
            {{x = 3923, y = 657, z = 7}, ON},
            {{x = 3924, y = 656, z = 7}, OFF},
            {{x = 3926, y = 656, z = 7}, ON}
        },
        [102] = {
            {{x = 3931, y = 657, z = 6}, OFF},
            {{x = 3933, y = 662, z = 6}, ON},
        },
        [103] = {
            {{x = 3929, y = 665, z = 6}, OFF},
            {{x = 3927, y = 665, z = 6}, ON},
            {{x = 3924, y = 668, z = 6}, OFF},
            {{x = 3922, y = 666, z = 6}, ON},
            {{x = 3922, y = 665, z = 6}, OFF},
            {{x = 3922, y = 664, z = 6}, ON},
        },
        [104] = {
            {{x = 3933, y = 662, z = 8}, ON}
        },
        [105] = {
            {{x = 3930, y = 656, z = 5}, ON},
            {{x = 3931, y = 657, z = 5}, ON},
            {{x = 3932, y = 656, z = 5}, OFF},
            {{x = 3933, y = 656, z = 5}, ON},
            {{x = 3934, y = 657, z = 5}, ON},
            {{x = 3935, y = 656, z = 5}, ON},
        }
    },
    {
        [100] = {
            {{x = 3932, y = 668, z = 7}, ON}
        },
        [101] = {
            {{x = 3922, y = 660, z = 7}, OFF},
            {{x = 3923, y = 657, z = 7}, OFF},
            {{x = 3924, y = 656, z = 7}, OFF},
            {{x = 3926, y = 656, z = 7}, ON}
        },
        [102] = {
            {{x = 3931, y = 657, z = 6}, ON},
            {{x = 3933, y = 662, z = 6}, ON},
        },
        [103] = {
            {{x = 3929, y = 665, z = 6}, ON},
            {{x = 3927, y = 665, z = 6}, ON},
            {{x = 3924, y = 668, z = 6}, OFF},
            {{x = 3922, y = 666, z = 6}, OFF},
            {{x = 3922, y = 665, z = 6}, OFF},
            {{x = 3922, y = 664, z = 6}, ON},
        },
        [104] = {
            {{x = 3933, y = 662, z = 8}, ON}
        },
        [105] = {
            {{x = 3930, y = 656, z = 5}, ON},
            {{x = 3931, y = 657, z = 5}, OFF},
            {{x = 3932, y = 656, z = 5}, OFF},
            {{x = 3933, y = 656, z = 5}, OFF},
            {{x = 3934, y = 657, z = 5}, ON},
            {{x = 3935, y = 656, z = 5}, ON},
        }
    },
    {
        [100] = {
            {{x = 3932, y = 668, z = 7}, ON}
        },
        [101] = {
            {{x = 3922, y = 660, z = 7}, OFF},
            {{x = 3923, y = 657, z = 7}, OFF},
            {{x = 3924, y = 656, z = 7}, OFF},
            {{x = 3926, y = 656, z = 7}, ON}
        },
        [102] = {
            {{x = 3931, y = 657, z = 6}, ON},
            {{x = 3933, y = 662, z = 6}, OFF},
        },
        [103] = {
            {{x = 3929, y = 665, z = 6}, ON},
            {{x = 3927, y = 665, z = 6}, ON},
            {{x = 3924, y = 668, z = 6}, ON},
            {{x = 3922, y = 666, z = 6}, ON},
            {{x = 3922, y = 665, z = 6}, OFF},
            {{x = 3922, y = 664, z = 6}, ON},
        },
        [104] = {
            {{x = 3933, y = 662, z = 8}, ON}
        },
        [105] = {
            {{x = 3930, y = 656, z = 5}, ON},
            {{x = 3931, y = 657, z = 5}, OFF},
            {{x = 3932, y = 656, z = 5}, OFF},
            {{x = 3933, y = 656, z = 5}, ON},
            {{x = 3934, y = 657, z = 5}, ON},
            {{x = 3935, y = 656, z = 5}, OFF},
        }
    },
    {
        [100] = {
            {{x = 3932, y = 668, z = 7}, ON}
        },
        [101] = {
            {{x = 3922, y = 660, z = 7}, ON},
            {{x = 3923, y = 657, z = 7}, OFF},
            {{x = 3924, y = 656, z = 7}, OFF},
            {{x = 3926, y = 656, z = 7}, ON}
        },
        [102] = {
            {{x = 3931, y = 657, z = 6}, ON},
            {{x = 3933, y = 662, z = 6}, ON},
        },
        [103] = {
            {{x = 3929, y = 665, z = 6}, ON},
            {{x = 3927, y = 665, z = 6}, ON},
            {{x = 3924, y = 668, z = 6}, ON},
            {{x = 3922, y = 666, z = 6}, ON},
            {{x = 3922, y = 665, z = 6}, OFF},
            {{x = 3922, y = 664, z = 6}, ON},
        },
        [104] = {
            {{x = 3933, y = 662, z = 8}, ON}
        },
        [105] = {
            {{x = 3930, y = 656, z = 5}, ON},
            {{x = 3931, y = 657, z = 5}, OFF},
            {{x = 3932, y = 656, z = 5}, OFF},
            {{x = 3933, y = 656, z = 5}, ON},
            {{x = 3934, y = 657, z = 5}, ON},
            {{x = 3935, y = 656, z = 5}, OFF},
        }
    }
}

local walls = {
    -- [actionid] = {{pos}, itemid}
    [100] = {{x = 3931, y = 667, z = 7}, 14812},
    [101] = {{x = 3929, y = 658, z = 7}, 14812},
    [102] = {{x = 3933, y = 667, z = 6}, 14812},
    [103] = {{x = 3924, y = 663, z = 6}, 14811},
    [104] = {{x = 3924, y = 661, z = 6}, 14811},
    [105] = {{x = 3932, y = 661, z = 5}, 14811},
}

local currentPath = {}
local function updatePath()
    currentPath = table.random(paths)
end

local function onWallThink(pos, itemid, ticks)
    if (ticks > 0) then
        doSendAnimatedText(pos, ticks, COLOR_RED)
        addEvent(onWallThink, 1000, pos, itemid, ticks - 1)
    else
        doCreateItem(itemid, 1, pos)
        doSendMagicEffect(pos, EFFECT_ELECTRIC_SPARK)
    end
end

local function checkPath(actionid)
    for _, k in pairs(currentPath[actionid]) do -- Check all box are correct
        if (not isItem(getTileItemById(k[1], k[2]))) then
            return
        end
    end
    -- Yes it is, lets reset all box and remove the wall temporarily
    for _, k in pairs(currentPath[actionid]) do
        doTransformItem(getTileItemById(k[1], k[2]).uid, OFF)
        doSendMagicEffect(k[1], EFFECT_POFF)
    end

    doRemoveItem(getTileItemById(walls[actionid][1], walls[actionid][2]).uid)
    onWallThink(walls[actionid][1], walls[actionid][2], 20)
    updatePath()
end

updatePath()

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (item.actionid < 100 or
            not isItem(getTileItemById(walls[item.actionid][1], walls[item.actionid][2]))) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendMagicEffect(toPosition, EFFECT_POFF)
    doTransformItem(item.uid, item.itemid == ON and OFF or ON)
    checkPath(item.actionid)
    return true
end
