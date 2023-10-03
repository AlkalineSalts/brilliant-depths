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
	local t = type(o)
	if t == "number" or t == "string" or t == "boolean" or t == "nil" 
	then
    	file:write(string.format("%q", o))
        elseif t == "table" then
        	file:write("{\n")
            for k,v in pairs(o) do
            	file:write("  ")
				file:write(k)
				file:write(" = ")
            	serializeHelper(v)
                file:write(",\n")
			end
         	file:write("}\n")
         else
         	error("cannot serialize a " .. type(o))
			file:close()
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
	return func()
end
