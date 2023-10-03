--for use in love2d


Component = {} 
function Component.checkMouseOver(self, mouseX, mouseY)
	return self._x <= mouseX and self._x + self:getWidth() >= mouseX and self._y <= mouseY and self._y + self:getHeight() >= mouseY
end

function Component.mouseOver(self, mouseOver) --Used to set if the mouse is over this component
	if self._is_mouse_over and not mouseOver
	then
		self._is_mouse_over = mouseOver
	elseif not self._is_mouse_over and mouseOver
	then
		self._is_mouse_over = mouseOver
	end
	
end

function Component.__isMouseOver(self)
	return self._is_mouse_over
end

function Component.draw(self)
end
function Component.click(self)
end
function Component.getWidth(self)
	return self._width
end
function Component.getHeight(self)
	return self._height
end
function Component.__setWidth(self, width)
	self._width = width
end
function Component.__setHeight(self, height)
	self._height = height
end
function Component.setX(self, x)
	self._x = x
end
function Component.setY(self, y)
	self._y = y
end
function Component.getX(self)
	return self._x
end
function Component.getY(self)
	return self._y
end

function Component.new(x, y, width, height)
	local newComponent = {}
	newComponent._x = x or 0
	newComponent._y = y or 0
	newComponent._width = width or 0
	newComponent._height = height or 0
	newComponent._is_mouse_over = false --public, used by mouseOver, helps determine if mouse movement has changed for it's own purposes
	setmetatable(newComponent, {__index = Component})
	return newComponent
end

return Component