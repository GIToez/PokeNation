local ITEMS = {
    [18945] = {
        { itemId = 17940 }, -- Eevee
        { itemId = 17941 }, -- Vaporeon
        { itemId = 17942 }, -- Jolteon
        { itemId = 17943 }, -- Flareon
        { itemId = 17944 }, -- Porygon
        { itemId = 17945 }, -- Omastar
        { itemId = 17946 }, -- Kabutops
        { itemId = 17947 }, -- Aerodactyl
        { itemId = 17949 }, -- Dratini
        { itemId = 17930 }, -- Mr. Mime
        { itemId = 17931 }, -- Scyther
        { itemId = 17931 }, -- Scyther
        { itemId = 17996 }, -- Espeon
        { itemId = 17997 }, -- Umbreon
        { itemId = 18011 }, -- Scizor
        { itemId = 18032 }, -- Porygon2
        { itemId = 18034 }, -- Smeargle
        { itemId = 18035 }, -- Tyrogue
        { itemId = 18047 }, -- Tyranitar
    },
    [29123] = {
        -- common doll box
        { itemId = 17894 }, -- -- Farfetch'd
        { itemId = 17915 }, -- -- Hitmonlee
        { itemId = 17916 }, -- -- Hitmonchan
        { itemId = 17917 }, -- -- Lickitung
        { itemId = 17923 }, -- -- Kangaskhan
        { itemId = 17931 }, -- -- Scyther
        { itemId = 17935 }, -- -- Pinsir
        { itemId = 17936 }, -- -- Tauros
        { itemId = 17944 }, -- -- Porygon
        { itemId = 17975 }, -- -- Togepi
        { itemId = 17976 }, -- -- Togetic
        { itemId = 18001 }, -- -- Wobbuffet
        { itemId = 18011 }, -- -- Scizor
        { itemId = 18033 }, -- -- Stantler
        { itemId = 18032 }, -- -- Porygon2
        { itemId = 18033 }, -- -- Stantler
        { itemId = 18035 }, -- -- Tyrogue
        { itemId = 18036 }, -- -- Hitmontop
        { itemId = 18040 }, -- -- Miltank
        { itemId = 18047 }, -- -- Tyranitar
        { itemId = 29023 }, -- -- Nosepass
        { itemId = 29076 }, -- -- Kecleon
        { itemId = 29081 }, -- -- Tropius
        { itemId = 29082 }, -- -- Chimecho
        { itemId = 29083 }, -- -- Absol
        { itemId = 29084 }, -- -- Wynault
    },
    [29124] = {
        -- rare doll box
        { itemId = 12268 }, -- -- Chansey
        { itemId = 17930 }, -- -- Mr. Mime
        { itemId = 17939 }, -- -- Ditto
        { itemId = 17940 }, -- -- Eevee
        { itemId = 17941 }, -- -- Vaporeon
        { itemId = 17942 }, -- -- Jolteon
        { itemId = 17943 }, -- -- Flareon
        { itemId = 12267 }, -- -- Omanyte
        { itemId = 17945 }, -- -- Omastar
        { itemId = 12265 }, -- -- Kabuto
        { itemId = 17946 }, -- -- Kabutops
        { itemId = 17947 }, -- -- Aerodactyl
        { itemId = 17949 }, -- -- Dratini
        { itemId = 17950 }, -- -- Dragonair
        { itemId = 17951 }, -- -- Dragonite
        { itemId = 17985 }, -- -- Sudowoodo
        { itemId = 18041 }, -- -- Blissey
        { itemId = 29069 }, -- -- Lileep
        { itemId = 29070 }, -- -- Cradily
        { itemId = 29071 }, -- -- Anorith
        { itemId = 29072 }, -- -- Armaldo.
    },
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local doll = table.random(ITEMS[item.itemid])
    if (not doPlayerSafeAddItem(cid, doll.itemId, 1, true, false, true)) then
        return false
    end

    doRemoveItem(item.uid, 1)
    doSendMagicEffect(toPosition, EFFECT_POFF)
    return true
end
