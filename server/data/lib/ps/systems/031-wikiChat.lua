if (WikiChat) then
    return
end

WikiChat = {}

WikiChat.Greets = {}

WikiChat.AUTHOR_NAME = "Wiki Chat"
WikiChat.TALK_TYPES = {
    TALKTYPE_CHANNEL_O,
    TALKTYPE_CHANNEL_RN,
    TALKTYPE_CHANNEL_Y,
    TALKTYPE_CHANNEL_W
}
WikiChat.MESSAGE_SIZE_LIMIT = 500

WikiChat.KeywordNode = {
    keywords = nil,
    parameters = nil,
    children = nil,
    parent = nil,
}

-- Created a new WikiChat.KeywordNode with the given keywords and parameters and without any childNodes.
function WikiChat.KeywordNode:new(keys, param)
    local obj = {}
    obj.keywords = keys
    obj.parameters = param
    obj.children = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function WikiChat.KeywordNode:processMessage(cid, message)
    if (not self.parameters) then
        return true
    end

    if (self.parameters.moveup ~= nil) then
        local n = WikiChat.handler:moveUp(cid, self.parameters.moveup)
        if (n) then
            n:processMessage(cid, message)
        end

    elseif (self.parameters.text) then
        WikiChat.handler:sendMessage(cid, self.parameters.text)
    end

    return true
end

-- Returns true if message contains all patterns/strings found in keywords.
function WikiChat.KeywordNode:checkMessage(message)
    local ret = false
    if(self.keywords.callback ~= nil) then
        return self.keywords.callback(self.keywords, message)
    end
    for i,v in ipairs(self.keywords) do
        if(type(v) == 'string') then
            local a, b = string.find(message, v)
            if(a or b) then
                ret = true
                break
            end
        end
    end
    return ret
end

-- Returns the parent of this node or nil if no such node exists.
function WikiChat.KeywordNode:getParent()
    return self.parent
end

-- Returns an array of the callback function parameters assosiated with this node.
function WikiChat.KeywordNode:getParameters()
    return self.parameters
end

-- Returns an array of the triggering keywords assosiated with this node.
function WikiChat.KeywordNode:getKeywords()
    return self.keywords
end

-- Adds a childNode to this node. Creates the childNode based on the parameters (k = keywords, p = parameters)
function WikiChat.KeywordNode:addChildKeyword(keywords, parameters)
    local new = WikiChat.KeywordNode:new(keywords, parameters)
    return self:addChildKeywordNode(new)
end

-- Adds a pre-created childNode to this node. Should be used for example if several nodes should have a common child.
function WikiChat.KeywordNode:addChildKeywordNode(childNode)
    table.insert(self.children, childNode)
    childNode.parent = self
    return childNode
end

WikiChat.KeywordHandler = {
    root = nil,
    lastNode = {},
    lastTalkTypeId = {}
}

-- Creates a new WikiChat.KeywordHandler with an empty rootnode.
function WikiChat.KeywordHandler:new()
    local obj = {}
    obj.root = WikiChat.KeywordNode:new(nil, nil, nil)
    setmetatable(obj, self)
    self.__index = self
    return obj
end

-- Resets the lastNode field, and this resetting the current position in the node hierarchy to root.
function WikiChat.KeywordHandler:reset(cid)
    self.lastNode[cid] = nil
    self.lastTalkTypeId[cid] = nil
end

function WikiChat.KeywordHandler:sendMessage(cid, message, talkType)
    if (not talkType) then
        local last = WikiChat.handler.lastTalkTypeId[cid] or 1
        local t = WikiChat.TALK_TYPES[last + 1]
        if (t) then
            WikiChat.handler.lastTalkTypeId[cid] = last + 1
        else
            t = WikiChat.TALK_TYPES[1]
            WikiChat.handler.lastTalkTypeId[cid] = 1
        end

        talkType = t
    end

    if (isString(message) and string.len(message) > WikiChat.MESSAGE_SIZE_LIMIT) then
        message = string.createStory(message, WikiChat.MESSAGE_SIZE_LIMIT)
    end

    if (isString(message)) then
        doPlayerSendChannelMessage(cid, WikiChat.AUTHOR_NAME, message, talkType, CHANNEL_WIKI_CHAT)

    else -- Table ya
        for _, text in pairs(message) do
            doPlayerSendChannelMessage(cid, WikiChat.AUTHOR_NAME, text, talkType, CHANNEL_WIKI_CHAT)
        end
    end
