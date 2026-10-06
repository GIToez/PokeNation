ITEMS = {
    FIRE_STONE = 18083,
    LEAF_STONE = 18086,
    MOON_STONE = 18084,
    SUN_STONE = 18085,
    THUNDERSTONE = 18087,
    WATER_STONE = 18088,
    UPGRADE = 18089,
    DRAGON_SCALE = 18090,
    KINGS_ROCK = 18091,
    METAL_COAT = 18092,
    SOOTHE_BELL = 18093,
    KICK_MACHINE = 18095,
    PUNCH_MACHINE = 18094,
    SPIN_MACHINE = 18096,
    DEEPSEATOOTH = 28893,
    DEEPSEASCALE = 28892,
    PRISM_SCALE = 28914,
}

POKEMON = {}
dodirectory(PS_LIB_CONFIG_DIR .. "pokemon/")

local POKEMONS = {}
for name, pokemon in pairs(POKEMON) do
    -- Automatic set
    if (pokemon.catchStorage == -1) then
        pokemon.catchStorage = 16000 + getPokemonNumberByName(name)
    end

    -- Automatic set
    if (pokemon.portrait == -1) then
        pokemon.portrait = 28149 + getPokemonNumberByName(name)
    end

    -- Automatic set
    if (pokemon.dexPortrait == -1) then
        pokemon.dexPortrait = 28013 + getPokemonNumberByName(name)
    end

    POKEMONS[name] = pokemon

    if (isString(name)) then
        local shiny = "Shiny " .. name
        POKEMONS[shiny] = table.deepcopy(pokemon)
        POKEMONS[shiny].energy = 200
        POKEMONS[shiny].portrait = 0
        POKEMONS[shiny].fastcallPortrait = 0

        for _, evolution in pairs(POKEMONS[shiny].evolutions) do
            evolution.name = "Shiny " .. evolution.name
        end
    end
end

