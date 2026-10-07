local MEMES = {
    ["/megusta"] = EFFECT_MEME_MEGUSTA,
    ["/trollface"] = EFFECT_MEME_TROLLFACE,
    ["/yaomingface"] = EFFECT_MEME_YAOMINGFACE,
    ["/pokerface"] = EFFECT_MEME_POKERFACE,
    ["/foreveralone"] = EFFECT_MEME_FOREVERALONE
}

function onSay(cid, words, param)
	if (not MEMES[words]) then
        return false
    end

    doSendMagicEffect(getCreaturePosition(cid), MEMES[words])
    return true
end
