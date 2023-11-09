local amberweaver_active_nest = {}
setmetatable(amberweaver_active_nest, {__index = Event})
function amberweaver_active_nest.get_text(self, game_data)
	return "As you begin to dig into the cocoon, a bunch of spiders pour out of it. You run away as fast as possible."
end

function amberweaver_active_nest.new()
	local self = Event.new("amberweaver_active_nest")
	setmetatable(self, {__index = amberweaver_active_nest})

	local option_0 = Option.new("Continue", false)
	option_0.get_next_event_name = function(self, game_data) return nil end 
	
	self:add_option(option_0)
	return self
end
return amberweaver_active_nest.new()