local cliff_wait = {}
setmetatable(cliff_wait, {__index = Event})
function cliff_wait.get_text(self, game_data)
	return string.format("You wait around for another group to show up. It takes %d days, but eventually another group comes and affixes a new rope. ", self.dayNum)
end

function cliff_wait.init(self, game_data)	
	local option_0 = Option.new("Continue", false)
	self.dayNum = math.random(1,4)
	local event = self
	option_0.get_next_event_name = function(self, game_data) return nil end 
	option_0.selected_action = function(self, game_data) 
		for i=1, event.dayNum
		do
			increaseDay(game_data)
		end
	end 
	
	self:add_option(option_0)
	
end
function cliff_wait.new()
	local self = Event.new("cliff_wait")
	setmetatable(self, {__index = cliff_wait})

	return self
end
return cliff_wait.new()