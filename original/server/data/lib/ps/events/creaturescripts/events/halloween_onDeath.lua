local REQUIRED_DAMAGE_RATIO = 0.1 -- 10%

local LOOTS = {
    ["Halloween Gastly"] = {
        {itemid = 14461, countmax = 2, unique = true}, -- Halloween Token
    },
    ["Halloween Haunter"] = {
        {itemid = 14461, countmax = 4, unique = true}, -- Halloween Token
    },
    ["Halloween Gengar"] = {
        {itemid = 14461, countmax = 6, unique = true}, -- Halloween Token
    },
    ["Dark Gengar"] = {
        {itemid = 14461, countmax = 18, unique = true}, -- Halloween Token
        {itemid = 18723, countmax = 1, unique = false, chance = 10000}, -- Gengar Backpack
        {chance = 25000, onReceive = function(cid)
            if (getCreatureStorage(cid, 8406) ~= QUEST_STATUS.STARTED) then -- We are at the quest?
                return
            end

            local LAST_RELIC_STORAGE = 8407
            local relics = {
                [-1] = 19092, -- suramoon cursed broom
                [0] = 19093, -- suramoon cursed amulet
                [1] = 19094, -- suramoon cursed book
                [2] = 19095, -- suramoon cursed ankh
                [3] = 19096, -- suramoon cursed crystal ball
                [4] = 19097, -- suramoon cursed flute
                [5] = 19098 -- suramoon cursed watch
            }

            local r = relics[getCreatureStorage(cid, LAST_RELIC_STORAGE)]
            if (r) then
                doPlayerSafeAddItem(cid, r, 1, true, true)
                doCreatureSetStorage(cid, LAST_RELIC_STORAGE, getCreatureStorage(cid, LAST_RELIC_STORAGE) + 1)
            end

        end}, -- suramoon cursed broom
    },
}

function onDeath(cid, corpse, deathList)
    for _, killer in pairs(deathList) do
        if (isCreature(killer)) then
            killer = getCreatureMaster(killer)
            log(LOG_TYPES.INFO, "halloween_onDeath - Killer / Ratio", getCreatureName(cid), getCreatureDamageRatioByMaster(cid, killer))
            if (isPlayer(killer) and getCreatureDamageRatioByMaster(cid, killer) >= REQUIRED_DAMAGE_RATIO) then
                local loot = LOOTS[getCreatureNickname(cid)]
                if (loot) then
                    for k, v in pairs(loot) do
                        if (not v.chance or v.chance >= getRandom(1, 100000)) then
                            if (v.onReceive) then
                                v.onReceive(killer)
                            else
                                doPlayerSafeAddItem(killer, v.itemid, getRandom(1, v.countmax), true, v.unique)
                            end
                        end
                    end
                end
            end
        end
    end

    --[[local killer = getPlayerByGUID(getItemAttribute(corpse.uid, "corpseowner"))
    if (not killer) then
        killer = getCreatureMaster(deathList[1])
    end

    if (isPlayer(killer)) then
        local loot = LOOTS[getCreatureNickname(cid)]
        if (loot) then
            for k, v in pairs(loot) do
                if (not v.chance or v.chance >= getRandom(1, 100000)) then
                    if (v.onReceive) then
                        v.onReceive(killer)
                    else
                        doPlayerSafeAddItem(killer, v.itemid, getRandom(1, v.countmax), true, v.unique)
                    end
                end
            end
        end
    end]]

	return true
end
