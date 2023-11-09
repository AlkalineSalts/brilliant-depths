local amberweaver_animal_corpse = {}
setmetatable(amberweaver_animal_corpse, {__index = Event})
function amberweaver_animal_corpse.get_text(self, game_data)
	return "Breaking the threads with a pickaxe, you find the body of another creature, nearly perfectly preserved by the threads. It looks like the meat has spoiled, but the fur is good enough to use."
end

function amberweaver_animal_corpse.new()
	local self = Event.new("amberweaver_animal_corpse")
	setmetatable(self, {__index = amberweaver_animal_corpse})

	local option_0 = Option.new("Continue", false)
	option_0.get_next_event_name = function(self, game_data) return nil end 
	
	self:add_option(option_0)
	return self
end
return amberweaver_animal_corpse.new()