--for use in love2d
require("src.component")
require("src.util")
ComponentCollection = {} 
setmetatable(ComponentCollection, {__index = Component})
function ComponentCollection._forEachComponent(self, f) --f must take one argument only, component
	for _, component in ipairs(self._component_list)
	do
		f(component)
	end
end
function ComponentCollection.checkMouseOver(self, mouseX, mouseY)
	self._mouse_over_component = nil
	for _, component in ipairs(self._component_list)
	do
		if component:checkMouseOver(mouseX, mouseY)
		then
			self._mouse_over_component = component
			break
		end
	end
	return self._mouse_over_component
end

function ComponentCollection.mouseOver(self, mouseOver) 
	self:_forEachComponent(function(component) component:mouseOver(false) end)
	if mouseOver 
	then
		self._mouse_over_component:mouseOver(true)
	end
end

function ComponentCollection.isMouseOver(self)
	return  self._mouse_over_component
end

function ComponentCollection.draw(self)
	self:_forEachComponent(function(component) component:draw() end)
end
function ComponentCollection.click(self)
	if self._mouse_over_component
	then
		self._mouse_over_component:click()
	end
end
function ComponentCollection.getWidth(self)
	local minX = self._component_list[1]:getX()
	local maxX = self._component_list[1]:getX() + self._component_list[1]:getWidth()
	for _, component in ipairs(self._component_list)
	do
		minX  = math.min(minX, component:getX())
		maxX = math.max(maxX, component:getX() + component:getWidth())
	end
	return maxX - minX
end
function ComponentCollection.getHeight(self)
	local minY = self._component_list[1]:getY()
	local maxY = self._component_list[1]:getY() + self._component_list[1]:getHeight()
	for _, component in ipairs(self._component_list)
	do
		minY  = math.min(minY, component:getY())
		maxY = math.max(maxY, component:getY() + component:getHeight())
	end
	return maxY - minY
end
function ComponentCollection.setX(self, x)
	local diffX = x - self:getX(self)
	Component.setX(self, x)
	self:_forEachComponent(function(component) component:setX(component:getX() + diffX) end)
end
function ComponentCollection.setY(self, y)
	local diffY = y - self:getY()
	Component.setY(self, y)
	self:_forEachComponent(function(component) component:setY(component:getY() + diffY) end)
end
function ComponentCollection.add(self, c)
	self._component_list[#self._component_list + 1] = c
end

function ComponentCollection.new(...) --takes any # of components, will set the first component x y to this componenets x y. the x and y of all other components are moved relative to that shift
	local self = Component.new()
	setmetatable(self, {__index = ComponentCollection})
	if not {...} then error("Must give at least one component") end
	if #{...} < 1 then error("Must give at least one component") end
	self._component_list = {...}
	--Makes it so that this x y is equal to first component x y 
	local currentX = Component.getX(self) --Will be zero for getX, getY, but incase changes
	local currentY = Component.getY(self)
	local first = table.unpack({...})
	Component.setX(self, first:getX())
	Component.setY(self, first:getY())
	self:setX(currentX)
	self:setY(currentY)
	self._mouse_over_component = nil --stores which component the mouse is over
	return self
end

return ComponentCollection