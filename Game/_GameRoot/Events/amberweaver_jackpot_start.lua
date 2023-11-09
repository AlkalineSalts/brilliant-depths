local amberweaver_jackpot_start = {}
setmetatable(amberweaver_jackpot_start, {__index = Event})
function amberweaver_jackpot_start.get_text(self, game_data)
	return "When looking for a cave to set up camp for the night, you come across a cocoon structure composed of amber threads. It's hard to the touch. "
end

function amberweaver_jackpot_start.new()
	local self = Event.new("amberweaver_jackpot_start")
	setmetatable(self, {__index = amberweaver_jackpot_start})

	local option_0 = Option.new("Break it open. ", false)
	option_0.get_next_event_name = function(self, game_data) return "amberweaver_jackpot" end 
	
	self:add_option(option_0)
	local option_1 = Option.new("Don't break it open, but stay in the cave.", false)
	option_1.get_next_event_name = function(self, game_data) return nil end 
	
	self:add_option(option_1)
	local option_2 = Option.new("Let's set up camp elsewhere.", false)
	option_2.get_next_event_name = function(self, game_data) return nil end 
	
	self:add_option(option_2)
	return self
end
return amberweaver_jackpot_start.new()