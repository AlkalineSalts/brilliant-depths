local TABLE_PREFIX = "TABLE_"
--returns key table to id
local function getTableId(table)
	return TABLE_PREFIX..tostring(tonumber(string.format("%p", table)))
end
local function findTables(t)
	local tableToTableId = {}
	
	local function recursiveTraverseFindTables(table)
		local function addAndContinue(v)
		if type(v) == "table"
			then
				if not tableToTableId[v]
				then
					tableToTableId[v] = getTableId(v)
					recursiveTraverseFindTables(v)
				end
			end
		end
		for i, v in pairs(table)
		do
			addAndContinue(i)
			addAndContinue(v)
		end	
	end
	tableToTableId[t] = getTableId(t)
	recursiveTraverseFindTables(t)
	return tableToTableId
end


function serialize(t, File)
	if type(t) ~= "table"
	then
		error("t must be a table")
	end
	--Creating the index
	local INDEX_NAME = "index"
	local tableToId = findTables(t)
	local file = love.filesystem.newFile(File)
	file:open("w")
	file:write(string.format("local %s = {", INDEX_NAME))
	local idList_EmptyTable = {}
	for _, id in pairs(tableToId)
	do
		idList_EmptyTable[#idList_EmptyTable + 1] = id.." = {}"
	end
	file:write(table.concat(idList_EmptyTable, ", "))
	file:write("}\n")
	
	--Placing the principle table (The one to be returned)
	file:write(string.format("local TOP_TABLE = index.%s\n", getTableId(t)))
	
	
	--Settingup the pairs
	for table, id in pairs(tableToId)
	do
		for i, v in pairs(table)
		do
			if type(i) == "function" or type(v) == "function" then goto continue end
			local wasTable = false
			if type(i) == "table" then i = tableToId[i] end
			if type(v) == "table" then v = tableToId[v] wasTable = true end
			if type(i) == "string" then i = string.format("\"%s\"", i) end
			if type(v) == "string" then v = string.format("\"%s\"", v) end
			if wasTable then v = string.format("index[%s]", v) end
			file:write(string.format("index[\"%s\"][%s] = %s\n", id, i, v))
			::continue::
		end
	end
	
	file:write("return TOP_TABLE\n")
	file:close()
end
	
function deserialize(File)
	return love.filesystem.load(File)()
	
end
	
