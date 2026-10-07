-- last used cooldown storage = 15437

SKILLS_TYPES = {
    TARGET = 0,
    AREA = 1,
    STATS = 2
}
--[[
local DAMAGE_TYPE_NORMAL = COMBAT_DEATHDAMAGE --COMBAT_NORMAL dark red
local DAMAGE_TYPE_FIGHTING = COMBAT_DEATHDAMAGE --COMBAT_FIGHT dark red
local DAMAGE_TYPE_FLYING = COMBAT_DEATHDAMAGE --COMBAT_FLYING dark red
local DAMAGE_TYPE_POISON = COMBAT_EARTHDAMAGE --COMBAT_POISON light green
local DAMAGE_TYPE_GROUND = COMBAT_DEATHDAMAGE --COMBAT_GROUND dark red
local DAMAGE_TYPE_ROCK = COMBAT_ENERGYDAMAGE --COMBAT_ROCK dark red
local DAMAGE_TYPE_BUG = COMBAT_DEATHDAMAGE --COMBAT_BUG dark red
local DAMAGE_TYPE_GHOST = COMBAT_DEATHDAMAGE --COMBAT_GHOST light blue
local DAMAGE_TYPE_STEEL = COMBAT_DEATHDAMAGE --COMBAT_STEEL dark red
local DAMAGE_TYPE_FIRE = COMBAT_FIREDAMAGE --COMBAT_FIRE orange
local DAMAGE_TYPE_WATER = COMBAT_DROWNDAMAGE --COMBAT_WATER light blue
local DAMAGE_TYPE_GRASS = COMBAT_DEATHDAMAGE --COMBAT_GRASS dark red
local DAMAGE_TYPE_ELECTRIC = COMBAT_HOLYDAMAGE --COMBAT_ELECTRIC yellow
local DAMAGE_TYPE_PSYCHIC = COMBAT_DEATHDAMAGE --COMBAT_PSYCHIC dark red
local DAMAGE_TYPE_ICE = COMBAT_ICEDAMAGE --COMBAT_ICE teal
local DAMAGE_TYPE_DRAGON = COMBAT_LIFEDRAIN --COMBAT_DRAGON red
local DAMAGE_TYPE_DARK = COMBAT_DEATHDAMAGE --COMBAT_DARK dark red
]]

DAMAGE_TYPE_NORMAL = COMBAT_NORMAL --COMBAT_DEATHDAMAGE --COMBAT_NORMAL dark red
DAMAGE_TYPE_FIGHTING = COMBAT_FIGHT --COMBAT_DEATHDAMAGE --COMBAT_FIGHT dark red
DAMAGE_TYPE_FLYING = COMBAT_FLYING --COMBAT_DEATHDAMAGE --COMBAT_FLYING dark red
DAMAGE_TYPE_POISON = COMBAT_POISON --COMBAT_EARTHDAMAGE --COMBAT_POISON light green
DAMAGE_TYPE_GROUND = COMBAT_GROUND --COMBAT_DEATHDAMAGE --COMBAT_GROUND dark red
DAMAGE_TYPE_ROCK = COMBAT_ROCK --COMBAT_ENERGYDAMAGE --COMBAT_ROCK dark red
DAMAGE_TYPE_BUG = COMBAT_BUG --COMBAT_DEATHDAMAGE --COMBAT_BUG dark red
DAMAGE_TYPE_GHOST = COMBAT_GHOST --COMBAT_DEATHDAMAGE --COMBAT_GHOST light blue
DAMAGE_TYPE_STEEL = COMBAT_STEEL --COMBAT_DEATHDAMAGE --COMBAT_STEEL dark red
DAMAGE_TYPE_FIRE = COMBAT_FIRE --COMBAT_FIREDAMAGE --COMBAT_FIRE orange
DAMAGE_TYPE_WATER = COMBAT_WATER --COMBAT_DROWNDAMAGE --COMBAT_WATER light blue
DAMAGE_TYPE_GRASS = COMBAT_GRASS --COMBAT_DEATHDAMAGE --COMBAT_GRASS dark red
DAMAGE_TYPE_ELECTRIC = COMBAT_ELECTRIC --COMBAT_HOLYDAMAGE --COMBAT_ELECTRIC yellow
DAMAGE_TYPE_PSYCHIC = COMBAT_PSYCHIC --COMBAT_DEATHDAMAGE --COMBAT_PSYCHIC dark red
DAMAGE_TYPE_ICE = COMBAT_ICE --COMBAT_ICEDAMAGE --COMBAT_ICE teal
DAMAGE_TYPE_DRAGON = COMBAT_DRAGON --COMBAT_LIFEDRAIN --COMBAT_DRAGON red
DAMAGE_TYPE_DARK = COMBAT_DARK --COMBAT_DEATHDAMAGE --COMBAT_DARK dark red
DAMAGE_TYPE_FAIRY = COMBAT_NORMAL

