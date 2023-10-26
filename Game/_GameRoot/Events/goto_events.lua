local goto2 = Event.new("goto_layer")
goto2.can_be_chosen = function(self, game_data) 
	return game_data.depth ~= 0 and getLayer().depthMaximum == game_data.depth
end
goto2.get_text = function() return "You arrive at the crest of the next descent. From here you can proceed into the next layer. You brace yourself for the next layer." end


local option = Option.new("Only Option", true)
option.get_next_event_name = function () return nil end
goto2:add_option(option)


return goto2
