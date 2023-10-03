require("src.component_collection")
require("src.enterable_textbox")
require("src.drawable_image")
require("src.util")
require("src.next_previous")
SelectableBar = {}
setmetatable(SelectableBar, {__index = ComponentCollection})

function SelectableBar.getText(self)
	return self._enterable_textbox:getText()
end
function SelectableBar.new(next_previous, enterable_textbox, arrow_image) --text_area_size in chars
	arrow_image = arrow_image or love.graphics.newImage("Images/arrow_square_right.png")
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
	self._next_previous = next_previous
	self._enterable_textbox:setText(next_previous:current())
	self._left_arrow.click = function() self._next_previous:previous() self._enterable_textbox:setText(self._next_previous:current()) end
	self._right_arrow.click = function() self._next_previous:next() self._enterable_textbox:setText(self._next_previous:current()) end
	return self
end