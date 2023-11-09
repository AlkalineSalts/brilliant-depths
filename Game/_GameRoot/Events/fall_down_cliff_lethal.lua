local fall_down_cliff_lethal = {}
setmetatable(fall_down_cliff_lethal, {__index = Event})
function fall_down_cliff_lethal.get_text(self, game_data)
	return string.format("You try to get down as safely as you can manage. Unfortunately, the rock face is quite trecherous. %s loses his footing and falls. By the time you reach him, he is already dead.", game_data.party[self.faller]:getName())
end

function fall_down_cliff_lethal.init(self, game_data)	
	local option_0 = Option.new("Continue", false)
	self.faller = math.random(#game_data.party)
	option_0.get_next_event_name = function(self, game_data) return nil end 
	option_0.selected_action = function(Oself, game_data) 
		table.remove(game_data.party, self.faller)
	 end 
	
	self:add_option(option_0)
	
end
function fall_down_cliff_lethal.new()
	local self = Event.new("fall_down_cliff_lethal")
	setmetatable(self, {__index = fall_down_cliff_lethal})

	return self
end
return fall_down_cliff_lethal.new()