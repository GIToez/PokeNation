local STONE_ITEMID_BY_COMBINATIONS = {
    [ELEMENT_NORMAL] = {
        [ELEMENT_NORMAL] = 24951,
        [ELEMENT_FIGHT] = 24944,
        [ELEMENT_FLYING] = 24946,
        [ELEMENT_POISON] = 24952,
        [ELEMENT_GROUND] = 24949,
        [ELEMENT_ROCK] = 24954,
        [ELEMENT_BUG] = 24939,
        [ELEMENT_GHOST] = 24947,
        [ELEMENT_STEEL] = 24955,
        [ELEMENT_FIRE] = 24945,
        [ELEMENT_WATER] = 24956,
        [ELEMENT_GRASS] = 24948,
        [ELEMENT_ELECTRIC] = 24942,
        [ELEMENT_PSYCHIC] = 24953,
        [ELEMENT_ICE] = 24950,
        [ELEMENT_DRAGON] = 24941,
        [ELEMENT_DARK] = 24940,
        [ELEMENT_FAIRY] = 24943,
    },
    [ELEMENT_FIGHT] = {
        [ELEMENT_NORMAL] = 24825,
        [ELEMENT_FIGHT] = 24818,
        [ELEMENT_FLYING] = 24820,
        [ELEMENT_POISON] = 24826,
        [ELEMENT_GROUND] = 24823,
        [ELEMENT_ROCK] = 24828,
        [ELEMENT_BUG] = 24813,
        [ELEMENT_GHOST] = 24821,
        [ELEMENT_STEEL] = 24829,
        [ELEMENT_FIRE] = 24819,
        [ELEMENT_WATER] = 24830,
        [ELEMENT_GRASS] = 24822,
        [ELEMENT_ELECTRIC] = 24816,
        [ELEMENT_PSYCHIC] = 24827,
        [ELEMENT_ICE] = 24824,
        [ELEMENT_DRAGON] = 24815,
        [ELEMENT_DARK] = 24814,
        [ELEMENT_FAIRY] = 24817,
    },
    [ELEMENT_FLYING] = {
        [ELEMENT_NORMAL] = 24861,
        [ELEMENT_FIGHT] = 24854,
        [ELEMENT_FLYING] = 24856,
        [ELEMENT_POISON] = 24862,
        [ELEMENT_GROUND] = 24859,
        [ELEMENT_ROCK] = 24864,
        [ELEMENT_BUG] = 24849,
        [ELEMENT_GHOST] = 24857,
        [ELEMENT_STEEL] = 24865,
        [ELEMENT_FIRE] = 24855,
        [ELEMENT_WATER] = 24866,
        [ELEMENT_GRASS] = 24858,
        [ELEMENT_ELECTRIC] = 24852,
        [ELEMENT_PSYCHIC] = 24863,
        [ELEMENT_ICE] = 24860,
        [ELEMENT_DRAGON] = 24851,
        [ELEMENT_DARK] = 24850,
        [ELEMENT_FAIRY] = 24853,
    },
    [ELEMENT_POISON] = {
        [ELEMENT_NORMAL] = 24969,
        [ELEMENT_FIGHT] = 24962,
        [ELEMENT_FLYING] = 24964,
        [ELEMENT_POISON] = 24970,
        [ELEMENT_GROUND] = 24967,
        [ELEMENT_ROCK] = 24972,
        [ELEMENT_BUG] = 24957,
        [ELEMENT_GHOST] = 24965,
        [ELEMENT_STEEL] = 24973,
        [ELEMENT_FIRE] = 24963,
        [ELEMENT_WATER] = 24974,
        [ELEMENT_GRASS] = 24966,
        [ELEMENT_ELECTRIC] = 24960,
        [ELEMENT_PSYCHIC] = 24971,
        [ELEMENT_ICE] = 24968,
        [ELEMENT_DRAGON] = 24959,
        [ELEMENT_DARK] = 24958,
        [ELEMENT_FAIRY] = 24961,
    },
    [ELEMENT_GROUND] = {
        [ELEMENT_NORMAL] = 24915,
        [ELEMENT_FIGHT] = 24908,
        [ELEMENT_FLYING] = 24910,
        [ELEMENT_POISON] = 24916,
        [ELEMENT_GROUND] = 24913,
        [ELEMENT_ROCK] = 24918,
        [ELEMENT_BUG] = 24903,
        [ELEMENT_GHOST] = 24911,
        [ELEMENT_STEEL] = 24919,
        [ELEMENT_FIRE] = 24909,
        [ELEMENT_WATER] = 24920,
        [ELEMENT_GRASS] = 24912,
        [ELEMENT_ELECTRIC] = 24906,
        [ELEMENT_PSYCHIC] = 24917,
        [ELEMENT_ICE] = 24914,
        [ELEMENT_DRAGON] = 24905,
        [ELEMENT_DARK] = 24904,
        [ELEMENT_FAIRY] = 24907,
    },
    --[[[ELEMENT_ROCK] = {
        [ELEMENT_NORMAL] = 25005,
        [ELEMENT_FIGHT] = 24998,
        [ELEMENT_FLYING] = 25000,
        [ELEMENT_POISON] = 25006,
        [ELEMENT_GROUND] = 25003,
        [ELEMENT_ROCK] = 25008,
        [ELEMENT_BUG] = 24993,
        [ELEMENT_GHOST] = 25001,
        [ELEMENT_STEEL] = 25009,
        [ELEMENT_FIRE] = 24999,
        [ELEMENT_WATER] = 25010,
        [ELEMENT_GRASS] = 25002,
        [ELEMENT_ELECTRIC] = 24996,
        [ELEMENT_PSYCHIC] = 25007,
        [ELEMENT_ICE] = 25004,
        [ELEMENT_DRAGON] = 24995,
        [ELEMENT_DARK] = 24994,
        [ELEMENT_FAIRY] = 24997,
    },]]
    [ELEMENT_ROCK] = {
        [ELEMENT_NORMAL] = 25006,
        [ELEMENT_FIGHT] = 24999,
        [ELEMENT_FLYING] = 25001,
        [ELEMENT_POISON] = 25007,
        [ELEMENT_GROUND] = 25004,
        [ELEMENT_ROCK] = 24993,
        [ELEMENT_BUG] = 24994,
        [ELEMENT_GHOST] = 25002,
        [ELEMENT_STEEL] = 25009,
        [ELEMENT_FIRE] = 25000,
        [ELEMENT_WATER] = 25010,
        [ELEMENT_GRASS] = 25003,
        [ELEMENT_ELECTRIC] = 24997,
        [ELEMENT_PSYCHIC] = 25008,
        [ELEMENT_ICE] = 25005,
        [ELEMENT_DRAGON] = 24996,
        [ELEMENT_DARK] = 24995,
        [ELEMENT_FAIRY] = 24998,
    },
    [ELEMENT_BUG] = {
        [ELEMENT_NORMAL] = 24736,
        [ELEMENT_FIGHT] = 24729,
        [ELEMENT_FLYING] = 24731,
        [ELEMENT_POISON] = 24737,
        [ELEMENT_GROUND] = 24734,
        [ELEMENT_ROCK] = 24739,
        [ELEMENT_BUG] = 24724,
        [ELEMENT_GHOST] = 24732,
        [ELEMENT_STEEL] = 24740,
        [ELEMENT_FIRE] = 24730,
        [ELEMENT_WATER] = 24741,
        [ELEMENT_GRASS] = 24733,
        [ELEMENT_ELECTRIC] = 24727,
        [ELEMENT_PSYCHIC] = 24738,
        [ELEMENT_ICE] = 24735,
        [ELEMENT_DRAGON] = 24726,
        [ELEMENT_DARK] = 24725,
        [ELEMENT_FAIRY] = 24728,
    },
    [ELEMENT_GHOST] = {
        [ELEMENT_NORMAL] = 24879,
        [ELEMENT_FIGHT] = 24872,
        [ELEMENT_FLYING] = 24874,
        [ELEMENT_POISON] = 24880,
        [ELEMENT_GROUND] = 24877,
        [ELEMENT_ROCK] = 24882,
        [ELEMENT_BUG] = 24867,
        [ELEMENT_GHOST] = 24875,
        [ELEMENT_STEEL] = 24883,
        [ELEMENT_FIRE] = 24873,
        [ELEMENT_WATER] = 24884,
        [ELEMENT_GRASS] = 24876,
        [ELEMENT_ELECTRIC] = 24870,
        [ELEMENT_PSYCHIC] = 24881,
        [ELEMENT_ICE] = 24878,
        [ELEMENT_DRAGON] = 24869,
        [ELEMENT_DARK] = 24868,
        [ELEMENT_FAIRY] = 24871,
    },
    --[[[ELEMENT_STEEL] = {
        [ELEMENT_NORMAL] = 25023,
        [ELEMENT_FIGHT] = 25016,
        [ELEMENT_FLYING] = 25018,
        [ELEMENT_POISON] = 25024,
        [ELEMENT_GROUND] = 25021,
        [ELEMENT_ROCK] = 25026,
        [ELEMENT_BUG] = 25011,
        [ELEMENT_GHOST] = 25019,
        [ELEMENT_STEEL] = 25027,
        [ELEMENT_FIRE] = 25017,
        [ELEMENT_WATER] = 25028,
        [ELEMENT_GRASS] = 25020,
        [ELEMENT_ELECTRIC] = 25014,
        [ELEMENT_PSYCHIC] = 25025,
        [ELEMENT_ICE] = 25022,
        [ELEMENT_DRAGON] = 25013,
        [ELEMENT_DARK] = 25012,
        [ELEMENT_FAIRY] = 25015,
    },]]
    [ELEMENT_STEEL] = {
        [ELEMENT_NORMAL] = 25024,
        [ELEMENT_FIGHT] = 25017,
        [ELEMENT_FLYING] = 25019,
        [ELEMENT_POISON] = 25025,
        [ELEMENT_GROUND] = 25022,
        [ELEMENT_ROCK] = 25027,
        [ELEMENT_BUG] = 25012,
        [ELEMENT_GHOST] = 25020,
        [ELEMENT_STEEL] = 25011,
        [ELEMENT_FIRE] = 25018,
        [ELEMENT_WATER] = 25028,
        [ELEMENT_GRASS] = 25021,
        [ELEMENT_ELECTRIC] = 25015,
        [ELEMENT_PSYCHIC] = 25026,
        [ELEMENT_ICE] = 25023,
        [ELEMENT_DRAGON] = 25014,
        [ELEMENT_DARK] = 25013,
        [ELEMENT_FAIRY] = 25016,
    },
    [ELEMENT_FIRE] = {
        [ELEMENT_NORMAL] = 24843,
        [ELEMENT_FIGHT] = 24836,
        [ELEMENT_FLYING] = 24838,
        [ELEMENT_POISON] = 24844,
        [ELEMENT_GROUND] = 24841,
        [ELEMENT_ROCK] = 24846,
        [ELEMENT_BUG] = 24831,
        [ELEMENT_GHOST] = 24839,
        [ELEMENT_STEEL] = 24847,
        [ELEMENT_FIRE] = 24837,
        [ELEMENT_WATER] = 24848,
        [ELEMENT_GRASS] = 24840,
        [ELEMENT_ELECTRIC] = 24834,
        [ELEMENT_PSYCHIC] = 24845,
        [ELEMENT_ICE] = 24842,
        [ELEMENT_DRAGON] = 24833,
        [ELEMENT_DARK] = 24832,
        [ELEMENT_FAIRY] = 24835,
    },
    [ELEMENT_WATER] = {
        [ELEMENT_NORMAL] = 25041,
        [ELEMENT_FIGHT] = 25034,
        [ELEMENT_FLYING] = 25036,
        [ELEMENT_POISON] = 25042,
        [ELEMENT_GROUND] = 25039,
        [ELEMENT_ROCK] = 25044,
        [ELEMENT_BUG] = 25029,
        [ELEMENT_GHOST] = 25037,
        [ELEMENT_STEEL] = 25045,
        [ELEMENT_FIRE] = 25035,
        [ELEMENT_WATER] = 25046,
        [ELEMENT_GRASS] = 25038,
        [ELEMENT_ELECTRIC] = 25032,
        [ELEMENT_PSYCHIC] = 25043,
        [ELEMENT_ICE] = 25040,
        [ELEMENT_DRAGON] = 25031,
        [ELEMENT_DARK] = 25030,
        [ELEMENT_FAIRY] = 25033,
    },
    [ELEMENT_GRASS] = {
        [ELEMENT_NORMAL] = 24897,
        [ELEMENT_FIGHT] = 24890,
        [ELEMENT_FLYING] = 24892,
        [ELEMENT_POISON] = 24898,
        [ELEMENT_GROUND] = 24895,
        [ELEMENT_ROCK] = 24900,
        [ELEMENT_BUG] = 24885,
        [ELEMENT_GHOST] = 24893,
        [ELEMENT_STEEL] = 24901,
        [ELEMENT_FIRE] = 24891,
        [ELEMENT_WATER] = 24902,
        [ELEMENT_GRASS] = 24894,
        [ELEMENT_ELECTRIC] = 24888,
        [ELEMENT_PSYCHIC] = 24899,
        [ELEMENT_ICE] = 24896,
        [ELEMENT_DRAGON] = 24887,
        [ELEMENT_DARK] = 24886,
        [ELEMENT_FAIRY] = 24889,
    },
    [ELEMENT_ELECTRIC] = {
        [ELEMENT_NORMAL] = 24789,
        [ELEMENT_FIGHT] = 24782,
        [ELEMENT_FLYING] = 24784,
        [ELEMENT_POISON] = 24790,
        [ELEMENT_GROUND] = 24787,
        [ELEMENT_ROCK] = 24792,
        [ELEMENT_BUG] = 24777,
        [ELEMENT_GHOST] = 24785,
        [ELEMENT_STEEL] = 24793,
        [ELEMENT_FIRE] = 24783,
        [ELEMENT_WATER] = 24794,
        [ELEMENT_GRASS] = 24786,
        [ELEMENT_ELECTRIC] = 24780,
        [ELEMENT_PSYCHIC] = 24791,
        [ELEMENT_ICE] = 24788,
        [ELEMENT_DRAGON] = 24779,
        [ELEMENT_DARK] = 24778,
        [ELEMENT_FAIRY] = 24781,
    },
    [ELEMENT_PSYCHIC] = {
        [ELEMENT_NORMAL] = 24987,
        [ELEMENT_FIGHT] = 24980,
        [ELEMENT_FLYING] = 24982,
        [ELEMENT_POISON] = 24988,
        [ELEMENT_GROUND] = 24985,
        [ELEMENT_ROCK] = 24990,
        [ELEMENT_BUG] = 24975,
        [ELEMENT_GHOST] = 24983,
        [ELEMENT_STEEL] = 24991,
        [ELEMENT_FIRE] = 24981,
        [ELEMENT_WATER] = 24992,
        [ELEMENT_GRASS] = 24984,
        [ELEMENT_ELECTRIC] = 24978,
        [ELEMENT_PSYCHIC] = 24989,
        [ELEMENT_ICE] = 24986,
        [ELEMENT_DRAGON] = 24977,
        [ELEMENT_DARK] = 24976,
        [ELEMENT_FAIRY] = 24979,
    },
    [ELEMENT_ICE] = {
        [ELEMENT_NORMAL] = 24933,
        [ELEMENT_FIGHT] = 24926,
        [ELEMENT_FLYING] = 24928,
        [ELEMENT_POISON] = 24934,
        [ELEMENT_GROUND] = 24931,
        [ELEMENT_ROCK] = 24936,
        [ELEMENT_BUG] = 24921,
        [ELEMENT_GHOST] = 24929,
        [ELEMENT_STEEL] = 24937,
        [ELEMENT_FIRE] = 24927,
        [ELEMENT_WATER] = 24938,
        [ELEMENT_GRASS] = 24930,
        [ELEMENT_ELECTRIC] = 24924,
        [ELEMENT_PSYCHIC] = 24935,
        [ELEMENT_ICE] = 24932,
        [ELEMENT_DRAGON] = 24923,
        [ELEMENT_DARK] = 24922,
        [ELEMENT_FAIRY] = 24925,
    },
    [ELEMENT_DRAGON] = {
        [ELEMENT_NORMAL] = 24771,
        [ELEMENT_FIGHT] = 24764,
        [ELEMENT_FLYING] = 24766,
        [ELEMENT_POISON] = 24772,
        [ELEMENT_GROUND] = 24769,
        [ELEMENT_ROCK] = 24774,
        [ELEMENT_BUG] = 24759,
        [ELEMENT_GHOST] = 24767,
        [ELEMENT_STEEL] = 24775,
        [ELEMENT_FIRE] = 24765,
        [ELEMENT_WATER] = 24776,
        [ELEMENT_GRASS] = 24768,
        [ELEMENT_ELECTRIC] = 24762,
        [ELEMENT_PSYCHIC] = 24773,
        [ELEMENT_ICE] = 24770,
        [ELEMENT_DRAGON] = 24761,
        [ELEMENT_DARK] = 24760,
        [ELEMENT_FAIRY] = 24763,
    },
    [ELEMENT_DARK] = {
        [ELEMENT_NORMAL] = 24753,
        [ELEMENT_FIGHT] = 24747,
        [ELEMENT_FLYING] = 24748,
        [ELEMENT_POISON] = 24754,
        [ELEMENT_GROUND] = 24751,
        [ELEMENT_ROCK] = 24756,
        [ELEMENT_BUG] = 24742,
        [ELEMENT_GHOST] = 24749,
        [ELEMENT_STEEL] = 24757,
        [ELEMENT_FIRE] = 25047,
        [ELEMENT_WATER] = 24758,
        [ELEMENT_GRASS] = 24750,
        [ELEMENT_ELECTRIC] = 24745,
        [ELEMENT_PSYCHIC] = 24755,
        [ELEMENT_ICE] = 24752,
        [ELEMENT_DRAGON] = 24744,
        [ELEMENT_DARK] = 24743,
        [ELEMENT_FAIRY] = 24746,
    },
    [ELEMENT_FAIRY] = {
        [ELEMENT_NORMAL] = 24807,
        [ELEMENT_FIGHT] = 24800,
        [ELEMENT_FLYING] = 24802,
        [ELEMENT_POISON] = 24808,
        [ELEMENT_GROUND] = 24805,
        [ELEMENT_ROCK] = 24810,
        [ELEMENT_BUG] = 24795,
        [ELEMENT_GHOST] = 24803,
        [ELEMENT_STEEL] = 24811,
        [ELEMENT_FIRE] = 24801,
        [ELEMENT_WATER] = 24812,
        [ELEMENT_GRASS] = 24804,
        [ELEMENT_ELECTRIC] = 24798,
        [ELEMENT_PSYCHIC] = 24809,
        [ELEMENT_ICE] = 24806,
        [ELEMENT_DRAGON] = 24797,
        [ELEMENT_DARK] = 24796,
        [ELEMENT_FAIRY] = 24799,
    },
}

