require("src.TextGameFramework.save_functions")
require("src.util")
require("src.party_member")
require("src.party")
require("src.inventory")
SaveUtil = {}

--Keep randomseed to self
local setRandomSeed = math.randomseed
math.randomseed = function() error("I have removed the ability to set the random seed.") end

--tableEquality defined in util
local function initializeSaveData(table)
	setRandomSeed(table.randomseed)
	setmetatable(table.inventory, {__index = Inventory}) --When inventory doesn't have an item, returns 0
	for _, party_member in pairs(table.party)
	do
		setmetatable(party_member, {__index = PartyMember})
	end
	setmetatable(table.party, {__index = Party})
	
end
function SaveUtil.loadSaveData(savePath)
	local data = deserialize(savePath)
	initializeSaveData(data)
	return data
end
function SaveUtil.getDefaultSaveData()
	local data = {randomseed = getSystemTime(), inventory = {}, party = {}, event_data = {}, currency = 0, misc = {}, day = 1, depth = 0, going_down = true, layer = 1, traveling_speed = PartyMember.TravelingSpeed.Balanced, food_consumption_amount = PartyMember.FoodAmount.Hearty}
	initializeSaveData(data)
	return data
end
function SaveUtil.saveData(table, savePath)
	table.randomseed = math.random(-100000000, 100000000) -- randomseed is used to maintain consistent behavior between loads
	setRandomSeed(table.randomseed)
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

