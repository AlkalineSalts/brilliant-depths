require("src.util")
local DepthInfo = {}
local function createStruct(depthMin, depthMax, layer_n)
	return {depthMinimum = depthMin, depthMaximum = depthMax, layerName = layer_n, layer_image = love.graphics.newImage("Images/"..layer_n..".png")}
end

local dataTable = {}
dataTable[1] = createStruct(0, 1000, "layer1")
dataTable[2] = createStruct(1000, 3000, "layer2")
dataTable[3] = createStruct(3000, 7000, "layer3")
dataTable[4] = createStruct(7000, 10000, "layer4")
dataTable[5] = createStruct(10000, 13000, "layer5")

function DepthInfo.getLayerFromNumber(layerNum)
	--find datatable
	return table.shallowCopy(dataTable[layerNum])
end

function DepthInfo.getNumberOfLayers()
	return #dataTable
end

return DepthInfo