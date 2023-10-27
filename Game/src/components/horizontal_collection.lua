
require("src.components.component_collection")
HorizontalCollection = {}
setmetatable(HorizontalCollection, {__index = ComponentCollection})
function HorizontalCollection.add(self, component)
	local addCompX = ComponentCollection.getX(self) + ComponentCollection.getWidth(self)
	component:setX(addCompX)
	ComponentCollection.add(self, component)
end

function HorizontalCollection.new(comp, ...)
	local self = ComponentCollection.new(comp)
	setmetatable(self, {__index = HorizontalCollection})
	for _, val in ipairs({...})
	do
		self:add(val)
	end
	return self
end	

return HorizontalCollection
	