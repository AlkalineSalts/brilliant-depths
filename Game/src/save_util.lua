require("src.TextGameFramework.save_functions")
require("src.util")
require("src.party_member")
SaveUtil = {}

--Keep randomseed to self
local setRandomSeed = math.randomseed
math.randomseed = function() error("I have removed the ability to set the random seed.") end

--tableEquality defined in util
local function initializeSaveData(table)
	setRandomSeed(table.randomseed)
	table.inventory.changeItemAmount = function(self, item_name, changeAmount) self[item_name] = self[item_name] + changeAmount if self[item_name] < 1 then self[item_name] = nil end end
	setmetatable(table.inventory, {__index = function(table, key) val = rawget(table, key) if val then return val else return 0 end end, __eq = tableEquality}) --When inventory doesn't have an item, returns 0
	for _, party_member in pairs(table.party)
	do
		setmetatable(party_member, {__index = PartyMember})
	end
	
	
	table.party.getAverageHealth = function (self)
		local health_avg = 0
		for _, member in ipairs(self)
		do
			health_avg = health_avg + member:getNumericHealthState()
		end
		health_avg = health_avg / #self
		return PartyMember.getHealthStateForNumber(health_avg)
	end
	
	table.party.findPartyMembers = function (self, boolFunc)
		local list = {}
		for _, member in ipairs(self)
		do
			if boolFunc(member) then list[#list + 1] = member end
		end
		return list
	end
	
	
	
end
function SaveUtil.loadSaveData(savePath)
	local data = deserialize(savePath)
	initializeSaveData(data)
	return data
end
function SaveUtil.getDefaultSaveData()
	local data = {randomseed = getSystemTime(), inventory = {}, party = {}, event_data = {}, currency = 0, misc = {}, day = 1, depth = 0, layer = 1, traveling_speed = PartyMember.TravelingSpeed.Balanced, food_consumption_amount = PartyMember.FoodAmount.Hearty}
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

