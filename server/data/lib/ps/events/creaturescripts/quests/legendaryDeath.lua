local CHEST_ITEMID = 18744

local CHEST_ATTR = 1000
local CHEST_VALUES = {}
CHEST_VALUES["Zapdos"] = 1
CHEST_VALUES["Moltres"] = 2
CHEST_VALUES["Articuno"] = 3

local EFFECTS = {}
EFFECTS["Zapdos"] = EFFECT_ZAPDOS_CRY
EFFECTS["Moltres"] = EFFECT_MOLTRES_CRY
EFFECTS["Articuno"] = EFFECT_ARTICUNO_CRY

function onPrepareDeath(cid, deathList)
    local player = getKillerFromList(deathList)
    if (isCreature(player) and not isPlayer(player)) then
        player = getCreatureMaster(player)
    end
    if (not isPlayer(player)) then
        log(LOG_TYPES.ERROR, "legendaryDeath - Unknown killer.", getCreatureName(cid), deathList)
        return true
    end

    local pos = getCreaturePosition(cid)

    doItemSetAttribute(doCreateItem(CHEST_ITEMID, 1, pos), CHEST_ATTR, CHEST_VALUES[getCreatureName(cid)])
    doSendMagicEffect(pos, EFFECTS[getCreatureName(cid)])
    addEvent(doSendMagicEffect, 2000, pos, EFFECT_TELEPORT_UP)
    doRemoveCreature(cid)
    doPlayerAchievementCheck(player, ACHIEVEMENT_IDS.LEGENDARY_BIRD_BATTLE)
    setPlayerBlockLogout(player, false)

    return false
end
