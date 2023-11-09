local scale_down_cliff = {}
setmetatable(scale_down_cliff, {__index = Event})
function scale_down_cliff.get_text(self, game_data)
	return "With great luck, you manage to reach the bottom without any casualties."
end

function scale_down_cliff.init(self, game_data)	local option_0 = Option.new("Continue", false)
	option_0.get_next_event_name = function(self, game_data) return nil end 
	
	self:add_option(option_0)
	
end
function scale_down_cliff.new()
	local self = Event.new("scale_down_cliff")
	setmetatable(self, {__index = scale_down_cliff})

	return self
end
return scale_down_cliff.new()