local QUEST_STORAGE = 8560
local ITEMEX_ID = 25197

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx) or itemEx.itemid ~= ITEMEX_ID) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    doSendDistanceShoot(fromPosition, toPosition, PROJECTILE_MASTERBALL)
    doSendMagicEffect(toPosition, EFFECT_BIG_EXPLOSION)
    doRemoveItem(itemEx.uid)
    doRemoveItem(item.uid)
    
    local mewtwoNpc = doCreateNpc("Mewtwo", toPosition)
    doCreatureSay(mewtwoNpc, "How dare you?!", TALKTYPE_SAY)
    addEvent(function()
        doRemoveCreature(mewtwoNpc)
        doCreateMonster("Final Mewtwo", toPosition)
    end, 3000)
    

--    addEvent(function()
--        doRemoveItem(item.uid)
--        -- todo doSendMagicEffect(toPosition, EFFECT_MEWTWO)
--        local mewtwoNpc = doCreateNpc("Mewtwo", toPosition)
--        doCreatureSay(mewtwoNpc, "How dare you?!", TALKTYPE_SAY)
--        addEvent(function()
--            doRemoveCreature(mewtwoNpc)
--            doCreateMonster("Final Mewtwo", toPosition)
--        end, 3000)
--    end, 4000)
  
  --[[
  O jogador usa a Master Ball no Mewtwo e ela falha, e o Mewtwo reaparece (usando aquela animação) como MOB e diz: Como você ousa?

  Vencendo a luta contra o Mewtwo ele falará: Você venceu desta vez... Mas eu irei retornar.

  E desaparece.
      ]]


    return true
end
