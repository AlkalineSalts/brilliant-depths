require("src.party_member")
local DepthInfo = require("src.depth_info")

function getPotentialEventFromName(groupName)
	local status, event = pcall(GameManager.eventManager.get_event, GameManager.eventManager, groupName, GameManager.saveData)
	--If expected error ignore, repeat error if not expected error {done a bit dirty}
	if not status 
	then
		
		if not string.find(event or "", "No valid next event in event group")
		then
			error(event)
		else
			event = nil
		end
	end	
	return event
end

function getThisTurnEvent()
	return getPotentialEventFromName("terminal_events") or getPotentialEventFromName("priority_events")
end

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