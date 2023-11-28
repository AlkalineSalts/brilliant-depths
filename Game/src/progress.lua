require("src.party_member")
local DepthInfo = require("src.depth_info")
require("src.modding_functions")

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
	local layer = getLayer()
	local layer_event = nil
	if math.random() <= layer.eventProbability
	then
		layer_event = getPotentialEventFromName(layer.layerName)
	end
	return getPotentialEventFromName("terminal_events") or getPotentialEventFromName("priority_events") or layer_event
end

local FOOD_CONSUMPTION_RATE = 5

local function eatFood(saveData)
	local food_consumption_rate
	if saveData.food_consumption_amount == PartyMember.FoodAmount.Hearty
	then
		food_consumption_rate = FOOD_CONSUMPTION_RATE
	elseif saveData.food_consumption_amount == PartyMember.FoodAmount.Meager
	then
		food_consumption_rate = math.floor(FOOD_CONSUMPTION_RATE * 0.8)
	elseif saveData.food_consumption_amount == PartyMember.FoodAmount.Sparse
	then
		food_consumption_rate = math.floor(FOOD_CONSUMPTION_RATE * 0.6)
	end
	local changeFoodBy = -food_consumption_rate * #saveData.party
	saveData.inventory:changeItemAmount("Food", changeFoodBy)
end

local DAY_HEALTH_INCREASE = 2

local function changeHealth(saveData)
	saveData.party:changeHealthNumericForAll(DAY_HEALTH_INCREASE)
end

function increaseDay(saveData)
	saveData.day = saveData.day + 1
	eatFood(saveData)
	changeHealth(saveData)
end
function progress(saveData)
	local depth_info = DepthInfo.getLayerFromNumber(saveData.layer)
	local originalDepth = saveData.depth
	local healthReduction
	local traveling_distance
	if saveData.traveling_speed == PartyMember.TravelingSpeed.Balanced
	then
		traveling_distance = 30
		healthReduction = DAY_HEALTH_INCREASE
	elseif saveData.traveling_speed == PartyMember.TravelingSpeed.Strenuous
	then
		traveling_distance = 40
		healthReduction = math.floor(DAY_HEALTH_INCREASE * 1.5)
	elseif saveData.traveling_speed == PartyMember.TravelingSpeed.Grueling
	then
		traveling_distance = 50
		healthReduction = DAY_HEALTH_INCREASE * 2
	end
	
	if saveData.going_down
	then
		saveData.depth = saveData.depth + traveling_distance
	else
		saveData.depth = saveData.depth - traveling_distance
	end
	
	if saveData.going_down
	then
		saveData.depth = math.min(saveData.depth, depth_info.depthMaximum)
	else
		saveData.depth = math.max(saveData.depth, depth_info.depthMinimum)
	end
	if saveData.depth ~= originalDepth
	then
		increaseDay(saveData)
		saveData.party:changeHealthNumericForAll(-healthReduction)
	end
end