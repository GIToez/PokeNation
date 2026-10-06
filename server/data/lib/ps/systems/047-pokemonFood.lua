if (PokemonFood) then
    return
end

PokemonFood = {}

-- Health
local health1 = createConditionObject(CONDITION_REGENERATION, 10 * 60 * 1000)
setConditionParam(health1, CONDITION_PARAM_HEALTHGAIN, 5)
setConditionParam(health1, CONDITION_PARAM_HEALTHTICKS, 2000)

local health2 = createConditionObject(CONDITION_REGENERATION, 13 * 60 * 1000)
setConditionParam(health2, CONDITION_PARAM_HEALTHGAIN, 10)
setConditionParam(health2, CONDITION_PARAM_HEALTHTICKS, 2000)

local health3 = createConditionObject(CONDITION_REGENERATION, 15 * 60 * 1000)
setConditionParam(health3, CONDITION_PARAM_HEALTHGAIN, 15)
setConditionParam(health3, CONDITION_PARAM_HEALTHTICKS, 2000)

local health4 = createConditionObject(CONDITION_REGENERATION, 20 * 60 * 1000)
setConditionParam(health4, CONDITION_PARAM_HEALTHGAIN, 20)
setConditionParam(health4, CONDITION_PARAM_HEALTHTICKS, 2000)

local health5 = createConditionObject(CONDITION_REGENERATION, 30 * 60 * 1000)
setConditionParam(health5, CONDITION_PARAM_HEALTHGAIN, 20)
setConditionParam(health5, CONDITION_PARAM_HEALTHTICKS, 2000)

local gaiaHealth = createConditionObject(CONDITION_REGENERATION, 30 * 60 * 1000)
setConditionParam(gaiaHealth, CONDITION_PARAM_HEALTHGAIN, 25)
setConditionParam(gaiaHealth, CONDITION_PARAM_HEALTHTICKS, 2000)

-- Energy
local energy1 = createConditionObject(CONDITION_REGENERATION, 10 * 60 * 1000, false, CONDITION_SUBID.REGENERATION.ENERGY)
setConditionParam(energy1, CONDITION_PARAM_MANAGAIN, 10)
setConditionParam(energy1, CONDITION_PARAM_MANATICKS, 2000)

local energy2 = createConditionObject(CONDITION_REGENERATION, 13 * 60 * 1000, false, CONDITION_SUBID.REGENERATION.ENERGY)
setConditionParam(energy2, CONDITION_PARAM_MANAGAIN, 13)
setConditionParam(energy2, CONDITION_PARAM_MANATICKS, 2000)

local energy3 = createConditionObject(CONDITION_REGENERATION, 15 * 60 * 1000, false, CONDITION_SUBID.REGENERATION.ENERGY)
setConditionParam(energy3, CONDITION_PARAM_MANAGAIN, 17)
setConditionParam(energy3, CONDITION_PARAM_MANATICKS, 2000)

local energy4 = createConditionObject(CONDITION_REGENERATION, 20 * 60 * 1000, false, CONDITION_SUBID.REGENERATION.ENERGY)
setConditionParam(energy4, CONDITION_PARAM_MANAGAIN, 20)
setConditionParam(energy4, CONDITION_PARAM_MANATICKS, 2000)

local energy5 = createConditionObject(CONDITION_REGENERATION, 30 * 60 * 1000, false, CONDITION_SUBID.REGENERATION.ENERGY)
setConditionParam(energy5, CONDITION_PARAM_MANAGAIN, 20)
setConditionParam(energy5, CONDITION_PARAM_MANATICKS, 2000)

local gaiaEnergy = createConditionObject(CONDITION_REGENERATION, 30 * 60 * 1000, false, CONDITION_SUBID.REGENERATION.ENERGY)
setConditionParam(gaiaEnergy, CONDITION_PARAM_MANAGAIN, 25)
setConditionParam(gaiaEnergy, CONDITION_PARAM_MANATICKS, 2000)

