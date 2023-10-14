local NUMBER_KEY_HEADER = "HIGHLYUNLIKELYUSEDNUMBERKEYHEADER_"
function serialize (value, file_path)
local file = love.filesystem.newFile(file_path)
local errstr
_, errstr = file:open("w")
if errstr
then
	error(errstr)
end
file:write("return ")
local function serializeHelper(o) --Cannot deal with serializing functions or table cycles
	local stopComma = true -- Prevents the first comma from being printed
	local t = type(o)
	if t == "number" or t == "boolean" or t == "nil" 
	then
    	file:write(tostring(o))
	elseif t == "string"
	then
		file:write(string.format("%q", o))
        elseif t == "table" then
        	file:write("{")
            for k,v in pairs(o) do
				if type(v) ~= "function"
					then
						if not stopComma
						then
							file:write(",")
						else
							stopComma = false
						end
            			file:write("  ")
						if tonumber(k)
						then
							file:write(NUMBER_KEY_HEADER..k) --Wraps number with string for use in table constructor, undone in deserialize
						else
							file:write(k)
						end
						file:write(" = ")
            			serializeHelper(v)
                		file:write("\n")
					end
			end
         	file:write("}")
         
	end
end
serializeHelper(value)
file:close()
end
function deserialize(file_path)
	func, err = love.filesystem.load(file_path)
	if err then
		error(err)
	end
	returnTable = func()
	local function helperRecursiveNumberCorrector(table) --Wrapped numbers as a string, undoing with helped
		local keys = {}
		local values = {}
		for k, v in pairs(table)
		do
			keys[#keys + 1] = k
			values[#values + 1] = v
		end
		--Must be same length
		for i = 1, #keys
		do
			if string.find(keys[i], NUMBER_KEY_HEADER) == 1
			then
				local newKey = string.sub(keys[i], #NUMBER_KEY_HEADER + 1)
				table[newKey] = values[i]
				table[keys[i]] = nil
			end
			if type(values[i]) == "table"
			then
				helperRecursiveNumberCorrector(values[i])
			end
		end
		
	end
	helperRecursiveNumberCorrector(returnTable)
	return returnTable
end
