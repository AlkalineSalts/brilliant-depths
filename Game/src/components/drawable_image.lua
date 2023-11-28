require("src.component")
DrawableImage = {}
setmetatable(DrawableImage, {__index = Component})
function DrawableImage.draw(self)
	if self._image ~= nil
	then
	love.graphics.draw(self._image, self:getX(), self:getY(), 0, self:getWidth() / self._image:getWidth(), self:getHeight() / self._image:getHeight())
	end
end
function DrawableImage.setImage(self, image)
	self._image = image
end
function DrawableImage.new(image, width, height)
	self = Component.new()
	setmetatable(self, {__index = DrawableImage})
	if type(image) == "string"
	then
		image = love.graphics.newImage(image)	
	end
	self._image = image
	local imageWidth, imageHeight
	if image
	then
		imageWidth = image:getWidth()
		imageHeight = image:getHeight()
	end 
	self:__setWidth(math.ceil(width or imageWidth))
	self:__setHeight(math.ceil(height or imageHeight))
	return self
end