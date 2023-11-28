require("src.item_properties")
Inventory = {}
setmetatable(Inventory, {__index = function(table, key) val = rawget(table, key) if val then return val else return 0 end end, __eq = tableEquality})
function Inventory.changeItemAmount(self, item_name, changeAmount)
	self[item_name] = self[item_name] + changeAmount 
	if self[item_name] < 1 
	then 
		self[item_name] = nil 
	end 
end

function Inventory.getTotalValue(self)
	total = 0
	for item_name, quantity in pairs(self)
	do
		total = total + ItemProperties.getItemProperties(item_name).price * quantity
	end
	return total
end

return Inventory