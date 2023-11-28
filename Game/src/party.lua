Party = {}
function Party.getAverageHealth(self)
	local health_avg = 0
	for _, member in ipairs(self)
	do
		health_avg = health_avg + member:getNumericHealthState()
	end
	health_avg = health_avg / #self
	return PartyMember.getHealthStateForNumber(health_avg)
end

function Party.findPartyMembers(self, boolFunc)
	local list = {}
	for _, member in ipairs(self)
	do
		if boolFunc(member) then list[#list + 1] = member end
	end
	return list
end

function Party.getRandomMember(self)
	return self[math.random(#self)]
end

function Party.changeHealthNumericForAll(self, changeAmt)
	for _, member in ipairs(self)
	do
		member:setNumericHealthState(member:getNumericHealthState() + changeAmt)
	end
end

function Party.killPartyMember(self, member)
	for index, in_member in ipairs(self)
	do
		if member == in_member
		then
			table.remove(self, index)
			return true
		end
	end
	return false
end