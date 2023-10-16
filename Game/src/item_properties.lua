local InternalItemProperties = {}
ItemProperties = {}
function ItemProperties.addItemProperties(name, price)
	if type(name) ~= "string"
	then
		error(string.format("item name must be a string (was %s)", type(name)))
	end
	InternalItemProperties[name] = {price = price or 10}
end

function ItemProperties.getItemProperties(item_name)
	if type(item_name) ~= "string"
	then
		error(string.format("item name must be a string (was %s)", type(item_name)))
	end
	return InternalItemProperties[item_name]
end


ItemProperties.addItemProperties("Food", 0.1)
ItemProperties.addItemProperties("Clothing", 5)
ItemProperties.addItemProperties("Shot", 0.2)
ItemProperties.addItemProperties("Rope", 10)
ItemProperties.addItemProperties("Medical Supplies", 20)


return ItemProperties