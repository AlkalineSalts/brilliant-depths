local rope_missing = {}
setmetatable(rope_missing, {__index = Event})
function rope_missing.get_text(self, game_data)
	return "You reach the edge of a cliff. You can see where the fixed rope should be, but it seems to be cut."
end

function rope_missing.init(self, game_data)	
	local option_0 = Option.new("Attempt to scale the rocks without a rope.", false)
	option_0.get_next_event_name = function(self, game_data) return "attempt_to_scale" end 
	
	self:add_option(option_0)
	local option_1 = Option.new("Affix your own rope. (Rope -1)", true)
	option_1.get_next_event_name = function(self, game_data) return "rope_down_cliff" end 
	option_1.is_selectable = function(self, game_data) 
		return game_data.inventory.Rope > 0
	end 
	
	self:add_option(option_1)
	local option_2 = Option.new("Wait for someone else to arrive with a rope.", false)
	option_2.get_next_event_name = function(self, game_data) return "cliff_wait" end 
	
	self:add_option(option_2)
	
end
function rope_missing.new()
	local self = Event.new("rope_missing")
	setmetatable(self, {__index = rope_missing})

	return self
end
return rope_missing.new()