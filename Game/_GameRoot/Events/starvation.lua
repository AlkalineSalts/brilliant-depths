local StarvationEvent = {}
setmetatable(StarvationEvent, {__index = Event})
-- Will definite
function StarvationEvent.can_be_chosen(self, game_data)
	local starvingMembers = {}
	for memberNum, member in ipairs(game_data.party)
	do
		if game_data.inventory.Food == 0 and member:getHealthState() == "Poor" and math.random(3) == 3
		then
			table.insert(starvingMembers, memberNum)
		end
	end
	if #starvingMembers > 0
	then
		self._starving_player = starvingMembers[math.random(#starvingMembers)]
	end
end

function StarvationEvent.get_text(self, game_data)
	return string.format("%s starved to death.", game_data.party[self._starving_player]:getName())
end

function StarvationEvent.new()
	local self = Event.new("starvation")
	setmetatable(self, {__index = StarvationEvent})
	self._starving_player = nil
	
	local first = Option.new("Lay them down to rest.")
	first.is_selectable = function(optionSelf, game_data) return #game_data.party > 1 end
	first.selected_action = function(optionSelf, game_data) table.remove(game_data.party, self.starving_player) end
	first.get_next_event_name = function () return nil end
	self:add_option(first)
	
	local second = Option.new("Lay down and die.")
	second.is_selectable = function(optionSelf, game_data) return #game_data.party == 0 end
	second.selected_action = function (optionSelf, game_data) table.remove(game_data.party, self.starving_player) end
	second.get_next_event_name = function () return "terminal_events" end
	self:add_option(second)
	
	return self
end

return StarvationEvent.new()