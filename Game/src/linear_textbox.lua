require("src.Textbox")
LinearTextbox = {}
setmetatable(LinearTextbox, {__index = Textbox})


function LinearTextbox.setText(self, text)
	
	text = tostring(text)
	Textbox.setText(self, text)
	local current_font = self:getFont()
	local lines = 1
	for i = 1, #text
	do
		if (string.sub(text, i, i) == '\n')  
		then
			lines = lines + 1
		end
	end
	--if self._width_limit == nil
	--then
		self:__setWidth(current_font:getWidth(self._text))
		self:__setHeight(current_font:getHeight() * lines)
	--else
		--
	--	local characterLength = current_font:getWidth(" ") --Assumes monospaced font
	--	local charsPerLine = math.floor(self._width_limit / characterLength)
	--	local numLines = math.ceil(#self._text / charsPerLine)
		--[[local fullWidth = current_font:getWidth(self._text)
		--self.height = math.ceil(fullWidth / self._width_limit) * current_font:getHeight()
		
		if fullWidth > self._width_limit
		then
			self.width = self._width_limit
		else
			self.width = fullWidth
		end
		--]]
	--	self.__width = charsPerLine * characterLength
	--	self.__height = current_font:getHeight() * numLines
	--end
	
	
	
end
	

function LinearTextbox.draw(self)
	local theLoveFont = love.graphics.getFont() --used to store the current font so it an be restored after drawing
	r,g,b,a = love.graphics.getColor()
	love.graphics.setFont(self:getFont())
	love.graphics.setColor(self._color[1], self._color[2], self._color[3], self._color[4])
	love.graphics.print(self._text, self:getX(), self:getY())
	love.graphics.setColor(r,g,b,a)
	love.graphics.setFont(theLoveFont)
end


function LinearTextbox.new(str, font, color) --font is either specified font or will be whatever the default font is
	if not font then error(font) end
	local newTextbox = Textbox.__new(str, font, color)
	setmetatable(newTextbox, {__index = LinearTextbox})
	newTextbox:setText(str)
	return newTextbox
end
	


return LinearTextbox