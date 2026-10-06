local ITEMS = {
    [14750] = { -- Slingshot
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid) and getPlayerPokemon(cid) ~= itemEx.uid and canDoCombat(cid, itemEx.uid)) then
                doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_CONFUSION, nil, cid)
                doTargetCombatHealth(cid, itemEx.uid, COMBAT_DEATHDAMAGE, -50, -100, EFFECT_CONFUSE_STARS)
                doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_SMALL_STONE)
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },
    [14751] = { -- Pot of Fire
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid) and getPlayerPokemon(cid) ~= itemEx.uid and canDoCombat(cid, itemEx.uid)) then
                doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_FIRE)
                doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_BURN, getPlayerLevel(cid), cid)
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },
    --[[[14752] = { -- Map Warp TODO
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (cid = itemEx.uid) then
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },]]
    --[[[14753] = { -- Trap TODO
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid) and canDoCombat(cid, itemEx.uid)) then
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },]]
    [14754] = { -- Rope
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid) and getPlayerPokemon(cid) ~= itemEx.uid and canDoCombat(cid, itemEx.uid)) then
                doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
                doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_PARALYSIS, true, cid)
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },
    [14755] = { -- Awaken Flute
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid) and getPlayerPokemon(cid) == itemEx.uid and getCreatureStatus(itemEx.uid, CREATURE_STATUS_SLEEP)) then
                doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
                doCreatureRemoveStatus(itemEx.uid, CREATURE_STATUS_SLEEP)
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },
    [14756] = { -- Magic Lamp
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid) and getPlayerPokemon(cid) == itemEx.uid and hasTarget(cid)) then
                callSkillFunction(itemEx.uid, "Metronome")
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },
    [14757] = { -- Mirror
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid) and getPlayerPokemon(cid) == itemEx.uid) then
                doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
                doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_REFLECT, nil, cid)
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },
    [14758] = { -- Golden Rope
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isCreature(itemEx.uid) and getPlayerPokemon(cid) ~= itemEx.uid and canDoCombat(cid, itemEx.uid)) then
                doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
                doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_PARALYSIS, true, cid)
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },
    [14759] = { -- Poison Potion
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid) and getPlayerPokemon(cid) ~= itemEx.uid and canDoCombat(cid, itemEx.uid)) then
                doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_POISON)
                doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_POISON, getPlayerLevel(cid), cid)
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },
    [14760] = { -- Time Watch
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid)) then
                doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_GRAVEL)
                if (getPlayerPokemon(cid) == itemEx.uid) then
                    doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_EXTRASPEED, nil, cid)
                    doRemoveItem(item.uid, 1)

                elseif (canDoCombat(cid, itemEx.uid)) then
                    doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_EXTRASPEED, CREATURE_STATUS_VAR_BADMEDIUM, cid)
                    doRemoveItem(item.uid, 1)
                end

            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end

        end
    },
    [14761] = { -- Energy Potion
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid) and getPlayerPokemon(cid) == itemEx.uid) then
                doPlayerAddMana(cid, getRandom(200, 400))
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },
    [14762] = { -- Attack Booster
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid) and getPlayerPokemon(cid) == itemEx.uid) then
                doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_VAR_HIGH, cid)
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },
    [14763] = { -- Speed Booster
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid) and getPlayerPokemon(cid) == itemEx.uid) then
                doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_EXTRASPEED, nil, cid)
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },
    [14764] = { -- Paralyze Potion
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid) and getPlayerPokemon(cid) ~= itemEx.uid and canDoCombat(cid, itemEx.uid)) then
                doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_THUNDER)
                doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_PARALYSIS, true, cid)
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },
    [14765] = { -- Bad Poison Potion
        onUse = function(cid, item, fromPosition, itemEx, toPosition)
            if (isMonster(itemEx.uid) and getPlayerPokemon(cid) ~= itemEx.uid and canDoCombat(cid, itemEx.uid)) then
                doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_POISON)
                doCreatureAddStatus(itemEx.uid, CREATURE_STATUS_BADPOISON, getPlayerLevel(cid), cid)
                doRemoveItem(item.uid, 1)
            else
                doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
            end
        end
    },
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not ITEMS[item.itemid]) then
        log(LOG_TYPES.ERROR, "pvpItems onUse - Unknown Item", cid, item, fromPosition, itemEx, toPosition)
        return true
    end

    if (not getPlayerPvpArena(cid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    elseif (getDistanceBetween(getCreaturePosition(cid), toPosition) > 3) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
    else
        ITEMS[item.itemid].onUse(cid, item, getCreaturePosition(cid), itemEx, toPosition)
    end

    return true
end
