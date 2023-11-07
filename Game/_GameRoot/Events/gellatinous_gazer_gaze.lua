gellatinous_gazer_gaze = {}
setmetatable(gellatinous_gazer_gaze, {__index = Event})
local glowing_colors = {"black", "blue", "green", "indigo", "purple", "orange"}
function gellatinous_gazer_gaze.get_text(self, game_data)
	::retry::
	local selected_color = glowing_colors[math.random(#glowing_colors)]
	if selected_color == getEventSaveLocation(self, game_data).glowing_color then goto retry end
	getEventSaveLocation(self, game_data).glowing_color = selected_color
	return string.format("You peer closer at the center of the orb. It seems to be glowing  %s now. You're not sure if is safe to touch.", selected_color)
end

function gellatinous_gazer_gaze.new()	
	local self = Event.new("gellatinous_gazer_gaze")
	local event = self
	setmetatable(self, {__index = gellatinous_gazer_gaze})

	local option_0 = Option.new("Keep looking...", false)
	option_0.get_next_event_name = function(self, game_data) 
		return "gellatinous_gazer_gaze" 
	end 
	option_0.selected_action = function(self, game_data) 
		local saveLocation = getEventSaveLocation(event, game_data)
		if saveLocation.timesDone
		then
			saveLocation.timesDone = saveLocation.timesDone + 1
		else
			saveLocation.timesDone = 1
		end
	end 
	
	self:add_option(option_0)
	local option_1 = Option.new("Leave", false)
	option_1.get_next_event_name = function(self, game_data) 
		local timesLooked = getEventSaveLocation(event, game_data).timesDone
		getEventSaveLocation(event, game_data).timesDone = nil
		if timesLooked and timesLooked > 2
		then
			return "gellatinous_gazer_gaze_long"
		else
			return nil
		end
	end 
	
	self:add_option(option_1)
	return self
end
return gellatinous_gazer_gaze.new()