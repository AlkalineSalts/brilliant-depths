local illnesses = {"Pneumonia", "Tuberculosis", "Dysentary"}
local illness = {}
setmetatable(illness, {__index = Event})
function illness.can_be_chosen(self, game_data) 
	--Attempts to show up proportionally to the number of crew members e.g. 100% chance at 5 members, 80% at 2, etc.
	return math.random() <= #game_data.party * .2
end

function illness.get_text(self, game_data)
	return string.format("%s has %s.", self.party_member:getName(), illnesses[math.random(#illnesses)])
end

function illness.init(self, game_data)	local option_0 = Option.new("Continue", false)
	 option_0.get_next_event_name = function(self, game_data) return nil end 
	 option_0.selected_action = function(self, game_data) 
	 self.party_member = game_data.party:getRandomMember()
	 end 
	 option_0.is_selectable = function(optionself, game_data) 
		 self.party_member:setNumericHealthState(self.party_member:getNumericHealthState() - 20)
	 end 
	
	self:add_option(option_0)
	
end
function illness.new()
	local self = Event.new("illness")
	setmetatable(self, {__index = illness})

	return self
end
return illness.new()