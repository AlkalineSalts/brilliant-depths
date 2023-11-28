local generic_mining_area = {}
setmetatable(generic_mining_area, {__index = Event})
function generic_mining_area.get_text(self, game_data)
	return "While examining camp for the night, you come across a man-made tunnel that looks to lead to a relic deposit."
end

function generic_mining_area.init(self, game_data)	
		local option_0 = Option.new("(Excavator) Begin mining.", true)
	option_0.get_next_event_name = function(option_self, game_data) return MiningGameScreen.new() end 
	option_0.is_selectable = function(option_self, game_data) 
		return #game_data.party:findPartyMembers(function(member) return member:getClass() == PartyMember.Classes.Excavator end) > 0
	end 
	
	self:add_option(option_0)
	
		local option_1 = Option.new("Move on", false)
	option_1.get_next_event_name = function(option_self, game_data) return nil end 
	
	self:add_option(option_1)
	
end
function generic_mining_area.new()
	local self = Event.new("generic_mining_area")
	setmetatable(self, {__index = generic_mining_area})

	return self
end
return generic_mining_area.new()