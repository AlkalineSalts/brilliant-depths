local layer_one_relic_deposit = {}
setmetatable(layer_one_relic_deposit, {__index = Event})
function layer_one_relic_deposit.can_be_chosen(self, game_data) 
	return math.random() > 0.8
end

function layer_one_relic_deposit.get_text(self, game_data)
	return "It's hard to find relics on this layer, as such a well traveled route has had many of its secrets stolen long before. It seems you've gotten lucky, however, as you find a promising location here."
end

function layer_one_relic_deposit.init(self, game_data)	
		local option_0 = Option.new("Continue", false)
	option_0.get_next_event_name = function(option_self, game_data) return MiningGameScreen.new() end 
	
	self:add_option(option_0)
	
end
function layer_one_relic_deposit.new()
	local self = Event.new("layer_one_relic_deposit")
	setmetatable(self, {__index = layer_one_relic_deposit})

	return self
end
return layer_one_relic_deposit.new()