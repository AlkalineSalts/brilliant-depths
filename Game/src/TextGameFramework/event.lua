Event = {}
function Event._has_option(self, option)
	for _, v in ipairs(self._options)
	do
		if v == option
		then
			return true
		end
	end
	return false
end

--[[
	Should only be called if being selected from a group
	Should not modify game data
	Can be overriden
]]
function Event.can_be_chosen(self, game_data)
	return true
end

function Event.get_options(self, game_data) --do not modify this method
	--creates and returns a list of all visible options
	local visibleList = {}
	for index, option in ipairs(self._options)
	do
		local option = self._options[index]
		if option:should_be_seen(game_data)
		then
			visibleList[#visibleList + 1] = option
		end
	end
	return visibleList
end
	
function Event.get_text(self, game_data) --Can be overriden/switched for more utility, should not modify game data
	return self._text
end

function Event.get_name(self) --do not modify this method
	return self._name
end

--used to add options an event, do not modify
function Event.add_option(self, option)
	self._options[#self._options + 1] = option
end

function Event.initialize(self, game_data)
	if self.init -- This check is for compatibility's sake, remove once compatibility needs are gone
	then
		self._options = {}
		self:init(game_data)
	end
end

function Event.new(name) --do not modify/override
	local o = {}
	setmetatable(o, {__index = Event})
	o._name = name
	o._options = {}
	return o
end

return Event