--[[local out = {}
for name, pokemon in pairs(POKEMONS) do
    if (string.find(tostring(name), "Shiny")) then
        out[#out + 1] = "POKEMONS[\"" .. name .. "\"].portrait = " .. pokemon.portrait .. "\n"
        out[#out + 1] = "POKEMONS[\"" .. name .. "\"].fastcallPortrait = " .. pokemon.fastcallPortrait .. "\n"
    end
end
out[#out + 1] = "\n\n\n"

local file = io.open("afile", "w+")
if (file) then
    file:write(table.concat(out))
    file:close()
end]]

table.clear(POKEMON)
POKEMON = nil

table.clear(ITEMS)
ITEMS = nil

POKEMONS["Shiny Raticate"].portrait = 13940
POKEMONS["Shiny Raticate"].fastcallPortrait = 12266
POKEMONS["Shiny Hypno"].portrait = 14202
POKEMONS["Shiny Hypno"].fastcallPortrait = 12528
POKEMONS["Shiny Farfetchd"].portrait = 14188
POKEMONS["Shiny Farfetchd"].fastcallPortrait = 12514
POKEMONS["Shiny Horsea"].portrait = 14323
POKEMONS["Shiny Horsea"].fastcallPortrait = 12649
POKEMONS["Shiny Kangaskhan"].portrait = 14322
POKEMONS["Shiny Kangaskhan"].fastcallPortrait = 12648
POKEMONS["Shiny Pinsir"].portrait = 14334
POKEMONS["Shiny Pinsir"].fastcallPortrait = 12660
POKEMONS["Shiny Flareon"].portrait = 14343
POKEMONS["Shiny Flareon"].fastcallPortrait = 12669
POKEMONS["Shiny Nidorana"].portrait = 13949
POKEMONS["Shiny Nidorana"].fastcallPortrait = 12275
POKEMONS["Shiny Geodude"].portrait = 14179
POKEMONS["Shiny Geodude"].fastcallPortrait = 12505
POKEMONS["Shiny Diglett"].portrait = 13970
POKEMONS["Shiny Diglett"].fastcallPortrait = 12296
POKEMONS["Shiny Spearow"].portrait = 13941
POKEMONS["Shiny Spearow"].fastcallPortrait = 12267
POKEMONS["Shiny Umbreon"].portrait = 18789
POKEMONS["Shiny Umbreon"].fastcallPortrait = 17420
POKEMONS["Shiny Kakuna"].portrait = 13934
POKEMONS["Shiny Kakuna"].fastcallPortrait = 12260
POKEMONS["Shiny Lapras"].portrait = 14338
POKEMONS["Shiny Lapras"].fastcallPortrait = 12664
POKEMONS["Shiny Magnemite"].portrait = 14186
POKEMONS["Shiny Magnemite"].fastcallPortrait = 12512
POKEMONS["Shiny Marowak"].portrait = 14312
POKEMONS["Shiny Marowak"].fastcallPortrait = 12638
POKEMONS["Shiny Muk"].portrait = 14194
POKEMONS["Shiny Muk"].fastcallPortrait = 12520
POKEMONS["Shiny Shellder"].portrait = 14195
POKEMONS["Shiny Shellder"].fastcallPortrait = 12521
POKEMONS["Shiny Ivysaur"].portrait = 13922
POKEMONS["Shiny Ivysaur"].fastcallPortrait = 12248
POKEMONS["Shiny Gastly"].portrait = 14197
POKEMONS["Shiny Gastly"].fastcallPortrait = 12523
POKEMONS["Shiny Krabby"].portrait = 14203
POKEMONS["Shiny Krabby"].fastcallPortrait = 12529
POKEMONS["Shiny Onix"].portrait = 14200
POKEMONS["Shiny Onix"].fastcallPortrait = 12526
POKEMONS["Shiny Golem"].portrait = 14181
POKEMONS["Shiny Golem"].fastcallPortrait = 12507
POKEMONS["Shiny Steelix"].portrait = 18791
POKEMONS["Shiny Steelix"].fastcallPortrait = 17422
POKEMONS["Shiny Kadabra"].portrait = 14169
POKEMONS["Shiny Kadabra"].fastcallPortrait = 12495
POKEMONS["Shiny Nidoking"].portrait = 13954
POKEMONS["Shiny Nidoking"].fastcallPortrait = 12280
POKEMONS["Shiny Victreebel"].portrait = 14176
POKEMONS["Shiny Victreebel"].fastcallPortrait = 12502
POKEMONS["Shiny Vileplume"].portrait = 13965
POKEMONS["Shiny Vileplume"].fastcallPortrait = 12291
POKEMONS["Shiny Rhyhorn"].portrait = 14318
POKEMONS["Shiny Rhyhorn"].fastcallPortrait = 12644
POKEMONS["Shiny Rattata"].portrait = 13939
POKEMONS["Shiny Rattata"].fastcallPortrait = 12265
POKEMONS["Shiny Crobat"].portrait = 18785
POKEMONS["Shiny Crobat"].fastcallPortrait = 17416
POKEMONS["Shiny Machoke"].portrait = 14172
POKEMONS["Shiny Machoke"].fastcallPortrait = 12498
POKEMONS["Shiny Mewtwo"].portrait = 14357
POKEMONS["Shiny Mewtwo"].fastcallPortrait = 12683
POKEMONS["Shiny Omanyte"].portrait = 14345
POKEMONS["Shiny Omanyte"].fastcallPortrait = 12671
POKEMONS["Shiny Espeon"].portrait = 18788
POKEMONS["Shiny Espeon"].fastcallPortrait = 17419
POKEMONS["Shiny Vulpix"].portrait = 13957
POKEMONS["Shiny Vulpix"].fastcallPortrait = 12283
POKEMONS["Shiny Voltorb"].portrait = 14205
POKEMONS["Shiny Voltorb"].fastcallPortrait = 12531
POKEMONS["Shiny Weedle"].portrait = 13933
POKEMONS["Shiny Weedle"].fastcallPortrait = 12259
POKEMONS["Shiny Jolteon"].portrait = 14342
POKEMONS["Shiny Jolteon"].fastcallPortrait = 12668
POKEMONS["Shiny Venusaur"].portrait = 13923
POKEMONS["Shiny Venusaur"].fastcallPortrait = 12249
POKEMONS["Shiny Primeape"].portrait = 14162
POKEMONS["Shiny Primeape"].fastcallPortrait = 12488
POKEMONS["Shiny Pidgeotto"].portrait = 13937
POKEMONS["Shiny Pidgeotto"].fastcallPortrait = 12263
POKEMONS["Shiny Jynx"].portrait = 14331
POKEMONS["Shiny Jynx"].fastcallPortrait = 12657
POKEMONS["Shiny Ninetales"].portrait = 13958
POKEMONS["Shiny Ninetales"].fastcallPortrait = 12284
POKEMONS["Shiny Bulbasaur"].portrait = 13921
POKEMONS["Shiny Bulbasaur"].fastcallPortrait = 12247
POKEMONS["Shiny Tauros"].portrait = 14335
POKEMONS["Shiny Tauros"].fastcallPortrait = 12661
POKEMONS["Shiny Nidorano"].portrait = 13952
POKEMONS["Shiny Nidorano"].fastcallPortrait = 12278
POKEMONS["Shiny Magikarp"].portrait = 14336
POKEMONS["Shiny Magikarp"].fastcallPortrait = 12662
POKEMONS["Shiny Dragonair"].portrait = 14355
POKEMONS["Shiny Dragonair"].fastcallPortrait = 12681
POKEMONS["Shiny Alakazam"].portrait = 14170
POKEMONS["Shiny Alakazam"].fastcallPortrait = 12496
POKEMONS["Shiny Starmie"].portrait = 14328
POKEMONS["Shiny Starmie"].fastcallPortrait = 12654
POKEMONS["Shiny Meowth"].portrait = 14157
POKEMONS["Shiny Meowth"].fastcallPortrait = 12483
POKEMONS["Shiny Scizor"].portrait = 18792
POKEMONS["Shiny Scizor"].fastcallPortrait = 17423
POKEMONS["Shiny Exeggutor"].portrait = 14310
POKEMONS["Shiny Exeggutor"].fastcallPortrait = 12636
POKEMONS["Shiny Gyarados"].portrait = 14337
POKEMONS["Shiny Gyarados"].fastcallPortrait = 12663
POKEMONS["Shiny Growlithe"].portrait = 14163
POKEMONS["Shiny Growlithe"].fastcallPortrait = 12489
POKEMONS["Shiny Clefable"].portrait = 13956
POKEMONS["Shiny Clefable"].fastcallPortrait = 12282
POKEMONS["Shiny Gengar"].portrait = 14199
POKEMONS["Shiny Gengar"].fastcallPortrait = 12525
POKEMONS["Shiny Tangela"].portrait = 14321
POKEMONS["Shiny Tangela"].fastcallPortrait = 12647
POKEMONS["Shiny Oddish"].portrait = 13963
POKEMONS["Shiny Oddish"].fastcallPortrait = 12289
POKEMONS["Shiny Politoed"].portrait = 18787
POKEMONS["Shiny Politoed"].fastcallPortrait = 17418
POKEMONS["Shiny Moltres"].portrait = 14353
POKEMONS["Shiny Moltres"].fastcallPortrait = 12679
POKEMONS["Shiny Rapidash"].portrait = 14183
POKEMONS["Shiny Rapidash"].fastcallPortrait = 12509
POKEMONS["Shiny Pidgey"].portrait = 13936
POKEMONS["Shiny Pidgey"].fastcallPortrait = 12262
POKEMONS["Shiny Psyduck"].portrait = 14159
POKEMONS["Shiny Psyduck"].fastcallPortrait = 12485
POKEMONS["Shiny Raichu"].portrait = 13946
POKEMONS["Shiny Raichu"].fastcallPortrait = 12272
POKEMONS["Shiny Ekans"].portrait = 13943
POKEMONS["Shiny Ekans"].fastcallPortrait = 12269
POKEMONS["Shiny Arcanine"].portrait = 14164
POKEMONS["Shiny Arcanine"].fastcallPortrait = 12490
POKEMONS["Shiny Bellossom"].portrait = 18786
POKEMONS["Shiny Bellossom"].fastcallPortrait = 17417
POKEMONS["Shiny Wartortle"].portrait = 13928
POKEMONS["Shiny Wartortle"].fastcallPortrait = 12254
POKEMONS["Shiny Bellsprout"].portrait = 14174
POKEMONS["Shiny Bellsprout"].fastcallPortrait = 12500
POKEMONS["Shiny Eevee"].portrait = 14340
POKEMONS["Shiny Eevee"].fastcallPortrait = 12666
POKEMONS["Shiny Golduck"].portrait = 14160
POKEMONS["Shiny Golduck"].fastcallPortrait = 12486
POKEMONS["Shiny Sandslash"].portrait = 13948
POKEMONS["Shiny Sandslash"].fastcallPortrait = 12274
POKEMONS["Shiny Persian"].portrait = 14158
POKEMONS["Shiny Persian"].fastcallPortrait = 12484
POKEMONS["Shiny Poliwhirl"].portrait = 14166
POKEMONS["Shiny Poliwhirl"].fastcallPortrait = 12492
POKEMONS["Shiny Doduo"].portrait = 14189
POKEMONS["Shiny Doduo"].fastcallPortrait = 12515
POKEMONS["Shiny Mew"].portrait = 14358
POKEMONS["Shiny Mew"].fastcallPortrait = 12684
POKEMONS["Shiny Mankey"].portrait = 14161
POKEMONS["Shiny Mankey"].fastcallPortrait = 12487
POKEMONS["Shiny Hitmonlee"].portrait = 14313
POKEMONS["Shiny Hitmonlee"].fastcallPortrait = 12639
POKEMONS["Shiny Arbok"].portrait = 13944
POKEMONS["Shiny Arbok"].fastcallPortrait = 12270
POKEMONS["Shiny Articuno"].portrait = 14351
POKEMONS["Shiny Articuno"].fastcallPortrait = 12677
POKEMONS["Shiny Parasect"].portrait = 13967
POKEMONS["Shiny Parasect"].fastcallPortrait = 12293
POKEMONS["Shiny Venomoth"].portrait = 13969
POKEMONS["Shiny Venomoth"].fastcallPortrait = 12295
POKEMONS["Shiny Koffing"].portrait = 14316
POKEMONS["Shiny Koffing"].fastcallPortrait = 12642
POKEMONS["Shiny Charmander"].portrait = 13924
POKEMONS["Shiny Charmander"].fastcallPortrait = 12250
POKEMONS["Shiny Pikachu"].portrait = 13945
POKEMONS["Shiny Pikachu"].fastcallPortrait = 12271
POKEMONS["Shiny Nidoqueen"].portrait = 13951
POKEMONS["Shiny Nidoqueen"].fastcallPortrait = 12277
POKEMONS["Shiny Tentacool"].portrait = 14177
POKEMONS["Shiny Tentacool"].fastcallPortrait = 12503
POKEMONS["Shiny Cloyster"].portrait = 14196
POKEMONS["Shiny Cloyster"].fastcallPortrait = 12522
POKEMONS["Shiny Machop"].portrait = 14171
POKEMONS["Shiny Machop"].fastcallPortrait = 12497
POKEMONS["Shiny Charmeleon"].portrait = 13925
POKEMONS["Shiny Charmeleon"].fastcallPortrait = 12251
POKEMONS["Shiny Scyther"].portrait = 14330
POKEMONS["Shiny Scyther"].fastcallPortrait = 12656
POKEMONS["Shiny Abra"].portrait = 14168
POKEMONS["Shiny Abra"].fastcallPortrait = 12494
POKEMONS["Shiny Goldeen"].portrait = 14325
POKEMONS["Shiny Goldeen"].fastcallPortrait = 12651
POKEMONS["Shiny Seel"].portrait = 14191
POKEMONS["Shiny Seel"].fastcallPortrait = 12517
POKEMONS["Shiny Electabuzz"].portrait = 14332
POKEMONS["Shiny Electabuzz"].fastcallPortrait = 12658
POKEMONS["Shiny Ditto"].portrait = 14339
POKEMONS["Shiny Ditto"].fastcallPortrait = 12665
POKEMONS["Shiny Cubone"].portrait = 14311
POKEMONS["Shiny Cubone"].fastcallPortrait = 12637
POKEMONS["Shiny Dodrio"].portrait = 14190
POKEMONS["Shiny Dodrio"].fastcallPortrait = 12516
POKEMONS["Shiny Gloom"].portrait = 13964
POKEMONS["Shiny Gloom"].fastcallPortrait = 12290
POKEMONS["Shiny Golbat"].portrait = 13962
POKEMONS["Shiny Golbat"].fastcallPortrait = 12288
POKEMONS["Shiny Electrode"].portrait = 14308
POKEMONS["Shiny Electrode"].fastcallPortrait = 12634
POKEMONS["Shiny Poliwag"].portrait = 14165
POKEMONS["Shiny Poliwag"].fastcallPortrait = 12491
POKEMONS["Shiny Magmar"].portrait = 14333
POKEMONS["Shiny Magmar"].fastcallPortrait = 12659
POKEMONS["Shiny Paras"].portrait = 13966
POKEMONS["Shiny Paras"].fastcallPortrait = 12292
POKEMONS["Shiny Rhydon"].portrait = 14319
POKEMONS["Shiny Rhydon"].fastcallPortrait = 12645
POKEMONS["Shiny Grimer"].portrait = 14193
POKEMONS["Shiny Grimer"].fastcallPortrait = 12519
POKEMONS["Shiny Magneton"].portrait = 14187
POKEMONS["Shiny Magneton"].fastcallPortrait = 12513
POKEMONS["Shiny Omastar"].portrait = 14346
POKEMONS["Shiny Omastar"].fastcallPortrait = 12672
POKEMONS["Shiny Kingdra"].portrait = 18793
POKEMONS["Shiny Kingdra"].fastcallPortrait = 17424
POKEMONS["Shiny Aerodactyl"].portrait = 14349
POKEMONS["Shiny Aerodactyl"].fastcallPortrait = 12675
POKEMONS["Shiny Kabutops"].portrait = 14348
POKEMONS["Shiny Kabutops"].fastcallPortrait = 12674
POKEMONS["Shiny Tentacruel"].portrait = 14178
POKEMONS["Shiny Tentacruel"].fastcallPortrait = 12504
POKEMONS["Shiny Porygon"].portrait = 14344
POKEMONS["Shiny Porygon"].fastcallPortrait = 12670
POKEMONS["Shiny Machamp"].portrait = 14173
POKEMONS["Shiny Machamp"].fastcallPortrait = 12499
POKEMONS["Shiny Kabuto"].portrait = 14347
POKEMONS["Shiny Kabuto"].fastcallPortrait = 12673
POKEMONS["Shiny Poliwrath"].portrait = 14167
POKEMONS["Shiny Poliwrath"].fastcallPortrait = 12493
POKEMONS["Shiny Seadra"].portrait = 14324
POKEMONS["Shiny Seadra"].fastcallPortrait = 12650
POKEMONS["Shiny Snorlax"].portrait = 14350
POKEMONS["Shiny Snorlax"].fastcallPortrait = 12676
POKEMONS["Shiny Fearow"].portrait = 13942
POKEMONS["Shiny Fearow"].fastcallPortrait = 12268
POKEMONS["Shiny Dragonite"].portrait = 14356
POKEMONS["Shiny Dragonite"].fastcallPortrait = 12682
POKEMONS["Shiny Nidorina"].portrait = 13950
POKEMONS["Shiny Nidorina"].fastcallPortrait = 12276
POKEMONS["Shiny Nidorino"].portrait = 13953
POKEMONS["Shiny Nidorino"].fastcallPortrait = 12279
POKEMONS["Shiny Hitmonchan"].portrait = 14314
POKEMONS["Shiny Hitmonchan"].fastcallPortrait = 12640
POKEMONS["Shiny Venonat"].portrait = 13968
POKEMONS["Shiny Venonat"].fastcallPortrait = 12294
POKEMONS["Shiny Zubat"].portrait = 13961
POKEMONS["Shiny Zubat"].fastcallPortrait = 12287
POKEMONS["Shiny Exeggcute"].portrait = 14309
POKEMONS["Shiny Exeggcute"].fastcallPortrait = 12635
POKEMONS["Shiny Lickitung"].portrait = 14315
POKEMONS["Shiny Lickitung"].fastcallPortrait = 12641
POKEMONS["Shiny Ponyta"].portrait = 14182
POKEMONS["Shiny Ponyta"].fastcallPortrait = 12508
POKEMONS["Shiny Weezing"].portrait = 14317
POKEMONS["Shiny Weezing"].fastcallPortrait = 12643
POKEMONS["Shiny Vaporeon"].portrait = 14341
POKEMONS["Shiny Vaporeon"].fastcallPortrait = 12667
POKEMONS["Shiny Sandshrew"].portrait = 13947
POKEMONS["Shiny Sandshrew"].fastcallPortrait = 12273
POKEMONS["Shiny Dratini"].portrait = 14354
POKEMONS["Shiny Dratini"].fastcallPortrait = 12680
POKEMONS["Shiny Slowpoke"].portrait = 14184
POKEMONS["Shiny Slowpoke"].fastcallPortrait = 12510
POKEMONS["Shiny Dugtrio"].portrait = 14156
POKEMONS["Shiny Dugtrio"].fastcallPortrait = 12482
POKEMONS["Shiny Pidgeot"].portrait = 13938
POKEMONS["Shiny Pidgeot"].fastcallPortrait = 12264
POKEMONS["Shiny Beedrill"].portrait = 13935
POKEMONS["Shiny Beedrill"].fastcallPortrait = 12261
POKEMONS["Shiny Staryu"].portrait = 14327
POKEMONS["Shiny Staryu"].fastcallPortrait = 12653
POKEMONS["Shiny Mr. Mime"].portrait = 14329
POKEMONS["Shiny Mr. Mime"].fastcallPortrait = 12655
POKEMONS["Shiny Charizard"].portrait = 13926
POKEMONS["Shiny Charizard"].fastcallPortrait = 12252
POKEMONS["Shiny Weepinbell"].portrait = 14175
POKEMONS["Shiny Weepinbell"].fastcallPortrait = 12501
POKEMONS["Shiny Blastoise"].portrait = 13929
POKEMONS["Shiny Blastoise"].fastcallPortrait = 12255
POKEMONS["Shiny Wigglytuff"].portrait = 13960
POKEMONS["Shiny Wigglytuff"].fastcallPortrait = 12286
POKEMONS["Shiny Zapdos"].portrait = 14352
POKEMONS["Shiny Zapdos"].fastcallPortrait = 12678
POKEMONS["Shiny Clefairy"].portrait = 13955
POKEMONS["Shiny Clefairy"].fastcallPortrait = 12281
POKEMONS["Shiny Squirtle"].portrait = 13927
POKEMONS["Shiny Squirtle"].fastcallPortrait = 12253
POKEMONS["Shiny Slowking"].portrait = 18790
POKEMONS["Shiny Slowking"].fastcallPortrait = 17421
POKEMONS["Shiny Seaking"].portrait = 14326
POKEMONS["Shiny Seaking"].fastcallPortrait = 12652
POKEMONS["Shiny Jigglypuff"].portrait = 13959
POKEMONS["Shiny Jigglypuff"].fastcallPortrait = 12285
POKEMONS["Shiny Caterpie"].portrait = 13930
POKEMONS["Shiny Caterpie"].fastcallPortrait = 12256
POKEMONS["Shiny Slowbro"].portrait = 14185
POKEMONS["Shiny Slowbro"].fastcallPortrait = 12511
POKEMONS["Shiny Dewgong"].portrait = 14192
POKEMONS["Shiny Dewgong"].fastcallPortrait = 12518
POKEMONS["Shiny Metapod"].portrait = 13931
POKEMONS["Shiny Metapod"].fastcallPortrait = 12257
POKEMONS["Shiny Graveler"].portrait = 14180
POKEMONS["Shiny Graveler"].fastcallPortrait = 12506
POKEMONS["Shiny Chansey"].portrait = 14320
POKEMONS["Shiny Chansey"].fastcallPortrait = 12646
POKEMONS["Shiny Butterfree"].portrait = 13932
POKEMONS["Shiny Butterfree"].fastcallPortrait = 12258
POKEMONS["Shiny Haunter"].portrait = 14198
POKEMONS["Shiny Haunter"].fastcallPortrait = 12524
POKEMONS["Shiny Kingler"].portrait = 14204
POKEMONS["Shiny Kingler"].fastcallPortrait = 12530
POKEMONS["Shiny Drowzee"].portrait = 14201
POKEMONS["Shiny Drowzee"].fastcallPortrait = 12527

POKEMONS["Shiny Chikorita"].portrait = 18946
POKEMONS["Shiny Chikorita"].fastcallPortrait = 17604

POKEMONS["Shiny Bayleef"].portrait = 18947
POKEMONS["Shiny Bayleef"].fastcallPortrait = 17605

POKEMONS["Shiny Meganium"].portrait = 18948
POKEMONS["Shiny Meganium"].fastcallPortrait = 17606

POKEMONS["Shiny Cyndaquil"].portrait = 18949
POKEMONS["Shiny Cyndaquil"].fastcallPortrait = 17607

POKEMONS["Shiny Quilava"].portrait = 18950
POKEMONS["Shiny Quilava"].fastcallPortrait = 17608

POKEMONS["Shiny Typhlosion"].portrait = 18951
POKEMONS["Shiny Typhlosion"].fastcallPortrait = 17609

POKEMONS["Shiny Totodile"].portrait = 18952
POKEMONS["Shiny Totodile"].fastcallPortrait = 17610

POKEMONS["Shiny Croconaw"].portrait = 18953
POKEMONS["Shiny Croconaw"].fastcallPortrait = 17611

POKEMONS["Shiny Feraligatr"].portrait = 18954
POKEMONS["Shiny Feraligatr"].fastcallPortrait = 17612

POKEMONS["Shiny Mareep"].portrait = 18955
POKEMONS["Shiny Mareep"].fastcallPortrait = 17613

POKEMONS["Shiny Flaaffy"].portrait = 18956
POKEMONS["Shiny Flaaffy"].fastcallPortrait = 17614

POKEMONS["Shiny Ampharos"].portrait = 18957
POKEMONS["Shiny Ampharos"].fastcallPortrait = 17615

POKEMONS["Shiny Marill"].portrait = 18958
POKEMONS["Shiny Marill"].fastcallPortrait = 17616

POKEMONS["Shiny Azumarill"].portrait = 18959
POKEMONS["Shiny Azumarill"].fastcallPortrait = 17617

POKEMONS["Shiny Hoppip"].portrait = 18960
POKEMONS["Shiny Hoppip"].fastcallPortrait = 17618

POKEMONS["Shiny Skiploom"].portrait = 18961
POKEMONS["Shiny Skiploom"].fastcallPortrait = 17619

POKEMONS["Shiny Jumpluff"].portrait = 18962
POKEMONS["Shiny Jumpluff"].fastcallPortrait = 17620

POKEMONS["Shiny Sunkern"].portrait = 18963
POKEMONS["Shiny Sunkern"].fastcallPortrait = 17621

POKEMONS["Shiny Sunflora"].portrait = 18964
POKEMONS["Shiny Sunflora"].fastcallPortrait = 17622

POKEMONS["Shiny Houndour"].portrait = 18965
POKEMONS["Shiny Houndour"].fastcallPortrait = 17623

POKEMONS["Shiny Houndoom"].portrait = 18966
POKEMONS["Shiny Houndoom"].fastcallPortrait = 17624

POKEMONS["Shiny Sentret"].portrait = 27568
POKEMONS["Shiny Sentret"].fastcallPortrait = 26071

POKEMONS["Shiny Furret"].portrait = 27569
POKEMONS["Shiny Furret"].fastcallPortrait = 26072

POKEMONS["Shiny Hoothoot"].portrait = 27570
POKEMONS["Shiny Hoothoot"].fastcallPortrait = 26073

POKEMONS["Shiny Noctowl"].portrait = 27571
POKEMONS["Shiny Noctowl"].fastcallPortrait = 26074

POKEMONS["Shiny Ledyba"].portrait = 27572
POKEMONS["Shiny Ledyba"].fastcallPortrait = 26075

POKEMONS["Shiny Ledian"].portrait = 27573
POKEMONS["Shiny Ledian"].fastcallPortrait = 26076

POKEMONS["Shiny Spinarak"].portrait = 27574
POKEMONS["Shiny Spinarak"].fastcallPortrait = 26077

POKEMONS["Shiny Ariados"].portrait = 27575
POKEMONS["Shiny Ariados"].fastcallPortrait = 26078

POKEMONS["Shiny Chinchou"].portrait = 27576
POKEMONS["Shiny Chinchou"].fastcallPortrait = 26079

POKEMONS["Shiny Lanturn"].portrait = 27577
POKEMONS["Shiny Lanturn"].fastcallPortrait = 26080

POKEMONS["Shiny Pichu"].portrait = 27578
POKEMONS["Shiny Pichu"].fastcallPortrait = 26081

POKEMONS["Shiny Cleffa"].portrait = 27579
POKEMONS["Shiny Cleffa"].fastcallPortrait = 26082

POKEMONS["Shiny Igglybuff"].portrait = 27580
POKEMONS["Shiny Igglybuff"].fastcallPortrait = 26083

POKEMONS["Shiny Togepi"].portrait = 27581
POKEMONS["Shiny Togepi"].fastcallPortrait = 26084

POKEMONS["Shiny Togetic"].portrait = 27582
POKEMONS["Shiny Togetic"].fastcallPortrait = 26085

POKEMONS["Shiny Natu"].portrait = 27583
POKEMONS["Shiny Natu"].fastcallPortrait = 26086

POKEMONS["Shiny Xatu"].portrait = 27584
POKEMONS["Shiny Xatu"].fastcallPortrait = 26087

POKEMONS["Shiny Sudowoodo"].portrait = 27585
POKEMONS["Shiny Sudowoodo"].fastcallPortrait = 26088

POKEMONS["Shiny Aipom"].portrait = 27586
POKEMONS["Shiny Aipom"].fastcallPortrait = 26089

POKEMONS["Shiny Yanma"].portrait = 27587
POKEMONS["Shiny Yanma"].fastcallPortrait = 26090

POKEMONS["Shiny Wooper"].portrait = 27588
POKEMONS["Shiny Wooper"].fastcallPortrait = 26091

POKEMONS["Shiny Quagsire"].portrait = 27589
POKEMONS["Shiny Quagsire"].fastcallPortrait = 26092

POKEMONS["Shiny Murkrow"].portrait = 27590
POKEMONS["Shiny Murkrow"].fastcallPortrait = 26093

POKEMONS["Shiny Misdreavus"].portrait = 27591
POKEMONS["Shiny Misdreavus"].fastcallPortrait = 26094

POKEMONS["Shiny Wobbuffet"].portrait = 27592
POKEMONS["Shiny Wobbuffet"].fastcallPortrait = 26095

POKEMONS["Shiny Girafarig"].portrait = 27593
POKEMONS["Shiny Girafarig"].fastcallPortrait = 26096

POKEMONS["Shiny Pineco"].portrait = 27594
POKEMONS["Shiny Pineco"].fastcallPortrait = 26097

POKEMONS["Shiny Forretress"].portrait = 27595
POKEMONS["Shiny Forretress"].fastcallPortrait = 26098

POKEMONS["Shiny Dunsparce"].portrait = 27597
POKEMONS["Shiny Dunsparce"].fastcallPortrait = 26100

POKEMONS["Shiny Gligar"].portrait = 27598
POKEMONS["Shiny Gligar"].fastcallPortrait = 26101

POKEMONS["Shiny Snubbull"].portrait = 27599
POKEMONS["Shiny Snubbull"].fastcallPortrait = 26102

POKEMONS["Shiny Granbull"].portrait = 27600
POKEMONS["Shiny Granbull"].fastcallPortrait = 26103

POKEMONS["Shiny Qwilfish"].portrait = 27601
POKEMONS["Shiny Qwilfish"].fastcallPortrait = 26104

POKEMONS["Shiny Shuckle"].portrait = 27602
POKEMONS["Shiny Shuckle"].fastcallPortrait = 26105

POKEMONS["Shiny Heracross"].portrait = 27603
POKEMONS["Shiny Heracross"].fastcallPortrait = 26106

POKEMONS["Shiny Sneasel"].portrait = 27604
POKEMONS["Shiny Sneasel"].fastcallPortrait = 26107

POKEMONS["Shiny Teddiursa"].portrait = 27605
POKEMONS["Shiny Teddiursa"].fastcallPortrait = 26108

POKEMONS["Shiny Ursaring"].portrait = 27606
POKEMONS["Shiny Ursaring"].fastcallPortrait = 26109

POKEMONS["Shiny Slugma"].portrait = 27607
POKEMONS["Shiny Slugma"].fastcallPortrait = 26110

POKEMONS["Shiny Magcargo"].portrait = 27608
POKEMONS["Shiny Magcargo"].fastcallPortrait = 26111

POKEMONS["Shiny Swinub"].portrait = 27609
POKEMONS["Shiny Swinub"].fastcallPortrait = 26112

POKEMONS["Shiny Piloswine"].portrait = 27610
POKEMONS["Shiny Piloswine"].fastcallPortrait = 26113

POKEMONS["Shiny Corsola"].portrait = 27611
POKEMONS["Shiny Corsola"].fastcallPortrait = 26114

POKEMONS["Shiny Remoraid"].portrait = 27612
POKEMONS["Shiny Remoraid"].fastcallPortrait = 26115

POKEMONS["Shiny Octillery"].portrait = 27613
POKEMONS["Shiny Octillery"].fastcallPortrait = 26116

POKEMONS["Shiny Delibird"].portrait = 27614
POKEMONS["Shiny Delibird"].fastcallPortrait = 26117

POKEMONS["Shiny Mantine"].portrait = 27615
POKEMONS["Shiny Mantine"].fastcallPortrait = 26118

POKEMONS["Shiny Skarmory"].portrait = 27616
POKEMONS["Shiny Skarmory"].fastcallPortrait = 26119

POKEMONS["Shiny Phanpy"].portrait = 27763
POKEMONS["Shiny Phanpy"].fastcallPortrait = 26393

POKEMONS["Shiny Donphan"].portrait = 27617
POKEMONS["Shiny Donphan"].fastcallPortrait = 26120

POKEMONS["Shiny Porygon2"].portrait = 27618
POKEMONS["Shiny Porygon2"].fastcallPortrait = 26121

POKEMONS["Shiny Stantler"].portrait = 27619
POKEMONS["Shiny Stantler"].fastcallPortrait = 26122

POKEMONS["Shiny Smeargle"].portrait = 27620
POKEMONS["Shiny Smeargle"].fastcallPortrait = 26123

POKEMONS["Shiny Tyrogue"].portrait = 27621
POKEMONS["Shiny Tyrogue"].fastcallPortrait = 26124

POKEMONS["Shiny Hitmontop"].portrait = 27622
POKEMONS["Shiny Hitmontop"].fastcallPortrait = 26125

POKEMONS["Shiny Smoochum"].portrait = 27623
POKEMONS["Shiny Smoochum"].fastcallPortrait = 26126

POKEMONS["Shiny Elekid"].portrait = 27624
POKEMONS["Shiny Elekid"].fastcallPortrait = 26127

POKEMONS["Shiny Magby"].portrait = 27625
POKEMONS["Shiny Magby"].fastcallPortrait = 26128

POKEMONS["Shiny Miltank"].portrait = 27626
POKEMONS["Shiny Miltank"].fastcallPortrait = 26129

POKEMONS["Shiny Blissey"].portrait = 27627
POKEMONS["Shiny Blissey"].fastcallPortrait = 26130

POKEMONS["Shiny Larvitar"].portrait = 27628
POKEMONS["Shiny Larvitar"].fastcallPortrait = 26131

POKEMONS["Shiny Pupitar"].portrait = 27629
POKEMONS["Shiny Pupitar"].fastcallPortrait = 26132

POKEMONS["Shiny Tyranitar"].portrait = 27630
POKEMONS["Shiny Tyranitar"].fastcallPortrait = 26133

-- 3rd gen
POKEMONS["Shiny Shelgon"].portrait = 29419
POKEMONS["Shiny Shelgon"].fastcallPortrait = 28175

POKEMONS["Shiny Meditite"].portrait = 29355
POKEMONS["Shiny Meditite"].fastcallPortrait = 28111

POKEMONS["Shiny Shroomish"].portrait = 29332
POKEMONS["Shiny Shroomish"].fastcallPortrait = 28088

POKEMONS["Shiny Whismur"].portrait = 29340
POKEMONS["Shiny Whismur"].fastcallPortrait = 28096

POKEMONS["Shiny Azurill"].portrait = 29345
POKEMONS["Shiny Azurill"].fastcallPortrait = 28101

POKEMONS["Shiny Marshtomp"].portrait = 29305
POKEMONS["Shiny Marshtomp"].fastcallPortrait = 28061

POKEMONS["Shiny Sableye"].portrait = 29349
POKEMONS["Shiny Sableye"].fastcallPortrait = 28105

POKEMONS["Shiny Armaldo"].portrait = 29395
POKEMONS["Shiny Armaldo"].fastcallPortrait = 28151

POKEMONS["Shiny Solrock"].portrait = 29385
POKEMONS["Shiny Solrock"].fastcallPortrait = 28141

POKEMONS["Shiny Minun"].portrait = 29360
POKEMONS["Shiny Minun"].fastcallPortrait = 28116

POKEMONS["Shiny Torchic"].portrait = 29301
POKEMONS["Shiny Torchic"].fastcallPortrait = 28057

POKEMONS["Shiny Zangoose"].portrait = 29382
POKEMONS["Shiny Zangoose"].fastcallPortrait = 28138

POKEMONS["Shiny Skitty"].portrait = 29347
POKEMONS["Shiny Skitty"].fastcallPortrait = 28103

POKEMONS["Shiny Seedot"].portrait = 29320
POKEMONS["Shiny Seedot"].fastcallPortrait = 28076

POKEMONS["Shiny Swablu"].portrait = 29380
POKEMONS["Shiny Swablu"].fastcallPortrait = 28136

POKEMONS["Shiny Salamence"].portrait = 29420
POKEMONS["Shiny Salamence"].fastcallPortrait = 28176

POKEMONS["Shiny Ludicolo"].portrait = 29318
POKEMONS["Shiny Ludicolo"].fastcallPortrait = 28074

POKEMONS["Shiny Metagross"].portrait = 29423
POKEMONS["Shiny Metagross"].fastcallPortrait = 28179

POKEMONS["Shiny Spheal"].portrait = 29410
POKEMONS["Shiny Spheal"].fastcallPortrait = 28166

POKEMONS["Shiny Silcoon"].portrait = 29312
POKEMONS["Shiny Silcoon"].fastcallPortrait = 28068

POKEMONS["Shiny Tropius"].portrait = 29404
POKEMONS["Shiny Tropius"].fastcallPortrait = 28160

POKEMONS["Shiny Shedinja"].portrait = 29339
POKEMONS["Shiny Shedinja"].fastcallPortrait = 28095

POKEMONS["Shiny Ninjask"].portrait = 29338
POKEMONS["Shiny Ninjask"].fastcallPortrait = 28094

POKEMONS["Shiny Relicanth"].portrait = 29416
POKEMONS["Shiny Relicanth"].fastcallPortrait = 28172

POKEMONS["Shiny Barboach"].portrait = 29386
POKEMONS["Shiny Barboach"].fastcallPortrait = 28142

POKEMONS["Shiny Feebas"].portrait = 29396
POKEMONS["Shiny Feebas"].fastcallPortrait = 28152

POKEMONS["Shiny Metang"].portrait = 29422
POKEMONS["Shiny Metang"].fastcallPortrait = 28178

POKEMONS["Shiny Sealeo"].portrait = 29411
POKEMONS["Shiny Sealeo"].fastcallPortrait = 28167

POKEMONS["Shiny Nincada"].portrait = 29337
POKEMONS["Shiny Nincada"].fastcallPortrait = 28093

POKEMONS["Shiny Delcatty"].portrait = 29348
POKEMONS["Shiny Delcatty"].fastcallPortrait = 28104

--POKEMONS["Shiny Groudon"].portrait = 29430
--POKEMONS["Shiny Groudon"].fastcallPortrait = 28186

POKEMONS["Shiny Chimecho"].portrait = 29405
POKEMONS["Shiny Chimecho"].fastcallPortrait = 28161

POKEMONS["Shiny Vigoroth"].portrait = 29335
POKEMONS["Shiny Vigoroth"].fastcallPortrait = 28091

POKEMONS["Shiny Volbeat"].portrait = 29361
POKEMONS["Shiny Volbeat"].fastcallPortrait = 28117

POKEMONS["Shiny Altaria"].portrait = 29381
POKEMONS["Shiny Altaria"].fastcallPortrait = 28137

POKEMONS["Shiny Kecleon"].portrait = 29399
POKEMONS["Shiny Kecleon"].fastcallPortrait = 28155

POKEMONS["Shiny Wailord"].portrait = 29369
POKEMONS["Shiny Wailord"].fastcallPortrait = 28125

POKEMONS["Shiny Medicham"].portrait = 29356
POKEMONS["Shiny Medicham"].fastcallPortrait = 28112

POKEMONS["Shiny Sceptile"].portrait = 29300
POKEMONS["Shiny Sceptile"].fastcallPortrait = 28056

POKEMONS["Shiny Wingull"].portrait = 29325
POKEMONS["Shiny Wingull"].fastcallPortrait = 28081

POKEMONS["Shiny Latias"].portrait = 29427
POKEMONS["Shiny Latias"].fastcallPortrait = 28183

POKEMONS["Shiny Combusken"].portrait = 29302
POKEMONS["Shiny Combusken"].fastcallPortrait = 28058

POKEMONS["Shiny Zigzagoon"].portrait = 29309
POKEMONS["Shiny Zigzagoon"].fastcallPortrait = 28065

--POKEMONS["Shiny Deoxys"].portrait = 29433
--POKEMONS["Shiny Deoxys"].fastcallPortrait = 28189

POKEMONS["Shiny Dusclops"].portrait = 29403
POKEMONS["Shiny Dusclops"].fastcallPortrait = 28159

--POKEMONS["Shiny Regirock"].portrait = 29424
--POKEMONS["Shiny Regirock"].fastcallPortrait = 28180

POKEMONS["Shiny Vibrava"].portrait = 29376
POKEMONS["Shiny Vibrava"].fastcallPortrait = 28132

POKEMONS["Shiny Bagon"].portrait = 29418
POKEMONS["Shiny Bagon"].fastcallPortrait = 28174

POKEMONS["Shiny Mudkip"].portrait = 29304
POKEMONS["Shiny Mudkip"].fastcallPortrait = 28060

POKEMONS["Shiny Cradily"].portrait = 29393
POKEMONS["Shiny Cradily"].fastcallPortrait = 28149

POKEMONS["Shiny Luvdisc"].portrait = 29417
POKEMONS["Shiny Luvdisc"].fastcallPortrait = 28173

POKEMONS["Shiny Carvanha"].portrait = 29366
POKEMONS["Shiny Carvanha"].fastcallPortrait = 28122

POKEMONS["Shiny Seviper"].portrait = 29383
POKEMONS["Shiny Seviper"].fastcallPortrait = 28139

POKEMONS["Shiny Slaking"].portrait = 29336
POKEMONS["Shiny Slaking"].fastcallPortrait = 28092

POKEMONS["Shiny Torkoal"].portrait = 29372
POKEMONS["Shiny Torkoal"].fastcallPortrait = 28128

POKEMONS["Shiny Numel"].portrait = 29370
POKEMONS["Shiny Numel"].fastcallPortrait = 28126

POKEMONS["Shiny Slakoth"].portrait = 29334
POKEMONS["Shiny Slakoth"].fastcallPortrait = 28090

POKEMONS["Shiny Ralts"].portrait = 29327
POKEMONS["Shiny Ralts"].fastcallPortrait = 28083

POKEMONS["Shiny Grovyle"].portrait = 29299
POKEMONS["Shiny Grovyle"].fastcallPortrait = 28055

POKEMONS["Shiny Taillow"].portrait = 29323
POKEMONS["Shiny Taillow"].fastcallPortrait = 28079

POKEMONS["Shiny Nuzleaf"].portrait = 29321
POKEMONS["Shiny Nuzleaf"].fastcallPortrait = 28077

POKEMONS["Shiny Nosepass"].portrait = 29346
POKEMONS["Shiny Nosepass"].fastcallPortrait = 28102

POKEMONS["Shiny Aron"].portrait = 29351
POKEMONS["Shiny Aron"].fastcallPortrait = 28107

POKEMONS["Shiny Wailmer"].portrait = 29368
POKEMONS["Shiny Wailmer"].fastcallPortrait = 28124

POKEMONS["Shiny Gorebyss"].portrait = 29415
POKEMONS["Shiny Gorebyss"].fastcallPortrait = 28171

POKEMONS["Shiny Shuppet"].portrait = 29400
POKEMONS["Shiny Shuppet"].fastcallPortrait = 28156

POKEMONS["Shiny Walrein"].portrait = 29412
POKEMONS["Shiny Walrein"].fastcallPortrait = 28168

POKEMONS["Shiny Manectric"].portrait = 29358
POKEMONS["Shiny Manectric"].fastcallPortrait = 28114

POKEMONS["Shiny Corphish"].portrait = 29388
POKEMONS["Shiny Corphish"].fastcallPortrait = 28144

POKEMONS["Shiny Cacturne"].portrait = 29379
POKEMONS["Shiny Cacturne"].fastcallPortrait = 28135

POKEMONS["Shiny Shiftry"].portrait = 29322
POKEMONS["Shiny Shiftry"].fastcallPortrait = 28078

POKEMONS["Shiny Swalot"].portrait = 29365
POKEMONS["Shiny Swalot"].fastcallPortrait = 28121

POKEMONS["Shiny Aggron"].portrait = 29354
POKEMONS["Shiny Aggron"].fastcallPortrait = 28110

POKEMONS["Shiny Kirlia"].portrait = 29328
POKEMONS["Shiny Kirlia"].fastcallPortrait = 28084

POKEMONS["Shiny Linoone"].portrait = 29310
POKEMONS["Shiny Linoone"].fastcallPortrait = 28066

POKEMONS["Shiny Lunatone"].portrait = 29384
POKEMONS["Shiny Lunatone"].fastcallPortrait = 28140

POKEMONS["Shiny Castform"].portrait = 29398
POKEMONS["Shiny Castform"].fastcallPortrait = 28154

POKEMONS["Shiny Camerupt"].portrait = 29371
POKEMONS["Shiny Camerupt"].fastcallPortrait = 28127

POKEMONS["Shiny Banette"].portrait = 29401
POKEMONS["Shiny Banette"].fastcallPortrait = 28157

--POKEMONS["Shiny Registeel"].portrait = 29426
--POKEMONS["Shiny Registeel"].fastcallPortrait = 28182

POKEMONS["Shiny Baltoy"].portrait = 29390
POKEMONS["Shiny Baltoy"].fastcallPortrait = 28146

POKEMONS["Shiny Lileep"].portrait = 29392
POKEMONS["Shiny Lileep"].fastcallPortrait = 28148

POKEMONS["Shiny Cascoon"].portrait = 29314
POKEMONS["Shiny Cascoon"].fastcallPortrait = 28070

POKEMONS["Shiny Illumise"].portrait = 29362
POKEMONS["Shiny Illumise"].fastcallPortrait = 28118

POKEMONS["Shiny Spoink"].portrait = 29373
POKEMONS["Shiny Spoink"].fastcallPortrait = 28129

POKEMONS["Shiny Exploud"].portrait = 29342
POKEMONS["Shiny Exploud"].fastcallPortrait = 28098

POKEMONS["Shiny Plusle"].portrait = 29359
POKEMONS["Shiny Plusle"].fastcallPortrait = 28115

--POKEMONS["Shiny Jirachi"].portrait = 29432
--POKEMONS["Shiny Jirachi"].fastcallPortrait = 28188

POKEMONS["Shiny Sharpedo"].portrait = 29367
POKEMONS["Shiny Sharpedo"].fastcallPortrait = 28123

POKEMONS["Shiny Breloom"].portrait = 29333
POKEMONS["Shiny Breloom"].fastcallPortrait = 28089

POKEMONS["Shiny Poochyena"].portrait = 29307
POKEMONS["Shiny Poochyena"].fastcallPortrait = 28063

--POKEMONS["Shiny Kyogre"].portrait = 29429
--POKEMONS["Shiny Kyogre"].fastcallPortrait = 28185

POKEMONS["Shiny Pelipper"].portrait = 29326
POKEMONS["Shiny Pelipper"].fastcallPortrait = 28082

POKEMONS["Shiny Hariyama"].portrait = 29344
POKEMONS["Shiny Hariyama"].fastcallPortrait = 28100

POKEMONS["Shiny Wynaut"].portrait = 29407
POKEMONS["Shiny Wynaut"].fastcallPortrait = 28163

POKEMONS["Shiny Absol"].portrait = 29406
POKEMONS["Shiny Absol"].fastcallPortrait = 28162

POKEMONS["Shiny Duskull"].portrait = 29402
POKEMONS["Shiny Duskull"].fastcallPortrait = 28158

POKEMONS["Shiny Spinda"].portrait = 29374
POKEMONS["Shiny Spinda"].fastcallPortrait = 28130

POKEMONS["Shiny Electrike"].portrait = 29357
POKEMONS["Shiny Electrike"].fastcallPortrait = 28113

POKEMONS["Shiny Treecko"].portrait = 29298
POKEMONS["Shiny Treecko"].fastcallPortrait = 28054

POKEMONS["Shiny Gardevoir"].portrait = 29329
POKEMONS["Shiny Gardevoir"].fastcallPortrait = 28085

POKEMONS["Shiny Swampert"].portrait = 29306
POKEMONS["Shiny Swampert"].fastcallPortrait = 28062

POKEMONS["Shiny Clamperl"].portrait = 29413
POKEMONS["Shiny Clamperl"].fastcallPortrait = 28169

POKEMONS["Shiny Glalie"].portrait = 29409
POKEMONS["Shiny Glalie"].fastcallPortrait = 28165

--POKEMONS["Shiny Rayquaza"].portrait = 29431
--POKEMONS["Shiny Rayquaza"].fastcallPortrait = 28187

POKEMONS["Shiny Loudred"].portrait = 29341
POKEMONS["Shiny Loudred"].fastcallPortrait = 28097

POKEMONS["Shiny Lairon"].portrait = 29352
POKEMONS["Shiny Lairon"].fastcallPortrait = 28108

POKEMONS["Shiny Beautifly"].portrait = 29313
POKEMONS["Shiny Beautifly"].fastcallPortrait = 28069

--POKEMONS["Shiny Latios"].portrait = 29428
--POKEMONS["Shiny Latios"].fastcallPortrait = 28184

POKEMONS["Shiny Mawile"].portrait = 29350
POKEMONS["Shiny Mawile"].fastcallPortrait = 28106

POKEMONS["Shiny Mightyena"].portrait = 29308
POKEMONS["Shiny Mightyena"].fastcallPortrait = 28064

POKEMONS["Shiny Grumpig"].portrait = 29353
POKEMONS["Shiny Grumpig"].fastcallPortrait = 28109

POKEMONS["Shiny Flygon"].portrait = 29377
POKEMONS["Shiny Flygon"].fastcallPortrait = 28133

POKEMONS["Shiny Blaziken"].portrait = 29303
POKEMONS["Shiny Blaziken"].fastcallPortrait = 28059

POKEMONS["Shiny Snorunt"].portrait = 29408
POKEMONS["Shiny Snorunt"].fastcallPortrait = 28164

POKEMONS["Shiny Wurmple"].portrait = 29311
POKEMONS["Shiny Wurmple"].fastcallPortrait = 28067

POKEMONS["Shiny Gulpin"].portrait = 29364
POKEMONS["Shiny Gulpin"].fastcallPortrait = 28120

POKEMONS["Shiny Roselia"].portrait = 29363
POKEMONS["Shiny Roselia"].fastcallPortrait = 28119

POKEMONS["Shiny Swellow"].portrait = 29324
POKEMONS["Shiny Swellow"].fastcallPortrait = 28080

--POKEMONS["Shiny Regice"].portrait = 29425
--POKEMONS["Shiny Regice"].fastcallPortrait = 28181

POKEMONS["Shiny Lotad"].portrait = 29316
POKEMONS["Shiny Lotad"].fastcallPortrait = 28072

POKEMONS["Shiny Dustox"].portrait = 29315
POKEMONS["Shiny Dustox"].fastcallPortrait = 28071

POKEMONS["Shiny Trapinch"].portrait = 29375
POKEMONS["Shiny Trapinch"].fastcallPortrait = 28131

POKEMONS["Shiny Lombre"].portrait = 29317
POKEMONS["Shiny Lombre"].fastcallPortrait = 28073

POKEMONS["Shiny Masquerain"].portrait = 29331
POKEMONS["Shiny Masquerain"].fastcallPortrait = 28087

POKEMONS["Shiny Makuhita"].portrait = 29343
POKEMONS["Shiny Makuhita"].fastcallPortrait = 28099

POKEMONS["Shiny Beldum"].portrait = 29421
POKEMONS["Shiny Beldum"].fastcallPortrait = 28177

POKEMONS["Shiny Claydol"].portrait = 29391
POKEMONS["Shiny Claydol"].fastcallPortrait = 28147

POKEMONS["Shiny Whiscash"].portrait = 29387
POKEMONS["Shiny Whiscash"].fastcallPortrait = 28143

POKEMONS["Shiny Cacnea"].portrait = 29378
POKEMONS["Shiny Cacnea"].fastcallPortrait = 28134

POKEMONS["Shiny Surskit"].portrait = 29330
POKEMONS["Shiny Surskit"].fastcallPortrait = 28086

POKEMONS["Shiny Anorith"].portrait = 29394
POKEMONS["Shiny Anorith"].fastcallPortrait = 28150

POKEMONS["Shiny Huntail"].portrait = 29414
POKEMONS["Shiny Huntail"].fastcallPortrait = 28170

POKEMONS["Shiny Crawdaunt"].portrait = 29389
POKEMONS["Shiny Crawdaunt"].fastcallPortrait = 28145

POKEMONS["Shiny Milotic"].portrait = 29397
POKEMONS["Shiny Milotic"].fastcallPortrait = 28153

for name, pokemon in pairs(POKEMONS) do
    if (pokemon.portrait == 0 and pokemon.fastcallPortrait == 0 and string.find(string.lower(name), "shiny")) then -- This shiny doenst exists yet
        POKEMONS[name] = nil
    end
end

for name, pokemon in pairs(POKEMONS) do
    if (pokemon.evolutions and #pokemon.evolutions > 0) then
        for k, v in pairs(pokemon.evolutions) do
            if (not POKEMONS[v.name]) then -- This shiny doenst exists yet
                pokemon.evolutions[k] = nil
            end
        end
    end
end

local POKEMON_NAME_BY_EGG_ID = {
    -- 1st Gen
    [13978] = "Bulbasaur",
    [13979] = "Charmander",
    [13980] = "Squirtle",
    [13981] = "Caterpie",
    [13982] = "Weedle",
    [13983] = "Pidgey",
    [13984] = "Rattata",
    [13985] = "Spearow",
    [13986] = "Ekans",
    [13987] = "Pichu",
    [13988] = "Sandshrew",
    [13989] = "Nidorana",
    [13990] = "Nidorano",
    [13991] = "Cleffa",
    [13992] = "Vulpix",
    [13993] = "Igglybuff",
    [13994] = "Zubat",
    [13995] = "Oddish",
    [13996] = "Paras",
    [13997] = "Venonat",
    [13998] = "Diglett",
    [13999] = "Meowth",
    [14000] = "Psyduck",
    [14001] = "Mankey",
    [14002] = "Growlithe",
    [14003] = "Poliwag",
    [14004] = "Abra",
    [14005] = "Machop",
    [14006] = "Bellsprout",
    [14007] = "Tentacool",
    [14008] = "Geodude",
    [14009] = "Ponyta",
    [14010] = "Slowpoke",
    [14011] = "Magnemite",
    [14012] = "Farfetchd",
    [14013] = "Doduo",
    [14014] = "Seel",
    [14015] = "Grimer",
    [14016] = "Shellder",
    [14017] = "Gastly",
    [14018] = "Onix",
    [14019] = "Drowzee",
    [14020] = "Krabby",
    [14021] = "Voltorb",
    [14022] = "Exeggcute",
    [14023] = "Cubone",
    [14024] = "Hitmonlee",
    [14025] = "Hitmonchan",
    [14026] = "Lickitung",
    [14027] = "Koffing",
    [14028] = "Rhyhorn",
    [14029] = "Chansey",
    [14030] = "Tangela",
    [14031] = "Kangaskhan",
    [14032] = "Horsea",
    [14033] = "Goldeen",
    [14034] = "Staryu",
    [14035] = "Mr. Mime",
    [14036] = "Scyther",
    [14037] = "Smoochum",
    [14038] = "Elekid",
    [14039] = "Magby",
    [14040] = "Pinsir",
    [14041] = "Tauros",
    [14042] = "Magikarp",
    [14043] = "Lapras",
    [14816] = "Ditto",
    [14044] = "Eevee",
    [14045] = "Porygon",
    [14364] = "Omanyte",
    [14365] = "Kabuto",
    [18765] = "Aerodactyl",
    [14046] = "Snorlax",
    [14047] = "Dratini",
    -- 2nd Gen
    [17741] = "Chikorita",
    [17742] = "Cyndaquil",
    [17743] = "Totodile",
    [17744] = "Sentret",
    [17745] = "Hoothoot",
    [17746] = "Ledyba",
    [17747] = "Spinarak",
    [17748] = "Chinchou",
    [17749] = "Togepi",
    [17750] = "Natu",
    [17751] = "Mareep",
    [17752] = "Azurill",
    [17753] = "Sudowoodo",
    [17754] = "Hoppip",
    [17755] = "Aipom",
    [17756] = "Sunkern",
    [17757] = "Yanma",
    [17758] = "Wooper",
    [17759] = "Murkrow",
    [17760] = "Misdreavus",
    [17761] = "Wynaut",
    [17762] = "Girafarig",
    [17763] = "Pineco",
    [17764] = "Dunsparce",
    [17765] = "Gligar",
    [17766] = "Snubbull",
    [17767] = "Qwilfish",
    [17768] = "Shuckle",
    [17769] = "Heracross",
    [17770] = "Sneasel",
    [17771] = "Teddiursa",
    [17772] = "Slugma",
    [17773] = "Swinub",
    [17774] = "Corsola",
    [17775] = "Remoraid",
    [17776] = "Delibird",
    [17777] = "Mantine",
    [17778] = "Skarmory",
    [17779] = "Houndour",
    [17780] = "Phanpy",
    [17781] = "Stantler",
    [17782] = "Smeargle",
    [17783] = "Tyrogue",
    [17784] = "Miltank",
    [17785] = "Larvitar",
    -- 3rd
    [28589] = "Treecko",
    [28536] = "Absol",
    [28537] = "Anorith",
    [28538] = "Aron",
    [28539] = "Bagon",
    [28540] = "Baltoy",
    [28541] = "Barboach",
    [28542] = "Beldum",
    [28543] = "Cacnea",
    [28544] = "Carvanha",
    [28545] = "Castform",
    [28546] = "Chimecho",
    [28547] = "Clamperl",
    [28548] = "Corphish",
    [28549] = "Duskull",
    [28550] = "Electrike",
    [28551] = "Feebas",
    [28552] = "Gulpin",
    [28553] = "Illumise",
    [28554] = "Lileep",
    [28555] = "Lotad",
    [28556] = "Lunatone",
    [28557] = "Luvdisc",
    [28558] = "Makuhita",
    [28559] = "Mawile",
    [28560] = "Meditite",
    [28561] = "Minun",
    [28562] = "Mudkip",
    [28563] = "Nincada",
    [28564] = "Nosepass",
    [28565] = "Numel",
    [28566] = "Plusle",
    [28567] = "Poochyena",
    [28568] = "Ralts",
    [28569] = "Relicanth",
    [28570] = "Roselia",
    [28571] = "Sableye",
    [28572] = "Seedot",
    [28573] = "Seviper",
    [28574] = "Shroomish",
    [28575] = "Shuppet",
    [28576] = "Skitty",
    [28577] = "Slakoth",
    [28578] = "Snorunt",
    [28579] = "Solrock",
    [28580] = "Spheal",
    [28581] = "Spinda",
    [28582] = "Spoink",
    [28583] = "Surskit",
    [28584] = "Swablu",
    [28585] = "Taillow",
    [28586] = "Torchic",
    [28587] = "Torkoal",
    [28588] = "Trapinch",
    [28599] = "Treecko",
    [28590] = "Tropius",
    [28591] = "Volbeat",
    [28592] = "Wailmer",
    [28593] = "Whismur",
    [28594] = "Wingull",
    [28595] = "Wurmple",
    [28596] = "Zangoose",
    [28597] = "Zigzagoon",
    [28598] = "Kecleon",
}

local EVOLVE_FROM = {}
for name, pokemon in pairs(POKEMONS) do
    if (isPokemonName(name) and pokemon.evolutions) then -- Checking if its a Pokemon Name we skip versions of original Pokemons, like Ranger Club bosses, this affect the system, we can't allow
        for _, evolution in pairs(pokemon.evolutions) do
            EVOLVE_FROM[evolution.name] = name
        end
    end
end

-- Get
function getPokemonTypes(cid, pokemonName)
    if (cid) then
        local custom = getPokemonCustomType(cid)
        if (custom ~= EMPTY_STORAGE) then
            return { custom }
        end
    end

    if (not pokemonName) then
        pokemonName = getPokemonReferenceName(cid)
    end
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonTypes - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].pTypes
end

function getPokemonDexStorage(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonDexStorage - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].dexStorage
end

local function getPokemonBaseAtk(cid)
    local pokemonName = getPokemonReferenceName(cid)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonBaseAtk - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].atk
end

local function getPokemonBaseDef(cid)
    local pokemonName = getPokemonReferenceName(cid)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonBaseDef - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].def
end

local function getPokemonBaseSpAtk(cid)
    local pokemonName = getPokemonReferenceName(cid)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonBaseSpAtk - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].spAtk
