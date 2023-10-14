require("src.util")
local DepthInfo = {}
local function createStruct(depthMin, depthMax, layer_n)
	return {depthMinimum = depthMin, depthMaximum = depthMax, layer_name = layer_n, layer_image = love.graphics.newImage("Images/"..layer_n..".png")}
end

local dataTable = {}
dataTable[1] = createStruct(0, 1000, "layer1")
dataTable[2] = createStruct(1000, 3000, "layer2")
dataTable[3] = createStruct(3000, 7000, "layer3")
dataTable[4] = createStruct(7000, 10000, "layer4")
dataTable[5] = createStruct(10000, 13000, "layer5")

function DepthInfo.getLayerFromDepth(depth)
	--find datatable
	local correctLayer = nil
	for _, table in ipairs(dataTable)
	do
		if table.depthMinimum <= depth
		then
			correctLayer = table
			break
		end
	end
	if not correctLayer
	then
		error(string.format("%d is not a valid depth", depth))
	end
	--Copy table
	return table.shallowCopy(correctLayer)
end

return DepthInfo