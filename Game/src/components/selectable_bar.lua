require("src.components.component_collection")
require("src.components.enterable_textbox")
require("src.components.drawable_image")
require("src.util")
require("src.next_previous")
require("src.components.textbox")
SelectableBar = {}
setmetatable(SelectableBar, {__index = ComponentCollection})

function SelectableBar._textChanged(self)
	--Move arrow right arrow to proper position, further refactoring necessary to enable this
	
	
	
	--Process callback
	self:textChanged()
end
function SelectableBar.textChanged(self)
	
end
function SelectableBar.getText(self)
	return self._enterable_textbox:getText()
end
function SelectableBar.new(next_previous, enterable_textbox_builder, arrow_image) --text_area_size in chars
	local enterable_textbox = enterable_textbox_builder:build()
	
	local arrow_image = arrow_image or love.graphics.newImage("Images/arrow_square_right.png")
	local left_arrow_image = left_arrow_image or love.graphics.newImage("Images/arrow_square_left.png")
	local right_arrow = DrawableImage.new(arrow_image, enterable_textbox:getHeight(), enterable_textbox:getHeight())
	local left_arrow = DrawableImage.new(left_arrow_image, enterable_textbox:getHeight(), enterable_textbox:getHeight())
	left_arrow:setX(0) left_arrow:setY(0)
	enterable_textbox:setX(left_arrow:getX() + left_arrow:getWidth())
	enterable_textbox:setEnterable(false)
	right_arrow:setX(enterable_textbox:getX() + enterable_textbox:getWidth())
	local self = ComponentCollection.new(left_arrow, enterable_textbox, right_arrow)
	setmetatable(self, {__index = SelectableBar})
	
	if enterable_textbox.textChanged ~= Textbox.textChanged then error("Illegal State, enterableTextbox cannot have a textChanged callback.") end
	enterable_textbox.textChanged = function() self:_textChanged() end --When its text changes, calls selectable bar textChanged
	
	self._enterable_textbox = enterable_textbox
	self._left_arrow = left_arrow
	self._right_arrow = right_arrow
	self._next_previous = next_previous
	self._enterable_textbox:setText(next_previous:current())
	self._left_arrow.click = function() 
		local current = self._next_previous:current()
		self._next_previous:previous() 
		if current ~= self._next_previous:current()
		then
			self._enterable_textbox:setText(self._next_previous:current()) 
		end
	end
	self._right_arrow.click = function() 
		local current = self._next_previous:current()
		self._next_previous:next() 
		if current ~= self._next_previous:current()
		then
			self._enterable_textbox:setText(self._next_previous:current()) 
		end
	end
	return self
end