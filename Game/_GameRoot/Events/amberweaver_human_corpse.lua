local amberweaver_human_corpse = {}
setmetatable(amberweaver_human_corpse, {__index = Event})
function amberweaver_human_corpse.get_text(self, game_data)
	return "Chiseling it open with a pickaxe, you find a nearly fresh body. Amazingly, it looks like it was preserved by threads. He even has some supplies on him that are still good!"
end

function amberweaver_human_corpse.new()
	local self = Event.new("amberweaver_human_corpse")
	setmetatable(self, {__index = amberweaver_human_corpse})

	local option_0 = Option.new("Continue", false)
	option_0.get_next_event_name = function(self, game_data) return nil end 
	option_0.selected_action = function(self, game_data) 
	
	 end 
	
	self:add_option(option_0)
	return self
end
return amberweaver_human_corpse.new()