require("src.party_member")
local DepthInfo = require("src.depth_info")
function progress(saveData)
	local depth_info = DepthInfo.getLayerFromDepth(saveData.depth)
	if saveData.traveling_speed == PartyMember.TravelingSpeed.Balanced
	then
		saveData.depth = saveData.depth + 20
	elseif saveData.traveling_speed == PartyMember.TravelingSpeed.Strenuous
	then
		saveData.depth = saveData.depth + 30
	elseif saveData.traveling_speed == PartyMember.TravelingSpeed.Grueling
	then
		saveData.depth = saveData.depth + 40
	end
	
	saveData.depth = math.min(saveData.depth, depth_info.depthMaximum)
	saveData.day = saveData.day + 1
end