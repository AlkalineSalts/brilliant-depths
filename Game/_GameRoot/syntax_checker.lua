#!/bin/bash/lua
--[[Point of this script is to check if a script is syntactically correct 
even thought required superclasses and superclass methods aren't present. 
This script sets that environment for them. 
--]]
function tableSet(table, index) --Whenever a global table is needed, it creates a blank one and will have that table return blank tables if called upon
	--table has been called, no index found
	local ret_table = {}
	print("h")
	setmetatable(ret_table, {__index = tableSet})
	print("g")
	table[index] = ret_table
	print("p")
	return ret_table
end
--setmetatable(_G, {__index = tableSet})
