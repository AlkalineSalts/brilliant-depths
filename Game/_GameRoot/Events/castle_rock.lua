local example_event = Event.new("Castle_Rock")
example_event.get_text = function(self, info)
	return "You arrive at castle rock. From here you can see far and wide. You wonder at the scenery." 
end
example_event.can_be_chosen = function (self, game_data) 
	local bool = (not game_data.misc.a and game_data.depth >= 400)
	if bool
	then 
		game_data.misc.a = true
	end
	return bool
end

local option = Option.new("Only Option", true)
option.get_next_event_name = function () return nil end
example_event:add_option(option)

local option2 = Option.new("Only Option 2", true)
option2.get_next_event_name = function () return nil end
example_event:add_option(option2)

return example_event
