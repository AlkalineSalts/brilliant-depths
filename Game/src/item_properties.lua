local InternalItemProperties = {}
ItemProperties = {}
local DEFAULT_MINING_NAME = "Images/Mining/default_mining_symbol.png"
function ItemProperties.addItemProperties(name, price, mining_image_name)
	if type(name) ~= "string"
	then
		error(string.format("item name must be a string (was %s)", type(name)))
	end
	InternalItemProperties[name] = {price = price or 10, mining_image = mining_image_name or DEFAULT_MINING_NAME}
end

function ItemProperties.getItemProperties(item_name)
	if type(item_name) ~= "string"
	then
		error(string.format("item name must be a string (was %s)", type(item_name)))
	end
	local r = InternalItemProperties[item_name]
	if not r then error(item_name.." does not have any listed properties.") end
	return r
end


ItemProperties.addItemProperties("Food", 0.1)
ItemProperties.addItemProperties("Clothing", 5)
ItemProperties.addItemProperties("Shot", 0.2)
ItemProperties.addItemProperties("Rope", 10)
ItemProperties.addItemProperties("Medical Supplies", 20)
ItemProperties.addItemProperties("Odd Keystone", 50)


return ItemProperties