-- local SKILL_NAME = "Sketch"
local PROJECTILES = {PROJECTILE_RED_SHOT, PROJECTILE_GREEN_SHOT, PROJECTILE_DARK_SHOT}
local EFFECTS = {EFFECT_FIREWORK_BLUE, EFFECT_FIREWORK_RED, EFFECT_FIREWORK_YELLOW}
local WILD_MOVES = {"Flamethrower", "Payback", "Iron Tail", "Wood Hammer", "Close Combat", "Fire Blast", "Solar Beam", "Petal Dance", "Blizzard", "Thrash", "Leaf Storm", "Giga Impact", "Frenzy Plant",  "Hydro Cannon", "Hyper Beam", "Earthquake", "Hurricane", "Inferno", "Cross Chop", "Dynamic Punch", "Egg Bomb", "Iron Tail", "Electro Ball", "Future Sight"}

local function doSketch(cid, target, pos, targetPos)
    if (not isCreature(cid) or not isCreature(target)) then
        return
    end

    -- Disable Ditto
    if (isPokemonTransformed(cid)) then
        doSendAnimatedText(pos, "FAIL!", TEXTCOLOR_WHITE)
        return
    end

    local master = getCreatureMaster(cid)
    if (cid == master or not isPlayer(master)) then -- Wild Pokemon using Sketch
        callSkillFunction(cid, table.random(WILD_MOVES))
        return
    end

    local move = getPokemonLastUsedMove(target)
    if (not move) then -- If the target has no last used move
        return
    end

    -- Disabled moves
    if (not getPokemonSkillSketchable(move)) then
        doSendAnimatedText(pos, "FAIL!", TEXTCOLOR_WHITE)
        doPlayerSendTextMessage(master, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(master, "Your %s can't Sketch this move."), getCreatureName(cid)))
        return
    end

    local ball = getPlayerBall(master)
    local sketchs = getBallSketchMoves(ball.uid)

    -- Disable equal Sketch
    if (table.find(getPokemonSkills(getCreatureName(cid), ball.uid), move)) then
        doSendAnimatedText(pos, "FAIL!", TEXTCOLOR_WHITE)
        doPlayerSendTextMessage(master, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(master, "Your %s already know this move."), getCreatureName(cid)))
        return
    end

    -- Only one heal Sketch
    if (getPokemonSkillMakeHeal(move)) then
        for _, tmpMove in pairs(sketchs) do
            if (getPokemonSkillMakeHeal(tmpMove)) then
                doSendAnimatedText(pos, "FAIL!", TEXTCOLOR_WHITE)
                doPlayerSendTextMessage(master, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(master, "Your %s can't Sketch another healing-type move."), getCreatureName(cid)))
                return
            end
        end
    end

    -- Level
    local reqLevel = 0
    for _, tmpMove in pairs(sketchs) do
        if (tmpMove ~= "Sketch") then
            reqLevel = reqLevel + 1
        end
    end
    reqLevel = reqLevel * 10

    if (getMonsterLevel(cid) < reqLevel) then
        doSendAnimatedText(pos, "FAIL!", TEXTCOLOR_WHITE)
        doPlayerSendTextMessage(master, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(master, "Your %s need at least level %s to Sketch another move."), getCreatureName(cid), reqLevel))
        return
    end

    local replace = table.find(sketchs, "Sketch")
    sketchs[(replace and replace or (#sketchs + 1))] = move
    setBallSketchMoves(ball.uid, sketchs)
    doPlayerUpdatePokemonMoves(master, ball.uid)
    doPlayerSendTextMessage(master, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(master, "%s sketched %s."), getCreatureName(cid), move))
end

function onTargetCreature_Sketch(cid, target)
    local pos = getCreaturePosition(cid)
    local targetPos = getCreaturePosition(target)
    for i = 0, 14 do
        addEvent(function(tmpPos)
            doSendDistanceShoot(pos, tmpPos, table.random(PROJECTILES))
            doSendDistanceShoot(tmpPos, pos, table.random(PROJECTILES))
            doSendMagicEffect(tmpPos, table.random(EFFECTS))
        end, (i * 100) + 1, {x = targetPos.x + getRandom(-1, 1), y = targetPos.y + getRandom(-1, 1),
            z = targetPos.z})
    end

    addEvent(doSketch, 700, cid, target, pos, targetPos)
end

local combat = createCombatObject() setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_Sketch")
function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
