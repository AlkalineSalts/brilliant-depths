require("src.enum")
PartyMember = {}
PartyMember.Classes = Enum.new({"Adventurer", "Miner"})

function PartyMember.getName()
	return self._name
end

function PartyMember.getClass(self)
	return self._class
end

function PartyMember.new(name, class)
	self = {}
	setmetatable(PartyMember, self)
	if not PartyMember.Classes[class]
	then
		error(string.format("%s is not a class", class))
	end
	self._name = name
	self._class = class
	return self
end

return PartyMember