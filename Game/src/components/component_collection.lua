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
	if #self._component_list == 0 then return 0 end
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
	if #self._component_list == 0 then return 0 end
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

function ComponentCollection.clear(self)
	self._component_list = {}
end

function ComponentCollection.remove(self, component)
	local index = nil
	for i, c in ipairs(self._component_list)
	do
		if c == component
		then
			index = i
		end
	end
	if index then 
		table.remove(self._component_list, index)
	end
	
end

function ComponentCollection.new(...) --takes any # of components
	local self = Component.new()
	setmetatable(self, {__index = ComponentCollection})
	self._component_list = {...}
	self._mouse_over_component = nil --stores which component the mouse is over
	return self
end

return ComponentCollection