cave_collapse_lethal = {}
setmetatable(cave_collapse_lethal, {__index = Event})
function cave_collapse_lethal.get_text(self, game_data)
	local validPartyMembersIndex = {}
	for i, partymember in ipairs(game_data.party)
	do
		if partymember:getClass() == PartyMember.Classes.Excavator
		then
			table.insert(validPartyMembersIndex, i)
		end
	end
	local toKill = getEventSaveLocation(self, game_data).toKill or validPartyMembersIndex[math.random(#validPartyMembersIndex)]
	getEventSaveLocation(self, game_data).toKill = toKill
	local returnString = string.format("The entire cave section collapses, leaving %s buried beneath the rubble. It's impossible to dig him out.", game_data.party[toKill]:getName())
	
	return returnString
end

function cave_collapse_lethal.new()	
	local self = Event.new("cave_collapse_lethal")
	setmetatable(self, {__index = cave_collapse_lethal})
	
	local option_0 = Option.new("Leave them to their fate...", false)
	option_0.get_next_event_name = function() return MainScreen.new() end 
	local e = self
	option_0.selected_action = function(self, game_data) 
		table.remove(game_data.party, getEventSaveLocation(e, game_data).toKill)
		getEventSaveLocation(e, game_data).toKill = nil
	end
	self:add_option(option_0)
	return self
end
return cave_collapse_lethal.new()