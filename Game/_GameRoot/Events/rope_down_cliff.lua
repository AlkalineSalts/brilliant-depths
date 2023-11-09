local rope_down_cliff = {}
setmetatable(rope_down_cliff, {__index = Event})
function rope_down_cliff.get_text(self, game_data)
	return "You affix your own rope and climb down. Easy Peasy."
end

function rope_down_cliff.init(self, game_data)	local option_0 = Option.new("Continue", false)
	option_0.get_next_event_name = function(self, game_data) return nil end 
	option_0.selected_action = function(self, game_data) 
		game_data.inventory:changeItemAmount("Rope", -1)
	end 
	
	self:add_option(option_0)
	
end
function rope_down_cliff.new()
	local self = Event.new("rope_down_cliff")
	setmetatable(self, {__index = rope_down_cliff})

	return self
end
return rope_down_cliff.new()