gellatinous_gazer_attack = {}
setmetatable(gellatinous_gazer_attack, {__index = Event})
function gellatinous_gazer_attack.get_text(self, game_data)
	return "You pull out a knife and approach. Stabbing into it's body causes some blueish substance to sprout from it. The glowing at the center fades and it stops any movement. Perhaps it isn't hostile after all."
end

function gellatinous_gazer_attack.new()	
	local self = Event.new("gellatinous_gazer_attack")
	setmetatable(self, {__index = gellatinous_gazer_attack})

	local option_0 = Option.new("Continue", false)
	option_0.get_next_event_name = function() return nil end 
	
	self:add_option(option_0)
	return self
end
return gellatinous_gazer_attack.new()