require("src.component_collection")
FixedSizeCollection = {}
function FixedSizeCollection.makeFixedSize(component_collection, width, height)
	if not component_collection then error("Must use a component collection") end
	if width then component_collection.getWidth = function() return width end end
	if height then component_collection.getHeight = function() return height end end
	return component_collection
end
return FixedSizeCollection