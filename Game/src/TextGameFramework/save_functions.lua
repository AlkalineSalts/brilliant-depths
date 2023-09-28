function serialize (o, file_path)
file = love.filesystem.newFile(file_path):open("w")
file:write("return ")
local t = type(o)
	if t == "number" or t == "string" or t == "boolean" or t == "nil" 
then
    	file:write(string.format("%q", o))
        elseif t == "table" then
        	file:write("{\n")
            for k,v in pairs(o) do
            	file:write("  ", k, " = ")
                serialize(v, file)
                file:write(",\n")
			end
         file:write("}\n")
         else
         	error("cannot serialize a " .. type(o))
			file:close()
         end
file:close()
end
function deserialize(file_path)
	return love.filesystem.load(file_path)()
end
