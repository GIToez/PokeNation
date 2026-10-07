local ATTRIBUTES = {
    SEED = 6500
}
local FERTILE_GROUND = { 804, 28956 }
local RAW_GROUND = 103
local LEAVES = 2244
local DRAW_WELL = { 1368, 1369 }

local BERRY_TREE_SPAWNS = {
    { 3528, 1010, 7 }, { 3558, 1001, 7 }, { 3632, 1006, 7 }, { 3295, 1024, 6 }, { 3271, 1006, 6 }, { 3292, 990, 6 }, { 3324, 973, 6 }, { 3342, 989, 6 }, { 3311, 917, 6 }, { 3412, 765, 6 }, { 3409, 750, 5 }, { 3342, 758, 7 }, { 3371, 736, 7 }, { 3281, 722, 7 }, { 3252, 759, 7 }, { 3258, 778, 6 }, { 3262, 728, 6 }, { 3237, 710, 5 }, { 3259, 662, 5 }, { 3366, 678, 5 }, { 3408, 701, 6 }, { 3343, 643, 6 }, { 3397, 655, 7 }, { 3265, 647, 7 }, { 3216, 586, 7 }, { 3176, 559, 7 }, { 3136, 587, 7 }, { 3179, 651, 7 }, { 3231, 656, 5 }, { 3348, 542, 5 }, { 3358, 512, 7 }, { 3277, 494, 7 }, { 3264, 463, 7 }, { 3239, 385, 7 }, { 3278, 354, 6 }, { 3193, 428, 6 }, { 3221, 470, 6 }, { 3245, 448, 6 }, { 3284, 442, 6 }, { 3261, 492, 5 }, { 3232, 439, 5 }, { 3280, 419, 5 }, { 3334, 482, 5 }, { 3364, 452, 6 }, { 3323, 432, 6 }, { 3251, 327, 7 }, { 3231, 288, 7 }, { 3358, 318, 7 }, { 3406, 279, 7 }, { 3467, 263, 7 }, { 3474, 287, 7 }, { 3361, 247, 7 }, { 3357, 267, 6 }, { 3387, 245, 6 }, { 3439, 270, 6 }, { 3433, 261, 5 }, { 3477, 313, 6 }, { 3545, 303, 5 }, { 3627, 289, 5 }, { 3614, 299, 3 }, { 3569, 359, 3 }, { 3530, 318, 3 }, { 3563, 274, 3 }, { 3530, 348, 2 }, { 3550, 320, 2 }, { 3555, 261, 2 }, { 3502, 249, 3 }, { 3588, 243, 3 }, { 3497, 354, 4 }, { 3510, 373, 5 }, { 3539, 377, 5 }, { 3557, 426, 5 }, { 3533, 471, 5 }, { 3595, 458, 5 }, { 3538, 492, 5 }, { 3566, 499, 5 }, { 3601, 488, 5 }, { 3608, 522, 5 }, { 3597, 535, 4 }, { 3588, 477, 4 }, { 3482, 478, 4 }, { 3492, 496, 4 }, { 3472, 469, 3 }, { 3509, 433, 3 }, { 3504, 445, 4 }, { 3373, 488, 4 }, { 3381, 479, 5 }, { 3451, 473, 5 }, { 3469, 410, 5 }, { 3433, 396, 5 }, { 3384, 374, 5 }, { 3408, 361, 5 }, { 3445, 330, 5 }, { 3458, 362, 4 }, { 3461, 371, 3 }, { 3413, 350, 3 }, { 3391, 331, 4 }, { 3403, 375, 4 }, { 3354, 407, 4 }, { 3409, 339, 3 }, { 3363, 345, 3 }, { 3349, 389, 3 }, { 3362, 396, 3 }, { 3315, 371, 5 }, { 3339, 360, 2 }, { 3348, 355, 2 }, { 3378, 414, 3 }, { 3377, 433, 5 }, { 3407, 443, 4 }, { 3420, 461, 4 }, { 3447, 453, 3 }, { 3466, 436, 3 }, { 3585, 441, 6 }, { 3623, 381, 6 }, { 3654, 342, 6 }, { 3703, 387, 6 }, { 3738, 402, 6 }, { 3768, 366, 6 }, { 3819, 371, 6 }, { 3821, 388, 6 }, { 3658, 367, 5 }, { 3694, 349, 5 }, { 3755, 387, 5 }, { 3794, 400, 5 }, { 3782, 384, 4 }, { 3716, 343, 4 }, { 3763, 341, 4 }, { 3784, 346, 4 }, { 3828, 400, 4 }, { 3844, 354, 4 }, { 3799, 313, 6 }, { 3790, 336, 6 }, { 3821, 330, 6 }, { 3646, 263, 6 }, { 3633, 265, 7 }, { 3663, 239, 7 }, { 3650, 304, 7 }, { 3711, 311, 7 }, { 3739, 313, 7 }, { 3785, 301, 7 }, { 3819, 281, 7 }, { 3724, 252, 7 }, { 3705, 257, 6 }, { 3773, 266, 6 }, { 3764, 256, 6 }, { 3678, 257, 5 }, { 3681, 233, 5 }, { 3757, 260, 4 }, { 3846, 452, 7 }, { 3798, 462, 7 }, { 3776, 428, 7 }, { 3747, 458, 7 }, { 3663, 511, 7 }, { 3626, 531, 7 }, { 3645, 574, 7 }, { 3641, 614, 7 }, { 3683, 608, 7 }, { 3691, 574, 5 }, { 3710, 551, 5 }, { 3681, 532, 4 }, { 3756, 500, 4 }, { 3744, 498, 5 }, { 3750, 464, 6 }, { 3726, 507, 6 }, { 3757, 515, 6 }, { 3787, 496, 6 }, { 3838, 474, 6 }, { 3843, 522, 6 }, { 3888, 568, 6 }, { 3887, 550, 5 }, { 3871, 531, 4 }, { 3847, 491, 4 }, { 3768, 471, 4 }, { 3850, 428, 6 }, { 3884, 384, 5 }, { 3892, 373, 7 }, { 3936, 378, 7 }, { 3908, 414, 7 }, { 3931, 427, 7 }, { 3957, 420, 7 }, { 3941, 375, 7 }, { 3812, 251, 6 }, { 3889, 214, 6 }, { 3812, 240, 5 }, { 3841, 199, 5 }, { 3931, 136, 5 }, { 3931, 175, 7 }, { 3964, 165, 7 }, { 3982, 184, 7 }, { 4015, 160, 7 }, { 3946, 338, 7 }, { 3950, 313, 7 }, { 3986, 300, 7 }, { 4021, 327, 7 }, { 4073, 291, 7 }, { 4131, 265, 7 }, { 4183, 271, 7 }, { 4159, 311, 7 }, { 4198, 331, 7 }, { 4209, 364, 7 }, { 4132, 376, 7 }, { 4113, 339, 7 }, { 4142, 339, 6 }, { 4120, 317, 5 }, { 4175, 344, 5 }, { 4107, 359, 5 }, { 4166, 330, 4 }, { 4199, 419, 4 }, { 4215, 391, 6 }, { 4218, 256, 6 }, { 4128, 221, 6 }, { 4200, 225, 5 }, { 4181, 230, 4 }, { 4210, 280, 4 }, { 4200, 253, 4 }, { 4118, 242, 4 }, { 4056, 237, 5 }, { 4016, 233, 5 }, { 3980, 251, 5 }, { 3955, 269, 4 }, { 3994, 347, 4 }, { 3988, 382, 4 }, { 4030, 413, 4 }, { 4061, 439, 4 }, { 4087, 478, 4 }, { 4059, 444, 3 }, { 4081, 379, 3 }, { 4058, 387, 2 }, { 4101, 378, 2 }, { 4111, 390, 1 }, { 4009, 440, 5 }, { 4008, 411, 6 }, { 4016, 376, 6 }, { 4046, 358, 5 }, { 3986, 342, 4 }, { 3955, 394, 6 }, { 3963, 335, 6 }, { 3910, 548, 7 }, { 3969, 579, 7 }, { 4003, 530, 7 }, { 4032, 653, 7 }, { 4101, 644, 7 }, { 4191, 631, 5 }, { 4119, 598, 5 }, { 4133, 610, 4 }, { 4078, 570, 4 }, { 4051, 620, 4 }, { 4025, 549, 4 }, { 4013, 556, 5 }, { 4006, 610, 5 }, { 4104, 554, 5 }, { 4086, 541, 6 }, { 4022, 505, 7 }, { 4073, 525, 7 }, { 4134, 495, 7 }, { 4081, 534, 7 }, { 4149, 526, 7 }, { 4158, 475, 6 }, { 4176, 463, 4 }, { 4116, 416, 4 }, { 4132, 415, 3 }, { 4109, 446, 3 }, { 4143, 447, 3 }, { 4173, 449, 3 }, { 4179, 418, 3 }, { 4193, 491, 3 }, { 4183, 510, 4 }, { 4177, 519, 3 }, { 4241, 515, 5 }, { 4229, 538, 5 }, { 4242, 561, 6 }, { 4283, 543, 6 }, { 4126, 638, 6 }, { 4168, 675, 6 }, { 4111, 665, 6 }, { 4122, 673, 5 }, { 4083, 709, 5 }, { 4039, 692, 6 }, { 3990, 681, 6 }, { 4038, 665, 6 }, { 4016, 675, 5 }, { 4067, 706, 5 }, { 3968, 696, 5 }, { 3962, 713, 5 }, { 3975, 713, 6 }, { 3910, 678, 6 }, { 3891, 669, 6 }, { 3798, 697, 6 }, { 3748, 758, 6 }, { 3827, 765, 6 }, { 4179, 695, 7 }, { 4129, 755, 7 }, { 4088, 783, 7 }, { 4104, 812, 7 }, { 4120, 826, 7 }, { 4125, 842, 7 }, { 4077, 739, 7 }, { 4042, 777, 7 }, { 4033, 735, 7 }, { 3993, 732, 7 }, { 3959, 770, 7 }, { 3949, 815, 7 }, { 3953, 835, 7 }, { 3986, 806, 7 }, { 4010, 787, 7 }, { 3960, 851, 7 }, { 3933, 898, 7 }, { 3887, 893, 6 }, { 3934, 872, 6 }, { 3941, 849, 5 }, { 3989, 845, 6 }, { 4011, 841, 6 }, { 4066, 836, 6 }, { 4071, 863, 6 }, { 4078, 798, 6 }, { 4041, 794, 6 }, { 4027, 823, 5 }, { 4105, 847, 5 }, { 4179, 776, 5 }, { 4153, 762, 6 }, { 4152, 816, 6 }, { 4204, 787, 6 }, { 3784, 810, 7 }, { 3802, 772, 7 }, { 3743, 789, 7 }, { 3698, 817, 7 }, { 3698, 817, 7 }, { 3686, 840, 7 }, { 3742, 848, 6 }, { 3781, 838, 6 }, { 3771, 889, 6 }, { 3706, 851, 5 }, { 3766, 842, 5 }, { 3798, 901, 5 }, { 3834, 924, 5 }, { 3816, 892, 4 }
}

