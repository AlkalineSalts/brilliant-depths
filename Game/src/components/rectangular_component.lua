require("src.component")
require("src.util")
RectangularComponent = {}
setmetatable(RectangularComponent, {__index = Component})
function RectangularComponent.draw(self)
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(table.unpack(self._color))
	love.graphics.rectangle("fill", self:getX(), self:getY(), self:getWidth(), self:getHeight())
	love.graphics.setColor(r, g, b, a)
end

function RectangularComponent.setWidth(self, width)
	Component.__setWidth(self, width)
end
function RectangularComponent.setHeight(self, height)
	Component.__setHeight(self, height)
end

function RectangularComponent.new(x, y, width, height, color)
	local self = Component.new(x, y, width, height)
	setmetatable(self, {__index = RectangularComponent})
	self._color = color or {1,1,1,1}
	return self
end