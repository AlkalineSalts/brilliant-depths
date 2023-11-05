gellatinous_gazer = {}
setmetatable(gellatinous_gazer, {__index = Event})
function gellatinous_gazer.get_text(self, game_data)
	return "On a rock shelf nearby, you see a veiny gellatinous thing perched on a rock sprending tendrils over the rocky surface. It's unclear if it is some sort of plant or animal. There is a golden shimmering within the core of the creature."
end

function gellatinous_gazer.new()	
	local self = Event.new("gellatinous_gazer")
	setmetatable(self, {__index = gellatinous_gazer})

	local option_0 = Option.new("Get closer and investigate.", false)
	option_0.get_next_event_name = function() return "gellatinous_gazer_gaze" end 
	option_0.selected_action = function(self, game_data) 
	
	 end 
	
	self:add_option(option_0)
	local option_1 = Option.new("Seems suspicious, attack!", false)
	option_1.get_next_event_name = function() return "gellatinous_gazer_attack" end 
	
	self:add_option(option_1)
	local option_2 = Option.new("It's not worth investigating.", false)
	option_2.get_next_event_name = function() return nil end 
	
	self:add_option(option_2)
	return self
end
return gellatinous_gazer.new()