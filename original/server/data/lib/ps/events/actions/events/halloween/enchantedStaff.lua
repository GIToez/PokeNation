local OUTFIT_GHOUL = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_GHOUL, {lookType = 18})

local OUTFIT_SKELETON = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_SKELETON, {lookType = 33})

local OUTFIT_DEMONSKELETON = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_DEMONSKELETON, {lookType = 37})

local OUTFIT_FIEND = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_FIEND, {lookType = 40})

local OUTFIT_GHOST = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_GHOST, {lookType = 48})

local OUTFIT_WITCH = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_WITCH, {lookType = 54})

local OUTFIT_MUMMY = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_MUMMY, {lookType = 65})

local OUTFIT_VAMPIRE = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_VAMPIRE, {lookType = 68})

local OUTFIT_CRYPTER = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_CRYPTER, {lookType = 100})

local OUTFIT_SKELETONPIRATE = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_SKELETONPIRATE, {lookType = 195})

local OUTFIT_GHOSTPIRATE = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_GHOSTPIRATE, {lookType = 196})

local OUTFIT_GHOSTTWO = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_GHOSTTWO, {lookType = 235})

local OUTFIT_DEMON = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_DEMON, {lookType = 237})

local OUTFIT_CROW = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_CROW, {lookType = 246})

local OUTFIT_WEREWOLF = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_WEREWOLF, {lookType = 308})

local OUTFIT_ZOMBIE = createConditionObject(CONDITION_OUTFIT, -1,  nil, CONDITION_SUBID.OUTFITS.HALLOWEEN)
addOutfitCondition(OUTFIT_FIEND, {lookType = 311})

local CONDITIONS = {OUTFIT_DEMON, OUTFIT_FIEND, OUTFIT_ZOMBIE, OUTFIT_GHOUL, OUTFIT_SKELETON, OUTFIT_DEMONSKELETON, 
	OUTFIT_GHOST, OUTFIT_WITCH, OUTFIT_MUMMY, OUTFIT_VAMPIRE, OUTFIT_CRYPTER, OUTFIT_SKELETONPIRATE, OUTFIT_GHOSTPIRATE,
	OUTFIT_GHOSTTWO, OUTFIT_CROW, OUTFIT_WEREWOLF}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if (isCreature(itemEx.uid) and isPlayer(itemEx.uid) and not getPlayerMounted(itemEx.uid) and
            not isBiking(itemEx.uid)) then
		if (getCreatureCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.HALLOWEEN)) then
			doRemoveCondition(cid, CONDITION_OUTFIT, CONDITION_SUBID.OUTFITS.HALLOWEEN)
		end
		doAddCondition(itemEx.uid, table.random(CONDITIONS))
		doSendMagicEffect(getCreaturePosition(itemEx.uid), EFFECT_POISON_GAS_TWO)
		doRemoveItem(item.uid, 1)
        doPlayerAchievementCheck(cid, ACHIEVEMENT_IDS.HALLOWEEN_ENCHANTED_STAFF)
	else
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		doSendMagicEffect(getCreaturePosition(cid), EFFECT_POFF)
	end
	return true
end