end

-- Makes sure the correct childNode of lastNode gets a chance to process the message.
function WikiChat.KeywordHandler:processMessage(cid, message)
    local node = self:getLastNode(cid)
    if(node == nil) then
        error('No root node found.')
        return false
    end

    local ret = self:processNodeMessage(node, cid, message)
    if(ret) then
        return true
    end
    if(node:getParent()) then
        node = node:getParent() -- Search through the parent.
        local ret = self:processNodeMessage(node, cid, message)
        if(ret) then
            return true
        end
    end
    if(node ~= self:getRoot()) then
        node = self:getRoot() -- Search through the root.
        local ret = self:processNodeMessage(node, cid, message)
        if(ret) then
            return true
        end
    end

    return false
end

-- Tries to process the given message using the node parameter's children and calls the node's callback function if found.
--	Returns the childNode which processed the message or nil if no such node was found.
function WikiChat.KeywordHandler:processNodeMessage(node, cid, message)
    local messageLower = string.lower(message)
    for i, childNode in pairs(node.children) do
        if(childNode:checkMessage(messageLower)) then
            local oldLast = self.lastNode[cid]
            self.lastNode[cid] = childNode
            childNode.parent = node -- Make sure node is the parent of childNode (as one node can be parent to several nodes).
            if(childNode:processMessage(cid, message)) then
                return true
            else
                self.lastNode[cid] = oldLast
            end
        end
    end
    return false
end

-- Returns the root WikiChat.KeywordNode
function WikiChat.KeywordHandler:getRoot()
    return self.root
end

-- Returns the last processed WikiChat.KeywordNode or root if no last node is found.
function WikiChat.KeywordHandler:getLastNode(cid)
    return self.lastNode[cid] or self:getRoot()
end

-- Adds a new keyword to the root WikiChat.KeywordNode. Returns the new node.
function WikiChat.KeywordHandler:addKeyword(keys, parameters)
    return self:getRoot():addChildKeyword(keys, parameters)
end

-- Moves the current position in the keyword hierarchy count steps upwards. Count defalut value = 1.
--	This function MIGHT not work properly yet. Use at your own risk.
function WikiChat.KeywordHandler:moveUp(cid, count)
    local steps = count
    if(steps == nil) then
        steps = 1
    end
    for i = 1, steps,1 do
        if(self.lastNode[cid] == nil) then
            break
        else
            self.lastNode[cid] = self.lastNode[cid]:getParent() or self:getRoot()
        end
    end
    return self.lastNode[cid]
end

function WikiChat.KeywordHandler:greet(cid)
    self:sendMessage(cid, WikiChat.Greets)
end

WikiChat.handler = WikiChat.KeywordHandler:new()

local function createNodes(nodes, parent)
    for _, v in pairs(nodes) do
        local node
        if (parent) then
            node = parent:addChildKeyword(v.keywords, v.parameters)
        else
            node = WikiChat.handler:addKeyword(v.keywords, v.parameters)
        end
        if (v.childs) then
            createNodes(v.childs, node)
        end
    end
end

dofile(PS_LIB_CONFIG_DIR .. "002-wikiChat.lua")

for _, v in pairs(WIKICHAT_GREETS) do
    table.insert(WikiChat.Greets, v)
end
WIKICHAT_GREETS = nil

createNodes(WIKICHAT_NODES)
createNodes = nil
WIKICHAT_NODES = nil