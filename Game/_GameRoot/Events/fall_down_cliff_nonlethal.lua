local fall_down_cliff_nonlethal = {}
setmetatable(fall_down_cliff_nonlethal, {__index = Event})
function fall_down_cliff_nonlethal.get_text(self, game_data)
	return string.format("You try to get down as safely as you can manage. Unfortunately, the rock face is quite trecherous. %s loses his footing and falls. They yell loadly before crashing to the ground, moaning in pain. You catch up to them as quickly as possible.", self.party_member:getName())
end

function fall_down_cliff_nonlethal.init(self, game_data)	
	self.party_member = game_data.party[math.random(#game_data.party)]
	local event = self
	local option_0 = Option.new("Patch them up as best as possible.", false)
	option_0.get_next_event_name = function(self, game_data) return nil end 
	option_0.selected_action = function(self, game_data) 
		event.party_member:setNumericHealthState(event.party_member:getNumericHealthState() - 60)
	end 
	
	self:add_option(option_0)
	local option_1 = Option.new("Use medical supplies to patch them up. (-1 Medical Supplies) ", true)
	option_1.get_next_event_name = function(self, game_data) return nil end 
	option_1.selected_action = function(self, game_data) 
		game_data.inventory["Medical Supplies"] = game_data.inventory:changeItemAmount("Medical Supplies", -1)
		event.party_member:setNumericHealthState(event.party_member:getNumericHealthState() - 20)
	end 
	option_1.is_selectable = function(self, game_data) 
		return game_data.inventory["Medical Supplies"] > 0
	 end 
	
	self:add_option(option_1)
	
end
function fall_down_cliff_nonlethal.new()
	local self = Event.new("fall_down_cliff_nonlethal")
	setmetatable(self, {__index = fall_down_cliff_nonlethal})

	return self
end
return fall_down_cliff_nonlethal.new()