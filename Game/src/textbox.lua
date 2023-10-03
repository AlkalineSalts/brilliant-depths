require("src.component")
--Abstract class, should not be directly instantiated
Textbox = {}
setmetatable(Textbox, {__index = Component})

function Textbox.getFont(self)
	return self._font 
end

function Textbox.usesDefaultFont(self)
	return self._font == nil
end

function Textbox.setFont(self, font) --if nil, self._font will be the default font, as seen in getFont
	self._font = font
end

function Textbox.setText(self, text) --_text is the raw text, not modified for display
	if text == nil
	then
		text = ""
	end
	self._text = text 
	self:textChanged()
end

function Textbox.getText(self)
	return self._text
end

function Textbox.click(self)
end

function Textbox.textChanged(self)
end

function Textbox.draw(self)
	
end
function Textbox.setColor(self, color)
	self._color = color or {1, 1, 1}
end

function Textbox.getColor(self)
	return self._color
end

function Textbox.__new(str, font, color) --font is either specified font or will be whatever the default font is
	newTextbox = Component.new()
	setmetatable(newTextbox, {__index = Textbox})
	newTextbox:setFont(font)
	newTextbox:setColor(color)
	--self._color is a protected field
	newTextbox:setText(str) 
	return newTextbox
end
	


return Textbox