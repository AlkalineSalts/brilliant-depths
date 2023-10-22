require("src.party_member")
local DepthInfo = require("src.depth_info")

local function eatFood(saveData)
end

local function changeHealth(saveData)
end

function increaseDay(saveData)
	saveData.day = saveData.day + 1
	eatFood(saveData)
	changeHealth(saveData)
end
function progress(saveData)
	local depth_info = DepthInfo.getLayerFromNumber(saveData.layer)
	local originalDepth = saveData.depth
	if saveData.traveling_speed == PartyMember.TravelingSpeed.Balanced
	then
		saveData.depth = saveData.depth + 30
	elseif saveData.traveling_speed == PartyMember.TravelingSpeed.Strenuous
	then
		saveData.depth = saveData.depth + 40
	elseif saveData.traveling_speed == PartyMember.TravelingSpeed.Grueling
	then
		saveData.depth = saveData.depth + 50
	end
	
	saveData.depth = math.min(saveData.depth, depth_info.depthMaximum)
	if saveData.depth ~= originalDepth
	then
		increaseDay(saveData)
	end
end