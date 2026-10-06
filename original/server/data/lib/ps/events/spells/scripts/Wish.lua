local SKILL_NAME = "Wish"
local INTERVAL = 2000

function onTargetCreature_Wish(cid, target)
	doCreatureAddHealth(cid, math.ceil((getCreatureMaxHealth(cid) / 2)))
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Wish")
setCombatParam(combat, COMBAT_PARAM_EFFECT, getPokemonSkillEffect(SKILL_NAME))
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)

local function doSpell(cid)
    if (isCreature(cid)) then
        doCombat(cid, combat, numberToVariant(cid))
    end
end

function onCastSpell(cid, var)
	addEvent(doSpell, INTERVAL, cid)
    return true
end