local foods = {
    [12202] = {hp = health1, mp = energy2, msg = "Crunch"}, -- Churros
    [12203] = {hp = health1, mp = energy2, msg = "Crunch"}, -- Churros
    [12204] = {hp = health1, mp = energy2, msg = "Crunch"}, -- Churros
    [12205] = {hp = health1, mp = energy3, msg = "Crunch"}, -- Burguer
    [12206] = {hp = health1, mp = energy3, msg = "Crunch"}, -- Potato Chip
    [12207] = {hp = health1, mp = energy1, msg = "Crunch"}, -- Hot Dog
    [12208] = {hp = health3, mp = energy3, msg = "Crunch"}, -- Sushi
    [12210] = {hp = health2, mp = energy2, msg = "Crunch"}, -- Pizza
    [12211] = {hp = health1, mp = energy1, msg = "Gulp"}, -- Coconut
    [12212] = {hp = health1, mp = energy1, msg = "Gulp"}, -- Lemonade
    [2687] = {hp = health1, mp = energy1, msg = "Crunch"}, -- Cookie
    [13305] = {hp = health4, mp = energy4, msg = "Crunch"}, -- Lava Cookie
    [13820] = {hp = health1, mp = energy1, msg = "Crunch"}, -- Cookie
    [6569] = {hp = health2, mp = energy2, msg = "Crunch"}, -- Candy
    [6574] = {hp = health2, mp = energy4, msg = "Crunch"}, -- Chocolate Bar
    [7966] = {hp = health3, mp = energy3, msg = "Crunch"}, -- Birthday Cake
    [7372] = {hp = health2, mp = energy3, msg = "Crunch"}, -- ice cream cone (crispy chocolate chips)
    [7373] = {hp = health2, mp = energy3, msg = "Crunch"}, -- ice cream cone (yellow)
    [7374] = {hp = health2, mp = energy3, msg = "Crunch"}, -- ice cream cone (red)
    [7375] = {hp = health2, mp = energy3, msg = "Crunch"}, -- ice cream cone (chilly cherry)
    [7376] = {hp = health2, mp = energy3, msg = "Crunch"}, -- ice cream cone (green)
    [7377] = {hp = health2, mp = energy3, msg = "Crunch"}, -- ice cream cone (blue-barian)
    [2682] = {hp = health3, mp = energy3, msg = "Crunch"}, -- melon
    [2696] = {hp = health1, mp = energy2, msg = "Crunch"}, -- cheese
    [5097] = {hp = health1, mp = energy2, msg = "Crunch"}, -- mango
    [2673] = {hp = health1, mp = energy2, msg = "Crunch"}, -- pear
    [2674] = {hp = health1, mp = energy1, msg = "Crunch"}, -- red apple
    [2676] = {hp = health1, mp = energy2, msg = "Crunch"}, -- banana
    [2677] = {hp = health2, mp = energy2, msg = "Crunch"}, -- blueberry
    [8841] = {hp = health1, mp = energy1, msg = "Crunch"}, -- lemon
    [2680] = {hp = health1, mp = energy1, msg = "Crunch"}, -- strawberry
    [2675] = {hp = health1, mp = energy2, msg = "Crunch"}, -- orange
    [14464] = {hp = health2, mp = energy3, msg = "Crunch"}, -- onigiri
    [14470] = {hp = health1, mp = energy1, msg = "Crunch"}, -- bunch of winterberries
    [6501] = {hp = health4, mp = energy4, msg = "Crunch"}, -- Gingerbread Man
    [2688] = {hp = health4, mp = energy4, msg = "Crunch"}, -- Candy Cane
    [23596] = {hp = health4, mp = energy4, msg = "Gulp"}, -- Erika's juice flask
    [23574] = {hp = health4, mp = energy3, msg = "Crunch"}, -- cooked onigiri
    [25417] = {hp = health4, mp = energy4, msg = "Yum"}, -- blue jujube
    [25418] = {hp = health4, mp = energy4, msg = "Crunch"}, -- bluesky block
    [25419] = {hp = health4, mp = energy4, msg = "Crunch"}, -- chocolate block
    [25420] = {hp = health4, mp = energy4, msg = "Yum"}, -- green jujube
    [25421] = {hp = health4, mp = energy4, msg = "Crunch"}, -- mint block
    [25422] = {hp = health4, mp = energy4, msg = "Yum"}, -- red jujube
    [25423] = {hp = health4, mp = energy4, msg = "Crunch"}, -- vanilla block
    [25424] = {hp = health4, mp = energy4, msg = "Yum"}, -- yellow jujube
    [27936] = {hp = health5, mp = energy5, msg = "Yum"}, -- big anniversary cake
    [29130] = {hp = health5, mp = energy5, msg = "Yum"}, -- fresh fruit
}

PokemonFood.onUse = function(cid, item, fromPosition, itemEx, toPosition)
    local playerPosition = getCreaturePosition(cid)
    if (getDistanceBetween(playerPosition, toPosition) > 4) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_TOOFARAWAY)

    elseif (getSamePosition(playerPosition, toPosition)) then
        if (not hasCondition(cid, CONDITION_REGENERATION)) then
            doAddCondition(cid, (doMasteryAdvantageCheck(cid, MASTERY_ADVANTAGES.FOOD_REGENERATION) and
                    gaiaHealth or foods[item.itemid].hp))
            doCreatureSay(cid, foods[item.itemid].msg, TALKTYPE_ORANGE_1)
            doRemoveItem(item.uid, 1)
        else
            doPlayerSendCancel(cid, "You are full.")
        end

    else
        local topCreature = getTopCreature(toPosition).uid
        if (not isCreature(topCreature)) then
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)

        elseif (getCreatureMaster(topCreature) == cid) then
            if (not hasCondition(topCreature, CONDITION_REGENERATION) or
                    not hasCondition(cid, CONDITION_REGENERATION, CONDITION_SUBID.REGENERATION.ENERGY)) then
                if (doMasteryAdvantageCheck(cid, MASTERY_ADVANTAGES.FOOD_REGENERATION)) then
                    doAddCondition(topCreature, gaiaHealth)
                    doAddCondition(cid, gaiaEnergy)
                else
                    doAddCondition(topCreature, foods[item.itemid].hp)
                    doAddCondition(cid, foods[item.itemid].mp)
                end

                doCreatureSay(topCreature, foods[item.itemid].msg, TALKTYPE_ORANGE_1)
                doSendDistanceShoot(playerPosition, toPosition, PROJECTILE_GRAVEL)
                doRemoveItem(item.uid, 1)

            else
                doPlayerSendCancel(cid, "Your Pokemon is full.")
            end

        else
            doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        end
    end
    return true
end
