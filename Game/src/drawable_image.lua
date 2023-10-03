require("src.component")
DrawableImage = {}
setmetatable(DrawableImage, {__index = Component})
function DrawableImage.draw(self)
	love.graphics.draw(self._image, self:getX(), self:getY(), 0, self:getWidth() / self._image:getWidth(), self:getHeight() / self._image:getHeight())
end
function DrawableImage.setImage(self, image)
	self._image = image
end
function DrawableImage.new(image, width, height)
	self = Component.new()
	setmetatable(self, {__index = DrawableImage})
	self._image = image
	self:__setWidth(width or image:getWidth())
	self:__setHeight(height or image:getHeight())
	return self
end