end

local function getPokemonBaseSpDef(cid)
    local pokemonName = getPokemonReferenceName(cid)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonBaseSpDef - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].spDef
end

function getPokemonBaseEnergy(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonBaseEnergy - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].energy
end

function getPokemonCatchChance(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonCatchChance - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].chance
end

function getPokemonPortraitId(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonPortraitId - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].portrait
end

function getPokemonDexPortraitId(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonDexPortraitId - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].dexPortrait
end

function getPokemonFastcallPortraitId(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonFastcallPortraitId - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].fastcallPortrait
end

function getPokemonDescription(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonDescription - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].description
end

function getPokemonDefaultSkills(pokemonName)
    local pokemonSkills = {}
    for i = 1, #POKEMONS[pokemonName].skills, 2 do
        table.insert(pokemonSkills, POKEMONS[pokemonName].skills[i])
    end
    return pokemonSkills
end

function getPokemonSkills(pokemonName, ballUid)
    local pokemonSkills, tm1, tm2 = getPokemonDefaultSkills(pokemonName), getBallTm(ballUid, 1), getBallTm(ballUid, 2)
    if (tm1 ~= TM_IDS.NONE) then
        pokemonSkills[getBallTmSlot(ballUid, 1)] = getTmMove(tm1)
    end
    if (tm2 ~= TM_IDS.NONE) then
        pokemonSkills[getBallTmSlot(ballUid, 2)] = getTmMove(tm2)
    end

    local eggMoveSlot = getBallEggMoveSlot(ballUid)
    if (eggMoveSlot) then
        local eggMove = getBallEggMove(ballUid)
        if (eggMove) then
            pokemonSkills[eggMoveSlot] = eggMove
        end
    end

    for k, v in pairs(getBallSketchMoves(ballUid)) do
        pokemonSkills[k + 1] = v -- +1 to Skip the move Tackle
    end

    return pokemonSkills
