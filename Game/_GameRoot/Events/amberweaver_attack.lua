local amberweaver_attack = {}
setmetatable(amberweaver_attack, {__index = Event})
function amberweaver_attack.get_text(self, game_data)
	return "As you sleep, an amberweaver sneak into the cavern. Luckily, though, you're able to fight it off."
end

function amberweaver_attack.new()
	local self = Event.new("amberweaver_attack")
	setmetatable(self, {__index = amberweaver_attack})

	local option_0 = Option.new("Continue", false)
	option_0.get_next_event_name = function(self, game_data) return nil end 
	
	self:add_option(option_0)
	return self
end
return amberweaver_attack.new()