local COOLDOWN_STORAGE = 6500
local COOLDOWN = 3 * 60

--[[
 -- Berries
  ]]
local BERRY_IDS = {
    FIRST = 0, -- Don't touch this
    CHERI = 1,
    CHESTO = 2,
    PECHA = 3,
    RAWST = 4,
    ASPEAR = 5,
    LEPPA = 6,
    ORAN = 7,
    PERSIM = 8,
    LUM = 9,
    SITRUS = 10,
    LAST = 11 -- Don't touch this
}

local BERRY_BY_ITEMID = {
    [13182] = BERRY_IDS.CHERI,
    [13183] = BERRY_IDS.CHESTO,
    [13184] = BERRY_IDS.PECHA,
    [13185] = BERRY_IDS.RAWST,
    [14766] = BERRY_IDS.ASPEAR,
    [13186] = BERRY_IDS.LEPPA,
    [14767] = BERRY_IDS.ORAN,
    [14768] = BERRY_IDS.PERSIM,
    [14769] = BERRY_IDS.LUM,
    [14770] = BERRY_IDS.SITRUS,
}

local BERRIES = {
    [BERRY_IDS.CHERI] = {
        onUse = function(cid)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_PARALYSIS)
        end,
        canUse = function(cid)
            return getCreatureStatus(cid, CREATURE_STATUS_PARALYSIS)
        end
    },
    [BERRY_IDS.CHESTO] = {
        onUse = function(cid)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_SLEEP)
        end,
        canUse = function(cid)
            return getCreatureStatus(cid, CREATURE_STATUS_SLEEP)
        end
    },
    [BERRY_IDS.PECHA] = {
        onUse = function(cid)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_POISON)
        end,
        canUse = function(cid)
            return getCreatureStatus(cid, CREATURE_STATUS_POISON)
        end
    },
    [BERRY_IDS.RAWST] = {
        onUse = function(cid)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_BURN)
        end,
        canUse = function(cid)
            return getCreatureStatus(cid, CREATURE_STATUS_BURN)
        end
    },
    [BERRY_IDS.ASPEAR] = {
        onUse = function(cid)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_FREEZE)
        end,
        canUse = function(cid)
            return getCreatureStatus(cid, CREATURE_STATUS_FREEZE)
        end
    },
    [BERRY_IDS.LEPPA] = {
        onUse = function(cid)
            doCreatureAddMana(getCreatureMaster(cid), 200, false)
        end,
        canUse = function(cid)
            return not isPokemonWild(cid)
        end
    },
    [BERRY_IDS.ORAN] = {
        onUse = function(cid)
            doCreatureAddHealth(cid,
                (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.GLUTTONY, nil) and 4000 or 2000), false)
        end,
        canUse = function(cid)
            return getCreatureHealth(cid) < getCreatureMaxHealth(cid)
        end
    },
    [BERRY_IDS.PERSIM] = {
        onUse = function(cid)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_CONFUSION)
        end,
        canUse = function(cid)
            return getCreatureStatus(cid, CREATURE_STATUS_CONFUSION)
        end
    },
    [BERRY_IDS.LUM] = {
        onUse = function(cid)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_BURN)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_FREEZE)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_PARALYSIS)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_POISON)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_SLEEP)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_CONFUSION)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_LOWACCURACY)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_INSOMNIA)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_FLINCH)
            doCreatureRemoveStatus(cid, CREATURE_STATUS_BADPOISON)
        end,
        canUse = function(cid)
            return getCreatureStatus(cid, CREATURE_STATUS_BURN) or
                    getCreatureStatus(cid, CREATURE_STATUS_FREEZE) or
                    getCreatureStatus(cid, CREATURE_STATUS_PARALYSIS) or
                    getCreatureStatus(cid, CREATURE_STATUS_POISON) or
                    getCreatureStatus(cid, CREATURE_STATUS_SLEEP) or
                    getCreatureStatus(cid, CREATURE_STATUS_CONFUSION) or
                    getCreatureStatus(cid, CREATURE_STATUS_LOWACCURACY) or
                    getCreatureStatus(cid, CREATURE_STATUS_INSOMNIA) or
                    getCreatureStatus(cid, CREATURE_STATUS_FLINCH) or
                    getCreatureStatus(cid, CREATURE_STATUS_BADPOISON)
        end
    },
    [BERRY_IDS.SITRUS] = {
        onUse = function(cid)
            doCreatureAddHealth(cid,
                (doPokemonSpecialAbilityCheck(cid, POKEMON_SPECIAL_ABILITY_IDS.GLUTTONY, nil) and 8000 or 4000), false)
        end,
        canUse = function(cid)
            return getCreatureHealth(cid) < getCreatureMaxHealth(cid)
        end
    },
}

