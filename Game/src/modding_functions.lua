local DepthInfo = require("src.depth_info")
require("src.tasks")
function getEventSaveLocation(event, saveData)
	local event_data = saveData.event_data
	local event_name = event:get_name()
	local this_event_data_table = event_data[event_name]
	if this_event_data_table
	then
		return this_event_data_table
	else
		this_event_data_table = {}
		event_data[event_name] = this_event_data_table
		return this_event_data_table
	end
end
	
function getLayer()
	return DepthInfo.getLayerFromNumber(GameManager.saveData.layer)
end

function getNumberOfLayers()
	return DepthInfo.getNumberOfLayers()
end