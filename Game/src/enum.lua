require("src.util")
Enum = {}
local function emptyFunc (table, key) error("Cannot add or change values of an enum") end
function Enum.values(enum)
	--iterate iver backing table
	local backingTable = getmetatable(enum).__index
	local valuesTable = {}
	for value, index in pairs(backingTable)
	do
		valuesTable[index] = value
	end
	return valuesTable	
	
end

function Enum.new(values) --values == list of strings
	local self = {}
	local backingTable = {}
	for i, v in ipairs(values)
	do
		backingTable[v] = i
	end
	setmetatable(self, {__index = backingTable, __newindex = emptyFunc)}
	return self
end

return Enum