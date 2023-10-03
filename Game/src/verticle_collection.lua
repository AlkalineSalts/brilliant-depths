
require("src.component_collection")
VerticleCollection = {}
setmetatable(VerticleCollection, {__index = ComponentCollection})
function VerticleCollection.add(self, component)
	local addCompY = ComponentCollection.getY(self) + ComponentCollection.getHeight(self)
	component:setY(addCompY)
	ComponentCollection.add(self, component)
end

function VerticleCollection.new(comp, ...)
	local self = ComponentCollection.new(comp)
	setmetatable(self, {__index = VerticleCollection})
	for _, val in ipairs({...})
	do
		self:add(val)
	end
	return self
end	
	
return VerticleCollection
	