end

function getPokemonCurrentMoves(cid)
    if (isPokemonTransformed(cid)) then
        return getPokemonDefaultSkills(getPokemonCurrentTransformation(cid))
    end

    if (isPokemonWild(cid)) then
        return getPokemonDefaultSkills(getCreatureName(cid))
    end

    local master = getCreatureMaster(cid)
    if (isPlayer(master)) then
        local ball = getPlayerBall(cid)
        if (isItem(ball)) then
            return getPokemonSkills(getCreatureName(cid), ball.uid)
        end
    end

    return getPokemonDefaultSkills(getCreatureName(cid))
end

function getPokemonSkillRequiredLevel(pokemonName, skillName)
    for i = 1, #POKEMONS[pokemonName].skills, 2 do
        if (POKEMONS[pokemonName].skills[i] == skillName) then
            return POKEMONS[pokemonName].skills[i + 1]
        end
    end
    --print("ERROR: getPokemonSkillRequiredLevel -> skillName cannot be found in pokemon skill list, returning 0 to required level! Skill: " .. skillName)
    return 0
end

function getPokemonAbilities(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonAbilities - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].abilities
end

function getPokemonEvolutions(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonEvolutions - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].evolutions
end

function getPokemonEvolutionNeededStones(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonEvolutionNeededStones - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].evolutionStone
end

