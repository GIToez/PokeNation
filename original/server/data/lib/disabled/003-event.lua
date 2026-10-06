local EVENT_TYPE = {
	SINGLE = 1,
	CYCLE  = 2,
}

-- private functions
local function parseSingleEvent(event)
	event.f(unpack(event.args))
	event.id = nil
end

local function parseCycleEvent(event)
	event.f(unpack(event.args))
	event.id = addEvent(parseCycleEvent, event.time, event)
end

-- member functions
Event = {}

function Event:start()
	if not self.id then
		if self.type == EVENT_TYPE.SINGLE then
			self.id = addEvent(parseSingleEvent, self.time, self)
		elseif self.type == EVENT_TYPE.CYCLE then
			parseCycleEvent(self)
		end
	else
		print('Trying to start an already started event.')
	end
end

function Event:restart(time)
	if self.id then
		self:stop()
	end
	self.time = time or self.time
	self:start()
end

function Event:stop()
	if self.id then
		stopEvent(self.id)
		self.id = nil
	else
		print('Trying to stop an already deleted event.')
	end
end

function Event:isFinished()
	return not self.id
end

-- public functions
function createSingleEvent(f, time, ...)
	local event = {}
	event.f = f
	event.args = {...}
	event.time = time
	event.type = EVENT_TYPE.SINGLE
	setmetatable(event, { __index = Event })

	event:start()
	return event
end

function createCycleEvent(f, time, ...)
	local event = {}
	event.f = f
	event.args = {...}
	event.time = time
	event.type = EVENT_TYPE.CYCLE
	setmetatable(event, { __index = Event })

	event:start()
	return event
end