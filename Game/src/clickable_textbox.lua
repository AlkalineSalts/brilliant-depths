HighlightTextbox = {}
--setmetatable(Clickable_Textbox, {__index = Textbox})
--local selected_color = {255, 255, 0}
--This is a final class
function HighlightTextbox.draw(self)
	print(tostring(self:__isMouseOver()))
	if (self:__isMouseOver())
	then
		local real_color = self:getColor()
		local temp_color = self._select_color
		self:setColor(temp_color)
		self._draw(self)
		self:setColor(real_color)
	else
		self._draw(self)
	end

end
		

function HighlightTextbox.new(textbox, select_color)
	local newCT = {}
	newCT.draw = HighlightTextbox.draw
	setmetatable(newCT, {__index = textbox})
	newCT._draw = textbox.draw
	newCT._select_color = select_color or {255, 255, 0} --color when selected
	return newCT
end

return HighlightTextbox