function getPokemonAtk(pokemon, pokemonLevel)
    return (getPokemonBaseAtk(pokemon) + getMonsterExtraSpAtk(pokemon)) * (pokemonLevel * 0.05)
            * getMonsterVarPokeStat(pokemon, MONSTER_POKE_STATS.ATTACK)
end

function getPokemonDef(pokemon, pokemonLevel)
    return ((getPokemonBaseDef(pokemon) + getMonsterExtraSpDef(pokemon)) * (pokemonLevel * 0.05))
            * getMonsterVarPokeStat(pokemon, MONSTER_POKE_STATS.DEFENSE)
end

function getPokemonSpAtk(pokemon, pokemonLevel)
    return ((getPokemonBaseSpAtk(pokemon) + getMonsterExtraSpAtk(pokemon)) * (pokemonLevel * 0.05))
            * getMonsterVarPokeStat(pokemon, MONSTER_POKE_STATS.SPECIALATTACK)
end

function getPokemonSpDef(pokemon, pokemonLevel)
    return ((getPokemonBaseSpDef(pokemon) + getMonsterExtraSpDef(pokemon)) * (pokemonLevel * 0.05))
            * getMonsterVarPokeStat(pokemon, MONSTER_POKE_STATS.SPECIALDEFENSE)
end

