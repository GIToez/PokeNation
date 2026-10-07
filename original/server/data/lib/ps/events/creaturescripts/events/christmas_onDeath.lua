local LOOTS = {
    ["Rocket Bot"] = {
        {itemid = 14632, countmax = 3, unique = true}, -- Christmas Token
    },
    ["Runaway Stantler"] = {
        {itemid = 14632, countmax = 5, unique = true}, -- Christmas Token
        {itemid = 14633, countmax = 1, unique = true, chance = 10000,
            pickStorage = playersStorages.pickedStoneOfKnowledge, pickMax = 50}, -- Stone of Knowledge
        {itemid = 14640, countmax = 1, unique = false, chance = 15000}, -- Santa Claus Present #2
    },
    ["Evil Rocket Bot"] = {
        {itemid = 14632, countmax = 20, unique = true}, -- Christmas Token
        {itemid = 6512, countmax = 1, unique = false, chance = 10000}, -- Santa Doll
        {itemid = 14644, countmax = 1, unique = false, chance = 10000}, -- Santa Teddy
    },
    ["Team Rocket"] = {
        {itemid = 14632, countmax = 20, unique = true}, -- Christmas Token
        {itemid = 11257, countmax = 1, unique = false, chance = 10000}, -- Santa Backpack
    },
}

local ON_DEATH = {}
ON_DEATH["Team Rocket"] = function(killer, pos)
    doSendMagicEffect(pos, EFFECT_YELLOW_TELEPORT_STAR)
    doSendDistanceShoot(pos, getSkyPosition(pos), PROJECTILE_STARS)
    doPlayerAchievementCheck(killer, ACHIEVEMENT_IDS.DEFEAT_TEAM_ROCKET_TRIO)
end

ON_DEATH["Rocket Bot"] = function(killer, pos)
    doSendMagicEffect(pos, EFFECT_EXPLOSION_TWO)
end

ON_DEATH["Evil Rocket Bot"] = function(killer, pos)
    for i = 0, 10 do
        addEvent(doSendMagicEffect, (i * 100), getPositionRandomAdjacent(pos, 2), EFFECT_EXPLOSION_TWO)
    end
    doPlayerAchievementCheck(killer, ACHIEVEMENT_IDS.DEFEAT_TEAM_ROCKET_EVIL_BOT)
end

function onDeath(cid, corpse, deathList)
    local killer = getPlayerByGUID(getItemAttribute(corpse.uid, "corpseowner"))
    if (not killer) then
        killer = getCreatureMaster(deathList[1])
    end

    if (isPlayer(killer)) then
        local loot = LOOTS[getCreatureNickname(cid)]
        if (loot) then
            for k, v in pairs(loot) do
                if ((not v.chance or v.chance >= getRandom(1, 100000)) and
                        (not v.pickStorage or getCreatureStorage(killer, v.pickStorage) < v.pickMax)) then
                    local count = getRandom(1, v.countmax)
                    doPlayerSafeAddItem(killer, v.itemid, count, true, v.unique)

                    if (v.pickStorage) then
                        local picked = getCreatureStorage(killer, v.pickStorage)
                        if (picked < 0) then
                            picked = 0
                        end

                        doCreatureSetStorage(killer, v.pickStorage, picked + count)
                    end
                end
            end
        end
    end

    if (ON_DEATH[getCreatureNickname(cid)]) then
        ON_DEATH[getCreatureNickname(cid)](killer, getThingPosition(cid))
    end

	return true
end
