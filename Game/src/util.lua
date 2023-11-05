--for lua 5.1, implementing table.unpack()
function table.unpack(t)
	function unpacker_helper(t, index)
		local element = t[index]
		if element == nil
		then
			 return nil
		else
			return element, unpacker_helper(t, index + 1)
		end
			
	end
	return unpacker_helper(t, 1)
end

function table.pack(...)
    return { n = select("#", ...), ... }
end


function table.shallowCopy(table)
	local copy = {}
	for key, value in pairs(table)
	do
		copy[key] = value
	end
	return copy
end
function sameId(val1, val2) --checks if values have the same id
	return string.format("%s", val1) == string.format("%s", val2)
end
function tableEquality(t1, t2) --checks if tables are equal by checking if they have the same keys and values for those keys {for tables recursion is used}
	local function getKeys(table)
		local keys = {}
		i = 1
		for k, _ in pairs(table)
		do
			keys[i] = k
			i = i + 1
		end
		return keys
	end
	local function tableEqualityHelper(table1, table2) --gets lost if references are circular
		local table1Keys = getKeys(table1)
		local table2Keys = getKeys(table2)
		--check if keys equal
		if #table1Keys ~= #table2Keys
		then
		return false
		end
		table.sort(table1Keys) table.sort(table2Keys)
		--by here, tables are equal & sorted
		for i = 1, #table1Keys
		do
			if table1Keys[i] ~= table2Keys[i]
			then
				return false
			end
		end
		--if here, keys are equal, now check values
		for i = 1, #table1Keys
		do
			local key = table1Keys[i]
			local val1 = table1[key]
			local val2 = table2[key]
			local type1 = type(val1)
			local type2 = type(val2)
			if type1 ~= type2
			then
				return false
			end
			if type1 == "table"
			then
				tableEqualityHelper(table1, table2)
			else
				return val1 == val2
			end
			
		end
		return true
	end
	return tableEqualityHelper(t1, t2)	
end

function isInstanceOf(value, potentialSuperclass)
	local classTable = getmetatable(value)
	if classTable == nil
	then
		return false
	else
		classTable = classTable.__index
	end
	
	if classTable == potentialSuperclass
	then
		return true
	else
		return isInstanceOf(classTable, potentialSuperclass)
	end
end