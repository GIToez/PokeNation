local ELEMENT_NORMAL = 0
local ELEMENT_FIGHT = 1
local ELEMENT_FLYING = 2
local ELEMENT_POISON = 3
local ELEMENT_GROUND = 4
local ELEMENT_ROCK = 5
local ELEMENT_BUG = 6
local ELEMENT_GHOST = 7
local ELEMENT_STEEL = 8
local ELEMENT_FIRE = 9
local ELEMENT_WATER = 10
local ELEMENT_GRASS = 11
local ELEMENT_ELECTRIC = 12
local ELEMENT_PSYCHIC = 13
local ELEMENT_ICE = 14
local ELEMENT_DRAGON = 15
local ELEMENT_DARK = 16
local ELEMENT_FAIRY = 17

local ELEMENT_NAMES = {
    [ELEMENT_NORMAL] = "Normal",
    [ELEMENT_FIGHT] = "Fight",
    [ELEMENT_FLYING] = "Flying",
    [ELEMENT_POISON] = "Poison",
    [ELEMENT_GROUND] = "Ground",
    [ELEMENT_ROCK] = "Rock",
    [ELEMENT_BUG] = "Bug",
    [ELEMENT_GHOST] = "Ghost",
    [ELEMENT_STEEL] = "Steel",
    [ELEMENT_FIRE] = "Fire",
    [ELEMENT_WATER] = "Water",
    [ELEMENT_GRASS] = "Grass",
    [ELEMENT_ELECTRIC] = "Electric",
    [ELEMENT_PSYCHIC] = "Psychic",
    [ELEMENT_ICE] = "Ice",
    [ELEMENT_DRAGON] = "Dragon",
    [ELEMENT_DARK] = "Dark",
    [ELEMENT_FAIRY] = "Fairy"
}

function getTypeNameById(id)
    return tr(ELEMENT_NAMES[tonumber(id)])
end

function getTypeIdByName(name)
    for typeId, typeName in pairs(ELEMENT_NAMES) do
        if (typeName == name or tr(typeName) == name) then
            return typeId
        end
    end
    return nil
end

local MOVE_CATEGORY = {
    PHYSICAL = 0,
    SPECIAL = 1,
    STATUS = 2
}

local MOVE_CATEGORY_NAMES = {
    [MOVE_CATEGORY.PHYSICAL] = "Physical",
    [MOVE_CATEGORY.SPECIAL] = "Special",
    [MOVE_CATEGORY.STATUS] = "Status",
}

function getMoveCategoryNameById(id)
    return tr(MOVE_CATEGORY_NAMES[tonumber(id)])
end