function onCreatureUseBerry(cid, item, fromPosition, itemEx, toPosition, fromWild --[[ = nil ]])
    local berry = BERRY_BY_ITEMID[fromWild and item or item.itemid]
    if (not berry) then
        if (not fromWild) then
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        end
        log(LOG_TYPES.ERROR, "onCreatureUseBerry - Calling function with unknown itemid", getCreatureName(cid), item, fromPosition, itemEx, toPosition)
        return false
    end

    if (not fromWild and not isPremium(cid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUNEEDPREMIUMACCOUNT)
        return false
    end

    local cooldown = COOLDOWN - (os.time() - getCreatureStorage(cid, COOLDOWN_STORAGE))
    if (cooldown > 0) then
        if (not fromWild) then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You must wait %s to use %s %s again."), table.concat(string.timediff(cooldown, cid)), getItemArticleById(item.itemid), getItemNameById(item.itemid)))
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        end
        return false
    end

    if (not fromWild and (not isPokemonOnline(cid) or getPlayerFrontierIsland(cid))) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local pokemon = fromWild and cid or getPlayerPokemon(cid)
    if (not fromWild and not getSamePosition(getCreaturePosition(pokemon), toPosition)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    if (not fromWild and getDistanceBetween(getCreaturePosition(cid), toPosition) > 4) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
        return false
    end

    if (not BERRIES[berry].canUse(pokemon)) then
        if (not fromWild) then
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        end
        return false
    end

    if (fromWild and getMonsterLevel(pokemon) < 20) then
        return false
    end

    if (not doPokemonSpecialAbilityCheck(pokemon, POKEMON_SPECIAL_ABILITY_IDS.STICKY_HOLD, nil)) then
        local specs = getSpectators(toPosition, 7, 7, false)
        for _, spec in pairs(specs) do
            if (isMonster(spec) and not isFriend(pokemon, spec) and
                    doPokemonSpecialAbilityCheck(spec, POKEMON_SPECIAL_ABILITY_IDS.PICKUP, nil)) then
                doSendAnimatedText(getCreaturePosition(spec), "PICKUP!", COLOR_WHITE)
                pokemon = spec
                break
            end
        end
    end

    BERRIES[berry].onUse(pokemon)
    doSendMagicEffect(toPosition, EFFECT_GREEN_BUFF)
    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    doSendAnimatedText(toPosition, "BERRY", table.random({
        COLOR_GREEN, COLOR_TEAL, COLOR_LIGHTGREEN,
        COLOR_LIGHTBLUE, COLOR_DARKPURPLE, COLOR_ORANGE
    }))
    if (not fromWild) then
        doRemoveItem(item.uid, 1)
    end
    doCreatureSetStorage(cid, COOLDOWN_STORAGE, os.time())
    return true
end

--[[
-- Trees
 ]]
local TREE_BY_ITEMID = {
    [13171] = BERRY_IDS.CHERI,
    [13172] = BERRY_IDS.CHERI,
    [13173] = BERRY_IDS.CHERI,
    [13187] = BERRY_IDS.CHERI,
    [28944] = BERRY_IDS.CHERI,
    [28945] = BERRY_IDS.CHERI,
    [28946] = BERRY_IDS.CHERI,
    [28947] = BERRY_IDS.CHERI,
    [13196] = BERRY_IDS.CHESTO,
    [13188] = BERRY_IDS.CHESTO,
    [13189] = BERRY_IDS.CHESTO,
    [13200] = BERRY_IDS.CHESTO,
    [28940] = BERRY_IDS.CHESTO,
    [28941] = BERRY_IDS.CHESTO,
    [28942] = BERRY_IDS.CHESTO,
    [28943] = BERRY_IDS.CHESTO,
    [13197] = BERRY_IDS.PECHA,
    [13190] = BERRY_IDS.PECHA,
    [13191] = BERRY_IDS.PECHA,
    [13201] = BERRY_IDS.PECHA,
    [28936] = BERRY_IDS.PECHA,
    [28937] = BERRY_IDS.PECHA,
    [28938] = BERRY_IDS.PECHA,
    [28939] = BERRY_IDS.PECHA,
    [13198] = BERRY_IDS.RAWST,
    [13192] = BERRY_IDS.RAWST,
    [13193] = BERRY_IDS.RAWST,
    [13202] = BERRY_IDS.RAWST,
    [28928] = BERRY_IDS.RAWST,
    [28929] = BERRY_IDS.RAWST,
    [28930] = BERRY_IDS.RAWST,
    [28931] = BERRY_IDS.RAWST,
    [14771] = BERRY_IDS.ASPEAR,
    [14772] = BERRY_IDS.ASPEAR,
    [14773] = BERRY_IDS.ASPEAR,
    [14774] = BERRY_IDS.ASPEAR,
    [28952] = BERRY_IDS.ASPEAR,
    [28953] = BERRY_IDS.ASPEAR,
    [28954] = BERRY_IDS.ASPEAR,
    [28955] = BERRY_IDS.ASPEAR,
    [13199] = BERRY_IDS.LEPPA,
    [13194] = BERRY_IDS.LEPPA,
    [13195] = BERRY_IDS.LEPPA,
    [13203] = BERRY_IDS.LEPPA,
    [28932] = BERRY_IDS.LEPPA,
    [28933] = BERRY_IDS.LEPPA,
    [28934] = BERRY_IDS.LEPPA,
    [28935] = BERRY_IDS.LEPPA,
    [14775] = BERRY_IDS.ORAN,
    [14776] = BERRY_IDS.ORAN,
    [14777] = BERRY_IDS.ORAN,
    [14778] = BERRY_IDS.ORAN,
    [28920] = BERRY_IDS.ORAN,
    [28921] = BERRY_IDS.ORAN,
    [28922] = BERRY_IDS.ORAN,
    [28923] = BERRY_IDS.ORAN,
    [14779] = BERRY_IDS.PERSIM,
    [14780] = BERRY_IDS.PERSIM,
    [14781] = BERRY_IDS.PERSIM,
    [14782] = BERRY_IDS.PERSIM,
    [28916] = BERRY_IDS.PERSIM,
    [28917] = BERRY_IDS.PERSIM,
    [28918] = BERRY_IDS.PERSIM,
    [28919] = BERRY_IDS.PERSIM,
    [14783] = BERRY_IDS.LUM,
    [14784] = BERRY_IDS.LUM,
    [14785] = BERRY_IDS.LUM,
    [14786] = BERRY_IDS.LUM,
    [28924] = BERRY_IDS.LUM,
    [28925] = BERRY_IDS.LUM,
    [28926] = BERRY_IDS.LUM,
    [28927] = BERRY_IDS.LUM,
    [14787] = BERRY_IDS.SITRUS,
    [14788] = BERRY_IDS.SITRUS,
    [14789] = BERRY_IDS.SITRUS,
    [14790] = BERRY_IDS.SITRUS,
    [28948] = BERRY_IDS.SITRUS,
    [28949] = BERRY_IDS.SITRUS,
    [28950] = BERRY_IDS.SITRUS,
    [28951] = BERRY_IDS.SITRUS,
}

local TREES = {
    [BERRY_IDS.CHERI] = {
        berryItemid = 13182,
        berryMaxCount = 5,
        stages = {
            [804] = 13171,
            [13171] = 13172,
            [13172] = 13173,
            --
            [28956] = 13171,
--            [28956] = 28944,
--            [28944] = 28945,
--            [28945] = 28946
        },
        lastTreeStage = 13173,
        fruitStages = {13173, 28946},
        --stageEmpty = 13187,
        stageInterval = math.ceil((24 * 60 * 60) / 3),
    },
    [BERRY_IDS.CHESTO] = {
        berryItemid = 13183,
        berryMaxCount = 5,
        stages = {
            [804] = 13196,
            [13196] = 13188,
            [13188] = 13189,
            --
            [28956] = 13196,
--            [28956] = 28940,
--            [28940] = 28941,
--            [28941] = 28942
        },
        lastTreeStage = 13189,
        fruitStages = {13189, 28942},
        --stageEmpty = 13187,
        stageInterval = math.ceil((24 * 60 * 60) / 3),
    },
    [BERRY_IDS.PECHA] = {
        berryItemid = 13184,
        berryMaxCount = 5,
        stages = {
            [804] = 13197,
            [13197] = 13190,
            [13190] = 13191,
            --
            [28956] = 13197,
--            [28956] = 28936,
--            [28936] = 28937,
--            [28937] = 28938
        },
        lastTreeStage = 13191,
        fruitStages = {13191, 28938},
        --stageEmpty = 13187,
        stageInterval = math.ceil((24 * 60 * 60) / 3),
    },
    [BERRY_IDS.RAWST] = {
        berryItemid = 13185,
        berryMaxCount = 5,
        stages = {
            [804] = 13198,
            [13198] = 13192,
            [13192] = 13193,
            --
            [28956] = 13198,
--            [28956] = 28928,
--            [28928] = 28929,
--            [28929] = 28930
        },
        lastTreeStage = 13193,
        fruitStages = {13193, 28930},
        --stageEmpty = 13187,
        stageInterval = math.ceil((24 * 60 * 60) / 3),
    },
    [BERRY_IDS.ASPEAR] = {
        berryItemid = 14766,
        berryMaxCount = 5,
        stages = {
            [804] = 14771,
            [14771] = 14772,
            [14772] = 14773,
            --
            [28956] = 14771,
--            [28956] = 28952,
--            [28952] = 28953,
--            [28953] = 28954
        },
        lastTreeStage = 14773,
        fruitStages = {14773, 28954},
        --stageEmpty = 13187,
        stageInterval = math.ceil((24 * 60 * 60) / 3),
    },
    [BERRY_IDS.LEPPA] = {
        berryItemid = 13186,
        berryMaxCount = 5,
        stages = {
            [804] = 13199,
            [13199] = 13194,
            [13194] = 13195,
            --
            [28956] = 13199,
--            [28956] = 28932,
--            [28932] = 28933,
--            [28933] = 28934
        },
        lastTreeStage = 13195,
        fruitStages = {13195, 28934},
        --stageEmpty = 13187,
        stageInterval = math.ceil((36 * 60 * 60) / 3),
    },
    [BERRY_IDS.ORAN] = {
        berryItemid = 14767,
        berryMaxCount = 5,
        stages = {
            [804] = 14775,
            [14775] = 14776,
            [14776] = 14777,
            --
            [28956] = 14775,
--            [28956] = 28920,
--            [28920] = 28921,
--            [28921] = 28922
        },
        lastTreeStage = 14777,
        fruitStages = {14777, 28922},
        --stageEmpty = 13187,
        stageInterval = math.ceil((36 * 60 * 60) / 3),
    },
    [BERRY_IDS.PERSIM] = {
        berryItemid = 14768,
        berryMaxCount = 5,
        stages = {
            [804] = 14779,
            [14779] = 14780,
            [14780] = 14781,
            --
            [28956] = 14779,
--            [28956] = 28916,
--            [28916] = 28917,
--            [28917] = 28918
        },
        lastTreeStage = 14781,
        fruitStages = {14781, 28918},
        --stageEmpty = 13187,
        stageInterval = math.ceil((36 * 60 * 60) / 3),
    },
    [BERRY_IDS.LUM] = {
        berryItemid = 14769,
        berryMaxCount = 3,
        stages = {
            [804] = 14783,
            [14783] = 14784,
            [14784] = 14785,
            --
            [28956] = 14783,
--            [28956] = 28924,
--            [28924] = 28925,
--            [28925] = 28926
        },
        lastTreeStage = 14785,
        fruitStages = {14785, 28926},
        --stageEmpty = 13187,
        stageInterval = math.ceil((72 * 60 * 60) / 3),
    },
    [BERRY_IDS.SITRUS] = {
        berryItemid = 14770,
        berryMaxCount = 3,
        stages = {
            [804] = 14787,
            [14787] = 14788,
            [14788] = 14789,
            --
            [28956] = 14787,
--            [28956] = 28948,
--            [28948] = 28949,
--            [28949] = 28950
        },
        lastTreeStage = 14789,
        fruitStages = {14789, 28950},
        --stageEmpty = 13187,
        stageInterval = math.ceil((48 * 60 * 60) / 3),
    },
}

local function getBerryTreeNextStage(itemid)
    local tree = TREE_BY_ITEMID[itemid]
    if (tree) then
        return TREES[tree].stages[itemid]
    end
    return nil
end

local function doBerryTreeGrow(itemid, position)
    local query = "DELETE FROM `berry_trees` WHERE positionx='" .. position.x ..
            "' and positiony='" .. position.y .. "' and positionz='" .. position.z .. "';"
    if (not db.executeQuery(query)) then
        log(LOG_TYPES.ERROR, "doBerryTreeGrow - Can't query.", query)
    end

    local item = getTileItemById(position, itemid)
    if (isItem(item)) then
        local nextStage = getBerryTreeNextStage(itemid)
        if (nextStage) then
            doSendMagicEffect(position, EFFECT_ROOTS)
            doTransformItem(item.uid, nextStage)

            if (getBerryTreeNextStage(nextStage)) then
                local tree = TREES[TREE_BY_ITEMID[itemid]]
                addBerryTreeGrow(nextStage, position, tree.stageInterval)
            end
        end
    else
        log(LOG_TYPES.ERROR, "doBerryTreeGrow - Can't find item at position.", itemid, position)
    end
end

function addBerryTreeGrow(itemid, position, interval)
    local query = "INSERT INTO `berry_trees` (world_id, positionx, positiony, positionz, itemid, growdate) VALUES ("
    query = query .. getConfigValue("worldId") .. ", "
    query = query .. position.x .. ", "
    query = query .. position.y .. ", "
    query = query .. position.z .. ", "
    query = query .. itemid .. ", "
    query = query .. os.time() + interval .. ");"
    if (db.executeQuery(query)) then
        addEvent(doBerryTreeGrow, interval * 1000, itemid, position)
    end
end

function onCreatureUseBerryTree(cid, item, fromPosition, itemEx, toPosition)
    local tree = TREE_BY_ITEMID[item.itemid]
    if (not tree) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        log(LOG_TYPES.ERROR, "onCreatureUseBerryTree - Calling function with unknown itemid", cid, item, fromPosition, itemEx, toPosition)
        return false
    end

    if (table.find(TREES[tree].fruitStages, item.itemid)) then -- Last stage
        local count = getRandom(1, TREES[tree].berryMaxCount)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You picked %sx %s."), count, getItemNameById(TREES[tree].berryItemid)))
        doPlayerAddItem(cid, TREES[tree].berryItemid, count, true)
        doSendMagicEffect(toPosition, EFFECT_ROOTS)
        doTransformItem(item.uid, LEAVES)

        local ground = getTileItemById(toPosition, FERTILE_GROUND[1]) -- Ugly > Only first Fertile Ground should be transformed
        if (isItem(ground)) then
            doTransformItem(ground.uid, RAW_GROUND)
        end
    end
end

--[[
local function spawnBerryTree()
    local pos, berry = table.random(BERRY_TREE_SPAWNS), getRandom(BERRY_IDS.FIRST + 1, BERRY_IDS.LAST - 1)
    local item = doCreateItem(TREES[berry].stages[#TREES[berry].stages], 1, pos)

    if (not item) then
        log(LOG_TYPES.WARNING, "spawnBerryTree - Can't create item on position.", pos, berry)
        return
    end

    doSendMagicEffect(pos, EFFECT_ROOTS)
end
]]
function startBerryTrees() -- Called when server start
    local dbResult = db.getResult("SELECT `growdate`, `itemid`, `positionx`, `positiony`, `positionz` FROM `berry_trees` WHERE `world_id` = " .. getConfigValue("worldId") .. ";")
    if (dbResult:getID() ~= -1) then
        repeat
            local interval = dbResult:getDataInt("growdate") - os.time()
            interval = interval > 0 and interval * 1000 or 1
            addEvent(doBerryTreeGrow, interval, dbResult:getDataInt("itemid"),
                {
                    x = dbResult:getDataInt("positionx"),
                    y = dbResult:getDataInt("positiony"),
                    z = dbResult:getDataInt("positionz")
                })
        until not dbResult:next()
        dbResult:free()
    end

    local pos, berry = table.random(BERRY_TREE_SPAWNS), getRandom(BERRY_IDS.FIRST + 1, BERRY_IDS.LAST - 1)
    local item = doCreateItem(TREES[berry].lastTreeStage, 1, { x = pos[1], y = pos[2], z = pos[3] })
    if (not item) then
        log(LOG_TYPES.WARNING, "spawnBerryTree - Can't create item on position.", pos[1], pos[2], pos[3], berry)
        return
    end
    doSendMagicEffect(pos, EFFECT_ROOTS)
end

--[[
-- Seeds
 ]]
local SEED_BY_ITEMID = {
    [13176] = BERRY_IDS.CHERI,
    [13177] = BERRY_IDS.CHESTO,
    [13178] = BERRY_IDS.PECHA,
    [13179] = BERRY_IDS.RAWST,
    [14791] = BERRY_IDS.ASPEAR,
    [13180] = BERRY_IDS.LEPPA,
    [14792] = BERRY_IDS.ORAN,
    [14793] = BERRY_IDS.PERSIM,
    [14794] = BERRY_IDS.LUM,
    [14795] = BERRY_IDS.SITRUS,
}

function onCreatureUseBerrySeed(cid, item, fromPosition, itemEx, toPosition)
    if (not table.find(FERTILE_GROUND, itemEx.itemid) or not getHouseFromPos(toPosition)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local seed = SEED_BY_ITEMID[item.itemid]
    if (not seed) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        log(LOG_TYPES.ERROR, "onCreatureUseBerrySeed - Calling function with unknown itemid", cid, item, fromPosition, itemEx, toPosition)
        return false
    end

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You planted %s %s, now you need wet this place for her bloom."), getItemArticleById(item.itemid), getItemNameById(item.itemid)))
    doSendMagicEffect(toPosition, EFFECT_ROOTS)
    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    doItemSetAttribute(itemEx.uid, ATTRIBUTES.SEED, seed)
    doRemoveItem(item.uid, 1)
    doPlayerAddStatistic(cid, PLAYER_STATISTIC_IDS.PLANT_BERRY, 1)
    return true
end

--[[
-- Watering Can Full
 ]]
local WATERING_CANS = {
    -- Full -> Empty
    [13175] = 13174,
    [13311] = 13310,
    -- Empty -> Full
    [13174] = 13175,
    [13311] = 13310
}

function onCreatureUseWateringCanFull(cid, item, fromPosition, itemEx, toPosition)
    -- Sudowoodo
    if (itemEx.itemid == 18648) then
        doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
        doSendMagicEffect(toPosition, EFFECT_SPLASH)
        doRemoveItem(itemEx.uid)
        local m = doCreateMonster("Sudowoodo", toPosition)
        if (m) then
            doCreatureSay(m, "Grrr!", TALKTYPE_MONSTER_YELL)
            doTransformItem(item.uid, WATERING_CANS[item.itemid])
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have found a Sudowoodo!")
        end

        return true
    end

    if (not table.find(FERTILE_GROUND, itemEx.itemid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    local seed = getItemAttribute(itemEx.uid, ATTRIBUTES.SEED)
    if (not seed or seed == -1) then
        doPlayerSendCancel(cid, "There is no seed there.")
        return false
    end

    local tree = TREES[seed]
    if (not tree) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doSendMagicEffect(toPosition, EFFECT_SPLASH)
    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_BUBBLES)
    doItemSetAttribute(itemEx.uid, ATTRIBUTES.SEED, -1)
    doCreateItem(tree.stages[itemEx.itemid], 1, toPosition)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "The soil was wet. The berry tree is growing now, come back later.")
    doTransformItem(item.uid, WATERING_CANS[item.itemid])
    addBerryTreeGrow(tree.stages[itemEx.itemid], toPosition, tree.stageInterval)
    return true
end

--[[
-- Watering Can Empty
 ]]
function onCreatureUseWateringCanEmpty(cid, item, fromPosition, itemEx, toPosition)
    if (not isInArray(WATER_IDS, itemEx.itemid) and not isInArray(DRAW_WELL, itemEx.itemid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    elseif (getDistanceBetween(getCreaturePosition(cid), toPosition) > 2) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)
        return false
    end

    doSendMagicEffect(toPosition, EFFECT_SPLASH)
    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    doTransformItem(item.uid, WATERING_CANS[item.itemid])
    return true
end


--[[
-- Hoe
 ]]
function onCreatureUseHoe(cid, item, fromPosition, itemEx, toPosition)
    if (not getHouseFromPos(toPosition) or itemEx.itemid ~= RAW_GROUND) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false
    end

    doSendMagicEffect(toPosition, EFFECT_SCRATCH)
    doSendDistanceShoot(getCreaturePosition(cid), toPosition, PROJECTILE_GRAVEL)
    doTransformItem(itemEx.uid, FERTILE_GROUND[1])
    return true
end

-- TODO review config

function doPlayerResetBerryCooldown(cid)
    doCreatureSetStorage(cid, COOLDOWN_STORAGE, nil)
end