local function getStoneItemIdByCombinations(slot1, slot2)
    if (slot2) then
        return STONE_ITEMID_BY_COMBINATIONS[slot1][slot2]
    end
    return STONE_ITEMID_BY_COMBINATIONS[slot1][slot1]
end

local function doUpdateStoneDescription(uid, slot1, slot2)
    doItemSetSpecialDescription(uid, string.format("This stone has been charged up with %s%s element(s).",
        ELEMENT_NAMES[slot1], (slot2 and string.format(" and %s", ELEMENT_NAMES[slot2]) or "")))
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    if (isBallWithPokemon(itemEx.uid)) then
        PokemonHeldItem.onUse(cid, item, fromPosition, itemEx, toPosition)
        return true
    end

    -- check if its a plate
    if (not TYPE_BY_PLATE_ITEMID[itemEx.itemid]) then
        doPlayerSendCancel(cid, "You must use it on a plate.")
        return true
    end

    -- check if there is available slot
    local destinationSlot = nil
    -- try slot 1
    local slot1 = getItemAttribute(item.uid, ITEM_ATTRIBUTES.ELEMENTAL_STONE_SLOT1)
    if (slot1 and TYPE_BY_PLATE_ITEMID[itemEx.itemid] == slot1) then
        doPlayerSendCancel(cid, "This stone already have this element.")
        return true

    elseif (not slot1) then
        destinationSlot = ITEM_ATTRIBUTES.ELEMENTAL_STONE_SLOT1
    end
    -- try slot 2
    local slot2 = getItemAttribute(item.uid, ITEM_ATTRIBUTES.ELEMENTAL_STONE_SLOT2)
    if (slot2 and TYPE_BY_PLATE_ITEMID[itemEx.itemid] == slot2) then
        doPlayerSendCancel(cid, "This stone already have this element.")
        return true

    elseif (not destinationSlot and not slot2) then
        destinationSlot = ITEM_ATTRIBUTES.ELEMENTAL_STONE_SLOT2
    end

    if (not destinationSlot) then
        doPlayerSendCancel(cid, "Your stone is full.")
        return true
    end

    -- register the element
    doItemSetAttribute(item.uid, destinationSlot, TYPE_BY_PLATE_ITEMID[itemEx.itemid])
    -- remove the plate
    doRemoveItem(itemEx.uid, 1)

    -- update the sprite/item
    slot1 = getItemAttribute(item.uid, ITEM_ATTRIBUTES.ELEMENTAL_STONE_SLOT1)
    slot2 = getItemAttribute(item.uid, ITEM_ATTRIBUTES.ELEMENTAL_STONE_SLOT2)
    doTransformItem(item.uid, getStoneItemIdByCombinations(slot1, slot2))

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format("Your stone received the %s element.",
        ELEMENT_NAMES[TYPE_BY_PLATE_ITEMID[itemEx.itemid]]))
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_BLUE)
    doUpdateStoneDescription(item.uid, slot1, slot2)

    return true
end