function getPokemonBaseHealth(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonBaseHealth - Unknown poke name.", pokemonName)
    end
    return getMonsterInfo(pokemonName).health + 300
end

function getPokemonEggGroups(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonEggGroups - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].eggGroup
end

function getPokemonEggId(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonEggId - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].eggId
end

function getPokemonNameByEggId(eggId)
    return POKEMON_NAME_BY_EGG_ID[eggId]
end

function getPokemonEggGenerationChance(pokemonName)
    return POKEMONS[pokemonName].eggChance or 10 -- default is 20%
end

function getPokemonCatchStorage(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonCatchStorage - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].catchStorage
end

function getPokemonSpecialAbilities(pokemonName)
    if (not POKEMONS[pokemonName]) then
        log(LOG_TYPES.ERROR, "getPokemonSpecialAbilities - Unknown poke name.", pokemonName)
    end
    return POKEMONS[pokemonName].specialAbilities or {}
end

function getPokemonRandomSpecialAbility(pokemonName)
    local abilities = getPokemonSpecialAbilities(pokemonName)
    if (#abilities > 0) then
        return table.random(abilities)
    end
    return POKEMON_SPECIAL_ABILITY_IDS.NONE
end

function getPokemonPrice(pokemonName)
    return POKEMONS[pokemonName].price or math.floor(((POKEMONS[pokemonName].chance * 8) *
            (string.find(string.lower(pokemonName), "shiny") and 2 or 1)) * 1.25)
end

function getPokemonPriorEvolution(pokemonName)
    return EVOLVE_FROM[pokemonName]
end

function getPokemonBlockTransform(pokemonName)
    return POKEMONS[pokemonName].blockTransform or false
end

function getPokemonEvolveLevel(pokemonName)
    local prior = getPokemonPriorEvolution(pokemonName)
    if (prior) then
        for _, evo in pairs(getPokemonEvolutions(prior)) do
            if (evo.name == pokemonName) then
                return evo.requiredLevel
            end
        end
    end

    return 0
end

function getPokemonFamiliesString(pokemonName)
    return POKEMONS[pokemonName].familiesString
end

function getPokemonEggMoves(pokemonName)
    return POKEMONS[pokemonName].eggMoves and POKEMONS[pokemonName].eggMoves or {}
end

function getPokemonAllowedBall(pokemonName)
    return POKEMONS[pokemonName].allowedBall
end

function getPokemonIgnoreBallCounter(pokemonName)
    return POKEMONS[pokemonName].ignoreBallCounter
end

-- Is
-- Others
function havePokemonEvolution(pokemonName)
    return #POKEMONS[pokemonName].evolutions > 0
end

function canPokemonBreed(pokemonFemale, pokemonMale)
    if (#getPokemonEggGroups(pokemonFemale) == 0 or #getPokemonEggGroups(pokemonMale) == 0) then
        return false

    elseif (pokemonFemale == "Ditto") then
        if (pokemonMale == "Ditto") then
            return false
        end
        return true

    elseif (pokemonMale == "Ditto") then
        return true

    else
        for i = 1, #POKEMONS[pokemonFemale].eggGroup do
            for j = 1, #POKEMONS[pokemonMale].eggGroup do
                if (POKEMONS[pokemonFemale].eggGroup[i] == POKEMONS[pokemonMale].eggGroup[j]) then
                    return true
                end
            end
        end
    end
    return false
end

function getPokemonTmLearnable(pokemonName, tmId)
    if (type(POKEMONS[pokemonName].learnableTms) == "boolean") then
        return POKEMONS[pokemonName].learnableTms
    end
    return getTmAllLearn(tmId) or table.find(POKEMONS[pokemonName].learnableTms, tmId)
end

function getPokemonLearnableTms(pokemonName)
    return POKEMONS[pokemonName].learnableTms
end

function getPokemonAbilityAvailable(cid, ability, pokemonName)
    return table.find(getPokemonAbilities(pokemonName and pokemonName or getPokemonReferenceName(cid)), ability)
end

for name, pokemon in pairs(POKEMONS) do
    if (not pokemon.families and getPokemonNumberByName(name)) then
        pokemon.families = {}
        pokemon.familiesString = {}

        -- prior
        local prior = getPokemonPriorEvolution(name)
        local priorList = {}
        local antiLoop = 0
        while (prior and antiLoop < 999) do
            priorList[#priorList + 1] = getPokemonNumberByName(prior)
            antiLoop = antiLoop + 1
            prior = getPokemonPriorEvolution(prior)
        end

        for i = #priorList, 1, -1 do -- This way we always will have the right order evo1, evo2, evo3, etc.
            local prior = priorList[i]
            pokemon.families[#pokemon.families + 1] = getPokemonNameByNumber(prior)
            pokemon.familiesString[#pokemon.familiesString + 1] = prior
            pokemon.familiesString[#pokemon.familiesString + 1] = ","
        end

        -- self
        pokemon.families[#pokemon.families + 1] = name
        pokemon.familiesString[#pokemon.familiesString + 1] = getPokemonNumberByName(name)
        pokemon.familiesString[#pokemon.familiesString + 1] = ","

        -- evolutions
        local evolutionList = { pokemon.evolutions }
        while (#evolutionList > 0) do
            for _, evolution in pairs(evolutionList[1]) do
                pokemon.families[#pokemon.families + 1] = evolution.name
                pokemon.familiesString[#pokemon.familiesString + 1] = getPokemonNumberByName(evolution.name)
                pokemon.familiesString[#pokemon.familiesString + 1] = ","

                evolutionList[#evolutionList + 1] = getPokemonEvolutions(evolution.name)
            end

            table.remove(evolutionList, 1)
        end

        pokemon.familiesString[#pokemon.familiesString] = nil
        pokemon.familiesString = table.concat(pokemon.familiesString)
    end
end

--local BLOCKED_EM_LIST = { "Growl", "Assurance", "Super Fang", "Wild Charge", "Disarming Voice", "Moonblast", "Overheat", "Heat Wave", "Petal Blizzard", "Play Rough", "Secret Power", "U-turn", "Shadow Claw", "Mind Reader", "Circle Throw", "Miracle Eye", "Dazzling Gleam", "Bulk Up", "Heavy Slam", "Uproar", "Frost Breath", "Belch", "Icicle Spear", "Icicle Crash", "Smack Down", "Dragon Breath", "Magnet Rise", "Foresight", "Blaze Kick", "Sky Uppercut", "Low Sweep", "Knock Off", "Chip Away", "Facade", "Grass Knot", "Scald", "Draining Kiss", "Heart Stamp", "Focus Blast", "Sunny Day", "Foul Play", "Shell Smash", "Aqua Jet", "Sky Drop", "Freeze-Dry", "Dragon Rush", "Aura Sphere", "Psystrike", "Synchronoise", "Light Screen", "Mach Punch", "Fairy Wind", "Covet", "Water Sport", "Ingrain", "Flower Shield", "Heal Bell", "Encore", "Destiny Bond", "Bulldoze", "Arm Thrust", "Incinerate", "Mud Sport", "Octazooka", "Roar", "Sacred Fire", "Aeroblast", "Seed Bomb", "Reflect Type", "Psyshock", "Last Resort", "Brave Bird", "Astonish", "Sandstorm", "Struggle Bug", "Gastro Acid", "Endure", "Hidden Power", "Pluck" }
local BLOCKED_EM_LIST = {}
function doUpdatePokemonEggMovesList()
    -- Update first Forms
    for name, pokemon in pairs(POKEMONS) do
        if (pokemon.eggMoves and pokemon.families and not getPokemonPriorEvolution(name)) then
            --print(string.concat("Checking ", name, " egg moves..."))
            for i = #pokemon.eggMoves, 1, -1 do -- Backwards, so we can update the table while iterate it
                local move = pokemon.eggMoves[i]
                local remove = false

                if (not getPokemonSkillExists(move)) then
                    --print(string.concat(move, " doesn't exists on PSoul, removing from list."))
                    remove = true
                else
                    local makeHeal = getPokemonSkillMakeHeal(move)

                    for _, family in pairs(pokemon.families) do
                        if (table.find(getPokemonDefaultSkills(family), move)) then
                            remove = true

                        elseif (makeHeal) then
                            for _, evoMove in pairs(getPokemonDefaultSkills(family)) do
                                if (getPokemonSkillMakeHeal(evoMove)) then
                                    remove = true
                                    break
                                end
                            end
                        end
                    end
                end

                local tmId = getTmByMove(move)
                if (tmId and getTmUnique(tmId)) then
                    remove = true
                end

                if (not remove) then
                    remove = table.find(BLOCKED_EM_LIST, move)
                end

                if (remove) then
                    table.remove(pokemon.eggMoves, i)
                end
            end
        end
    end

    -- Update evolutions
    for name, pokemon in pairs(POKEMONS) do
        local prior = getPokemonPriorEvolution(name)
        while (prior) do
            local nextPrior = getPokemonPriorEvolution(prior)
            if (not nextPrior) then -- lowest prior
                pokemon.eggMoves = table.deepcopy(getPokemonEggMoves(prior))
            end

            prior = nextPrior
        end
    end
end

-- Remove Waterfall ability from Pokemon that doesnt have Surf
for name, pokemon in pairs(POKEMONS) do
    if (getPokemonNumberByName(name)) then
        local waterfall = table.find(pokemon.abilities, POKEMON_ABILITIES.WATERFALL)
        if (waterfall and not table.find(pokemon.abilities, POKEMON_ABILITIES.SURF)) then
            table.remove(pokemon.abilities, waterfall)
        end
    end
end

function doCheckPokemonSkills()
    for name, pokemon in pairs(POKEMONS) do
        for i = 1, #pokemon.skills, 2 do
            local move = pokemon.skills[i]
            if (not getPokemonSkillExists(move)) then
                print("Unknown Pokemon Move: " .. name .. " - " .. tostring(move))
            end
        end
    end
end

function doCheckPokemonEggMoves()
    for name, pokemon in pairs(POKEMONS) do
        if (getPokemonGenerationByName(name) == 3) then
            for i = 1, #pokemon.eggMoves do
                local move = pokemon.eggMoves[i]
                if (not getPokemonSkillExists(move)) then
                    print("Unknown Egg Move: " .. name .. " - " .. tostring(move))
                end
            end
        end
    end
end

--function doCheckPokemonSpecialAbilities()
--    for name, pokemon in pairs(POKEMONS) do
--        for i = 1, #pokemon.specialAbilities do
--            local specialAbility = pokemon.specialAbilities[i]
--            if (not getPokemonSpecialAbilityName(specialAbility)) then
--                print("Unknown Special Ability: " .. name .. " - " .. tostring(specialAbility))
--            end
--        end
--    end
--end