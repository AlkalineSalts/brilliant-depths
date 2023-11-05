gellatinous_gazer_gaze_long = {}
setmetatable(gellatinous_gazer_gaze_long, {__index = Event})
function gellatinous_gazer_gaze_long.get_text(self, game_data)
	return "You look around you at the night sky. It's night? How could that be? You feel extremely hungry and tired. Looks like you're not going anywhere today. "
end

function gellatinous_gazer_gaze_long.new()
	local self = Event.new("gellatinous_gazer_gaze_long")
	setmetatable(self, {__index = gellatinous_gazer_gaze_long})

	local option_0 = Option.new("Continue", false)
	option_0.get_next_event_name = function(self, game_data) return nil end 
	
	self:add_option(option_0)
	return self
end
return gellatinous_gazer_gaze_long.new()