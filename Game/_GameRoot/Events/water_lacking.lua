local water_lacking = {}
setmetatable(water_lacking, {__index = Event})
function water_lacking.can_be_chosen(self, game_data) 
	local isAdventurer = function(member)
		return member:getClass() == PartyMember.Classes.Adventurer
	end
	return #game_data.party:findPartyMembers(isAdventurer) == 0
end

function water_lacking.get_text(self, game_data)
	return "The party could not find water."
end

function water_lacking.init(self, game_data)	
	
	local option_0 = Option.new("Continue", false)
	option_0.get_next_event_name = function(self, game_data) return nil end 
	option_0.selected_action = function(self, game_data) 
		for _, member in ipairs(game_data.party)
		do
			member:setNumericHealthState(member:getNumericHealthState() - 5)
		end
	end 
	
	self:add_option(option_0)
	
end
function water_lacking.new()
	local self = Event.new("water_lacking")
	setmetatable(self, {__index = water_lacking})

	return self
end
return water_lacking.new()