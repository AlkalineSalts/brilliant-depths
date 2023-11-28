local at_city = {}
setmetatable(at_city, {__index = Event})
function at_city.can_be_chosen(self, game_data) 
	return game_data.depth == 0 and not game_data.going_down
end

function at_city.get_text(self, game_data)
	return "You arrive back at the city of Oneria. "
end

function at_city.init(self, game_data)	
		local option_0 = Option.new("Sell some goods.", false)
	option_0.get_next_event_name = function(option_self, game_data) return SellScreen.new() end 
	
	self:add_option(option_0)
	
		local option_1 = Option.new("Return to the dive.", false)
	option_1.get_next_event_name = function(option_self, game_data) return MainScreen.new() end 
	option_1.selected_action = function(option_self, game_data) 
		game_data.going_down = true
	end 
	
	self:add_option(option_1)
	
		local option_2 = Option.new("End your trek.", false)
	option_2.get_next_event_name = function(option_self, game_data) 
		if getMainTask(game_data.main_task).is_completed(game_data)
		then
			return "main_ending_good"
		else
			return "main_ending_bad"
		end
	end 
	
	self:add_option(option_2)
	
end
function at_city.new()
	local self = Event.new("at_city")
	setmetatable(self, {__index = at_city})

	return self
end
return at_city.new()