require("src.component")
DrawableQuad = {}
setmetatable(DrawableQuad, {__index = Component})
local function convert2Dto1D(x, y, columnNumbers)
	return x + ((y - 1) * columnNumbers)
end

function DrawableQuad.draw(self)
	if self._image ~= nil
	then
		love.graphics.draw(self._image, self._quads[convert2Dto1D(self._initialImageQuadX, self._initialImageQuadX, self.quadHeight)], self:getX(), self:getY())
	end
end

function DrawableQuad.selectQuad(self, x, y)
	self._initialImageQuadX = x
	self._initialImageQuadY = y
end

function DrawableQuad.new(image, imagesOnRows, imagesOnColumns, initialImageQuadX, initialImageQuadY)
	self = Component.new()
	setmetatable(self, {__index = DrawableQuad})
	if (not imagesOnRows or not imagesOnColumns) or imagesOnRow <= 0 or imagesOnColumns <= 0
	then
		error ("Must supply imagesOnRows and ImagesOnColumns, must be greater then 0")
	end
	
	if type(image) == "string"
	then
		image = love.graphics.newImage(image)	
	end
	self._image = image
	self.quadWidth = image:getWidth() / imagesOnRows
	self.quadHeight = image:getHeight() / imagesOnColumns
	self._imageQuadX = initialImageQuadX or 1
	self._imageQuadY = initialImageQuadY or 1
	
	--create quads in 1 dimensional array`
	self._quads = {}
	for h = 1, imagesOnColumns
	do
		for w = 1, imagesOnRows
		do
			self._quads[convert2Dto1D(w, h, imagesOnColumns)] = love.graphics.newQuad(w - 1, h - 1, self.quadWidth, self.quadHeight)
		end
	end
	
	
	
	self:__setWidth(self.quadWidth)
	self:__setHeight(self.quadHeight)
	return self
end