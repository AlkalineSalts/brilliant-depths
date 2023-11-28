local goto1 = Event.new("go_up_layer")
goto1.can_be_chosen = function(self, game_data) 
	return game_data.depth ~= 0 and getLayer().depthMinimum == game_data.depth and not game_data.going_down
end
goto1.get_text = function() return "You arrive at the top of the layer. From here you can proceed up to the next layer." end

goto1.init = function (self)
	local option = Option.new("Go back up a layer.", true)
	option.selected_action = function (self, game_data)
		game_data.layer = game_data.layer - 1
	end
	option.get_next_event_name = function () return nil end
	self:add_option(option)
end


local goto2 = Event.new("go_down_layer")
goto2.can_be_chosen = function(self, game_data) 
	return game_data.depth ~= 0 and getLayer().depthMaximum == game_data.depth and game_data.going_down
end
goto2.get_text = function() return "You arrive at the crest of the next descent. From here you can proceed into the next layer. You brace yourself for the next layer." end

goto2.init = function (self)
	local option = Option.new("Move on to the next layer", true)
	option.selected_action = function (self, game_data)
		game_data.layer = game_data.layer + 1
	end
	option.get_next_event_name = function () return nil end
	self:add_option(option)
end


return goto1, goto2
