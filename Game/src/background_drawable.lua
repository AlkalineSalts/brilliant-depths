require("src.component")
Background = {}
setmetatable(Background, {__index = Component})
function Background.click(self)
	self._component:click()
end
function Background.mouseOver(self, mouseOver)
	self._component:mouseOver(mouseOver)
end
function Background.getWidth(self)
	return self._outlinePixels * 2 + self._component:getWidth()
end
function Background.getHeight(self)
	return self._outlinePixels * 2 + self._component:getHeight()
end
function Background.setX(self, x)
	Component.setX(self, x)
	self._component:setX(x + self._outlinePixels)
end
function Background.setY(self, y)
	Component.setY(self, y)
	self._component:setY(y + self._outlinePixels)
end	
function Background.draw(self)
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self._color[1], self._color[2], self._color[3])
	love.graphics.rectangle("fill", self:getX(), self:getY(), self:getWidth(), self:getHeight())
	self._component:draw()
	love.graphics.setColor(r,g,b,a)
end
--Goes through the superclass or, if not found in superclass then acts as the self._component
local function customIndex(table, key) 
	if not val
	then
		val = Background[key]
		if val then print(key.." delegated to background") end
		if not val
		then
			val = rawget(table, "_component")[key]
			print(key.." delegated to ._component")
		end
	end
	return val
end
function Background.new(component, outlinePixels, color)
	local self = Component.new()
	setmetatable(self, {__index = customIndex})
	--Thinking of doing something spooky with the metatable, ask flores
	self._component = component
	self._outlinePixels = outlinePixels or 2
	self._color = color or {0,0,0}
	return self
end

return Background