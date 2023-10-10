Builder = {}
--require("src.util")

function Builder._callFunction(self, functionName, argsList)
	local callStruct = {}
	callStruct.name = functionName
	callStruct.args = argsList
	callStruct.type = "function" --the default
	return callStruct
end

function Builder.callFunction(self, functionName, ...)
	self._functionList[#self._functionList + 1] = self:_callFunction(functionName, {...})
end

function Builder.callMethod(self, functionName, ...)
	local callStruct = self:_callFunction(functionName, {...})
	callStruct.type = "method"
	self._functionList[#self._functionList + 1] = callStruct
end

function Builder.setField(self, fieldName, value)
	local callStruct = self:_callFunction(fieldName, {value})
	callStruct.type = "field"
	self._functionList[#self._functionList + 1] = callStruct
end

local function checkErrorFunctionNotPresent(instance, functionName)
	if not instance[functionName]
	then
		error(string.format("function %s not in instance", functionName))
	end
end
	
function Builder.build(self)
	local newInstance = self._class.new(table.unpack(self._constructor_args))
	for _, callStruct in ipairs(self._functionList)
	do
		local name = callStruct.name
		if (callStruct.type == "method")
		then
			checkErrorFunctionNotPresent(newInstance, name)
			local args = table.shallowCopy(callStruct.args)
			table.insert(args, 1, newInstance)
			newInstance[name](table.unpack(args))
		elseif (callStruct.type == "field") then
			print(name)
			newInstance[name] = callStruct.args[1]
		else --if type is function
			checkErrorFunctionNotPresent(newInstance, name)
			newInstance[name](table.unpack(callStruct.args))
		end
	end
	return newInstance
end

function Builder.new(class, ...)
	local self = {}
	setmetatable(self, {__index = Builder})
	self._functionList = {} --stores a list of tables in the format of: "name" for function name, "args" as a list of arguments, "type" is "function" | "method" | "field"
	self._class = class
	self._constructor_args = {...}
	return self
end
	
	
	