local SKILLS_CONFIG = {--[[ ["Psych Up"] = {description = "Psych Up copies both the positive and negative changes to the target's stats and replicates them onto the user.",
        category = MOVE_CATEGORY.STATUS, clientIconId = 16320, iconId = 0, dType = DAMAGE_TYPE_NORMAL, functionName = "PsychUp", type = SKILLS_TYPES.TARGET, requiredEnergy = 100, requiredLevel = 15, damage = 0, damageType = ELEMENT_NORMAL, effect = EFFECT_BIG_ENERGY_BALL, projectile = PROJECTILE_DARK_SHOT, maxDistance = 6, cooldownTime = 100, cooldownStorage = 15281}, ]]
}

MOVES = {}
dodirectory(PS_LIB_CONFIG_DIR .. "moves/")

--local out = {}
for name, move in pairs(MOVES) do
    SKILLS_CONFIG[name] = move

    --out[#out+1] = 'MOVES[#MOVES + 1] = {name = "'
    --out[#out+1] = name
    --out[#out+1] = '", iconItemId = '
    --out[#out+1] = move.clientIconId
    --out[#out+1] = '}\n'
    -- EXAMPLE MOVES[#MOVES + 1] = {name = "Swallow", iconItemId = 17586}

    --    out[#out + 1] = 'MOVES["' .. name .. '"] = "'
    --    out[#out + 1] = move.description
    --    out[#out + 1] = '",\n'
    -- EXAMPLE ["Avalanche"] = "Avalanche deals damage and has no secondary effect.",
end

--print(table.concat(out))

table.clear(MOVES)
MOVES = nil

for k, v in pairs(SKILLS_CONFIG) do -- TODO: This is ugly! With the new exhaust, with 25% less time, we need to lower the required energy by 25% also.
    if (v.requiredEnergy > 0) then
        v.requiredEnergy = math.ceil(v.requiredEnergy * 0.75)
    end
end

-- Get
function getPokemonSkillFunctionName(skillName)
    return SKILLS_CONFIG[skillName].functionName or ""
end

function getPokemonSkillType(skillName)
    return SKILLS_CONFIG[skillName].type or SKILL_TYPES.TARGET
end

function getPokemonSkillDType(skillName)
    return SKILLS_CONFIG[skillName].dType or DAMAGE_TYPE_NORMAL
end

function getPokemonSkillRequiredEnergy(skillName)
    return SKILLS_CONFIG[skillName].requiredEnergy or 10
end

function getPokemonSkillMaxDistance(skillName)
    return SKILLS_CONFIG[skillName].maxDistance or 1
end

function getPokemonSkillProjectile(skillName)
    return SKILLS_CONFIG[skillName].projectile or nil
end

function getPokemonSkillDamage(skillName)
    return SKILLS_CONFIG[skillName].damage or 0
end

function getPokemonSkillDamageText(skillName)
    if (SKILLS_CONFIG[skillName].damageText) then
        return SKILLS_CONFIG[skillName].damageText
    end

    local r = getPokemonSkillDamage(skillName)
    return r > 0 and r or "--"
end

function getPokemonSkillDamageType(skillName)
    return SKILLS_CONFIG[skillName].damageType or ELEMENT_NORMAL
end

function getPokemonSkillEffect(skillName)
    return SKILLS_CONFIG[skillName].effect or EFFECT_NOTHING
end

function getPokemonSkillAreaEffect(skillName)
    return SKILLS_CONFIG[skillName].areaEffect
end

function getPokemonSkillClientIconId(skillName)
    return SKILLS_CONFIG[skillName].clientIconId or 100
end

function getPokemonSkillCooldownTime(skillName)
    return SKILLS_CONFIG[skillName].cooldownTime or 10
end

function getPokemonSkillCooldownStorage(skillName)
    return SKILLS_CONFIG[skillName].cooldownStorage or 0
end

function getPokemonSkillCategory(skillName)
    return SKILLS_CONFIG[skillName].category or MOVE_CATEGORY.PHYSICAL
end

function getPokemonSkillCriticalChance(skillName) --[[ never 0 ... 100 always ]]
    return SKILLS_CONFIG[skillName].criticalChance or 10
end

function getPokemonSkillIgnoreAccuracy(skillName)
    return (SKILLS_CONFIG[skillName].ignoreAccuracy ~= nil and SKILLS_CONFIG[skillName].ignoreAccuracy) or false
end

function getPokemonSkillIgnoreEvasion(skillName)
    return (SKILLS_CONFIG[skillName].ignoreEvasion ~= nil and SKILLS_CONFIG[skillName].ignoreEvasion) or false
end

function getPokemonSkillDescription(skillName)
    return SKILLS_CONFIG[skillName].description
end

function getPokemonSkillBackProjectile(skillName)
    return SKILLS_CONFIG[skillName].backProjectile
end

function getPokemonSkillMakeContact(skillName)
    return SKILLS_CONFIG[skillName].makeContact or false
end

function getPokemonSkillMakeRecoil(skillName)
    return SKILLS_CONFIG[skillName].makeRecoil or false
end

function getPokemonSkillMakeSound(skillName)
    return SKILLS_CONFIG[skillName].makeSound or false
end

function getPokemonSkillWildBlock(skillName)
    if (not SKILLS_CONFIG[skillName]) then
        log(LOG_TYPES.ERROR, "getPokemonSkillWildBlock - Unknown move name.", skillName)
    end
    return SKILLS_CONFIG[skillName].wildBlock or false
end

function getPokemonSkillMakeIndirectDamage(skillName)
    return SKILLS_CONFIG[skillName].makeIndirectDamage or false
end

function getPokemonSkillMakeSelfdestruct(skillName)
    return SKILLS_CONFIG[skillName].makeSelfdestruct or false
end

function getPokemonSkillMakeHeal(skillName)
    return SKILLS_CONFIG[skillName].makeHeal or false
end

function getPokemonSkillMakePunch(skillName)
    return SKILLS_CONFIG[skillName].makePunch or false
end

function getPokemonSkillWildLevel(skillName)
    return SKILLS_CONFIG[skillName].wildLevel
end

function getPokemonSkillSketchable(skillName)
    if (SKILLS_CONFIG[skillName].sketchable ~= nil) then
        return SKILLS_CONFIG[skillName].sketchable
    end
    return true
end

function getPokemonSkillMimicable(skillName)
    if (SKILLS_CONFIG[skillName].mimicable ~= nil) then
        return SKILLS_CONFIG[skillName].mimicable
    end
    return true
end

function getPokemonSkillMakeJump(skillName)
    if (SKILLS_CONFIG[skillName].makeJump ~= nil) then
        return SKILLS_CONFIG[skillName].makeJump
    end
    return false
end

function getPokemonSkillExists(skillName)
    return SKILLS_CONFIG[skillName]
end

-- Is
function isPokemonSkillTypeTarget(skillName)
    return getPokemonSkillType(skillName) == SKILLS_TYPES.TARGET
end


--
local SKILL_BY_CLIENT_ICON_ID = {}
for name, move in pairs(SKILLS_CONFIG) do
    if (move.clientIconId > 0) then
        if (SKILL_BY_CLIENT_ICON_ID[move.clientIconId]) then
            log(LOG_TYPES.ERROR, "Skill - Duplicated clientIconId", name, move.clientIconId)
        end
        SKILL_BY_CLIENT_ICON_ID[move.clientIconId] = name
    end
end

function getPokemonSkillByClientIconId(clientIconId)
    return SKILL_BY_CLIENT_ICON_ID[clientIconId]
end

--[[function doGeneratePokemonSkillsLocalization(cid)
    local out = {}
    for name, move in pairs(SKILLS_CONFIG) do
        out[#out + 1] = '["' .. move.description .. '"] = "'
        out[#out + 1] = __L(cid, move.description)
        out[#out + 1] = '",\n'
        -- EXAMPLE ["Avalanche deals damage and has no secondary effect."] = "Avalanche infringe dano e não tem nenhum efeito secundário.",
    end

    print(table.concat(out))
end]]

--[[function doGeneratePokemonSkillsConfig()
    local out = {}
    for name, move in pairs(SKILLS_CONFIG) do
        out[#out + 1] = 'MOVES[#MOVES + 1] = {name = "'
        out[#out + 1] = name
        out[#out + 1] = '", iconItemId = '
        out[#out + 1] = move.clientIconId
        out[#out + 1] = '}\n'
        -- EXAMPLE MOVES[#MOVES + 1] = {name = "Swallow", iconItemId = 17586}

        --    out[#out + 1] = 'MOVES["' .. name .. '"] = "'
        --    out[#out + 1] = move.description
        --    out[#out + 1] = '",\n'
        -- EXAMPLE ["Avalanche"] = "Avalanche deals damage and has no secondary effect.",
    end

    print(table.concat(out))
end]]

--[[function doGeneratePokemonSkillsDescriptions()
    local out = {}
    for name, move in pairs(SKILLS_CONFIG) do
        out[#out + 1] = 'MOVES_DESCRIPTIONS["' .. name .. '"] = "'
        out[#out + 1] = move.description
        out[#out + 1] = '"\n'
        -- EXAMPLE ["Avalanche"] = "Avalanche deals damage and has no secondary effect.",
    end

    print(table.concat(out))
end]]

doCheckPokemonSkills()
--doCheckPokemonEggMoves()