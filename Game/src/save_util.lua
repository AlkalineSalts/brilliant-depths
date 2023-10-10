require("src.TextGameFramework.save_functions")
require("src.util")
require("src.party_member")
SaveUtil = {}
--tableEquality defined in util
local function initializeSaveData(table)
	setmetatable(table.inventory, {__index = function(table, key) val = rawget(table, key) if val then return val else return 0 end end, __eq = tableEquality}) --When inventory doesn't have an item, returns 0
	for _, party_member in pairs(table.party)
	do
		setmetatable(party_member, {__index = PartyMember})
	end
end
function SaveUtil.loadSaveData(savePath)
	local data = deserialize(savePath)
	initializeSaveData(data)
	return data
end
function SaveUtil.getDefaultSaveData()
	local data = {inventory = {}, party = {}, currency = 0, misc = {}}
	initializeSaveData(data)
	return data
end
function SaveUtil.saveData(table, savePath)
	serialize(table, savePath)
end

function SaveUtil.copyFromSourceToWritableAreaIfNotPresentThere(dirname) --internal directory is distinguished by having _ in front of it
	local internal_filepath= "_"..dirname
	local function copyHelper(path)
		local data = love.filesystem.getInfo(path)
		if data.type == "directory"
		then
			local files = love.filesystem.getDirectoryItems(path)
			love.filesystem.createDirectory(string.sub(path, 2))
			for _, file in ipairs(files)
			do
				copyHelper(path.."/"..file)
			end
		else --if file
			local internalData = love.filesystem.read(path)
			love.filesystem.write(string.sub(path, 2), internalData)
		end
	end
	if not love.filesystem.getInfo(dirname, {})
	then
		copyHelper(internal_filepath)
	end
end
			