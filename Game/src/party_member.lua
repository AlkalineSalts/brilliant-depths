require("src.enum")
PartyMember = {}
PartyMember.Classes = Enum.new({"Adventurer", "Excavator", "Hunter", "Navigator", "Crafter"})
PartyMember.TravelingSpeed = Enum.new({"Balanced", "Strenuous", "Grueling"})
PartyMember.FoodAmount = Enum.new({"Hearty", "Meager", "Sparse"})

function PartyMember.getName(self)
	return self._name
end

function PartyMember.getClass(self)
	return self._class
end

function PartyMember.getHealthStateForNumber(healthVal)
	if healthVal >= 80
	then
		return "Great"
	elseif healthVal < 80 and healthVal >= 50
	then
		return "Good"
	elseif healthVal < 50 and healthVal >= 25
	then
		return "Fair"
	else
		return "Poor"
	end
end

function PartyMember.getHealthState(self)
	return PartyMember.getHealthStateForNumber(self:getNumericHealthState())
end

function PartyMember.getNumericHealthState(self)
	return self._healthState
end

function PartyMember.setNumericHealthState(self, newHealthValue)
	if type(newHealthValue) ~= "number" then error("newHealthValue must be a number") end
	self._healthState = math.max(0, math.min(newHealthValue, 100))
end

function PartyMember.new(name, class)
	self = {}
	setmetatable(self, {__index = PartyMember})
	if not Enum.isInEnum(PartyMember.Classes, class)
	then
		error(string.format("%s is not a class", class))
	end
	self._name = name
	self._class = class
	self._healthState = 100
	return self
end

return PartyMember