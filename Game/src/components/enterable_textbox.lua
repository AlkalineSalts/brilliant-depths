EnterableTextbox = {}
require("src.components.linear_textbox")
--This is a final class
setmetatable(EnterableTextbox, {__index = LinearTextbox})
function EnterableTextbox.click(self)
	if self._enterable
	then
		self._original_listener = GameManager.inputProcessor
		GameManager.inputProcessor = self
	end
end
function EnterableTextbox._deselect(self)
	GameManager.inputProcessor = self._original_listener
end
function EnterableTextbox.setValidChars(self, pattern)
	if not pattern
	then
		error("pattern cannot be nil")
	else
		self._valid_chars_pattern = pattern
	end
end
function EnterableTextbox.textCanFit(self, text)
	return #text <= self._max_chars
end
function EnterableTextbox.stringSizeLimit(self)
	return self._max_chars
end
function EnterableTextbox.setText(self, text)
	text = tostring(text)
	if self:textCanFit(text)
	then
		LinearTextbox.setText(self, text)
	end
end
function EnterableTextbox.setEnterable(self, bool)
	self._enterable = bool
end
function EnterableTextbox.keypressed(self, key, scancode, isrepeat)
	--preprocessing for space key
	if key == "space"
	then
		key = " "
	end
	
	if string.match(key, self._valid_chars_pattern)
	then
		if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")
		then
			key = string.upper(key)
		end
		self:setText(self:getText()..key)
		
	else if key == "backspace"
		then
		self:setText(string.sub(self:getText(), 1, -2))
	end
	end
end

function EnterableTextbox.mousepressed(self, x, y, number, istouch)

end

function EnterableTextbox.mousereleased(self, x, y, number, istouch)
	if not self:checkMouseOver(x, y)
	then
		self:_deselect()
		GameManager.inputProcessor:mousereleased(x, y, number, istouch)
	end
end

function EnterableTextbox.mousefocus(self, is_m_focused)
	
end
--Is meant to define the size of the area that must be clicked on to start typing
function EnterableTextbox.getWidth(self)
	return self.___width
end
function EnterableTextbox.getHeight(self)
	return self.___height
end
function EnterableTextbox.draw(self)
	r,g,b,a = love.graphics.getColor()
	love.graphics.setColor(self:getColor())
	love.graphics.setFont(self:getFont())
	LinearTextbox.draw(self)
	love.graphics.setColor(r,g,b,a)
	
end
function EnterableTextbox.new(max_chars, font, color)
	local self = LinearTextbox.new("", font, color)
	setmetatable(self, {__index = EnterableTextbox})
	self.___width = self:getFont():getWidth(" ") * max_chars
	self.___height = self:getFont():getHeight()
	self._max_chars = max_chars
	self._valid_chars_pattern = "^[%a ]$"
	self._enterable = true
	--_original_listener is am instance variable of this class
	return self
end

return EnterableTextbox