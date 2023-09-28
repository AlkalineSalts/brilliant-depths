require("src.component_collection")
require("src.enterable_textbox")
require("src.drawable_image")
require("src.util")
SelectableBar = {}
setmetatable(SelectableBar, {__index = ComponentCollection})
function SelectableBar._shiftList(self, val)
	self._index = ((self._index + val) % (#self._text_list + 1))
	if self._index == 0
	then
		self._index = 1
	end
	self._enterable_textbox:setText(self._text_list[self._index])
end
function SelectableBar.getText()
	return self._enterable_textbox:getText()
end
function SelectableBar.new(text_list, enterable_textbox, arrow_image) --text_area_size in chars
	local right_arrow = DrawableImage.new(arrow_image, enterable_textbox:getHeight(), enterable_textbox:getHeight())
	local left_arrow = DrawableImage.new(arrow_image, enterable_textbox:getHeight(), enterable_textbox:getHeight())
	left_arrow:setX(0) left_arrow:setY(0)
	enterable_textbox:setX(left_arrow:getX() + left_arrow:getWidth())
	enterable_textbox:setEnterable(false)
	right_arrow:setX(enterable_textbox:getX() + enterable_textbox:getWidth())
	local self = ComponentCollection.new(left_arrow, enterable_textbox, right_arrow)
	setmetatable(self, {__index = SelectableBar})
	self._enterable_textbox = enterable_textbox
	self._left_arrow = left_arrow
	self._right_arrow = right_arrow
	self._text_list = table.shallowCopy(text_list)
	for _, str in ipairs(self._text_list)
	do
		if not self._enterable_textbox:textCanFit(str)
		then
			error(string.format("String '%s' length must be no greater than this enterable textbox's text limit of %d", str, self._enterable_textbox:stringSizeLimit()))
		end
	end
	self._index = 1	
	self._enterable_textbox:setText(self._text_list[self._index])
	self._left_arrow.click = function() self:_shiftList(-1) end
	self._right_arrow.click = function() self:_shiftList(1) end
	return self
end