require("src.Textbox")
require("src.linear_Textbox")
WordDownshiftTextbox = {}
setmetatable(WordDownshiftTextbox, {__index = Textbox})


function WordDownshiftTextbox.setText(self, text)
	Textbox.setText(self, text)
	--seperate text based on newlines into arrays of words, with a newline assumed at the end of each word array and spaces in between of the internal arrays
	local word_array = {}
		--function to create an array of strs based on the pattern
	local function lineToArray(line, pattern)
			--Must add lastchar to line to work peoperly
			local word_array = {}
			local array_position = 1
			local in_line_pos = 1
			local start_index, end_index = string.find(line, pattern)
			while start_index and end_index
			do
				word_array[array_position] = string.sub(line, start_index, end_index - 1) --removes last character
				array_position = array_position + 1
				in_line_pos = end_index
				start_index, end_index = string.find(line, pattern, in_line_pos)
			end
			return word_array	
		end
	word_array = lineToArray(string.format("%s\n",text),  "[%a%d%p ]+\n")
	for i, v in ipairs(word_array)
	do
		word_array[i] = lineToArray(string.format("%s ", v), "[%a%d%p]+[%s]")
	end
	local current_font = self:getFont()
	local function sumPixelSizeOfStrings(array) --array of strings
		local SPACE_SIZE = current_font:getWidth(" ") 
		local size = 0
		local numSpaces = 0
		for _, v in ipairs(array)
		do
			size = size + current_font:getWidth(v)
			numSpaces = numSpaces + 1
		end
		if numSpaces > 0
		then
			numSpaces = numSpaces - 1
		end
		size = size + (numSpaces * SPACE_SIZE)
		return size 
	end
	local meta_new_table = {__index = function(table, key) local val = rawget(table, key) if not val then val = {} table[key] = val end return val end}
	--creates a new empty table if no table exists at index, used here to make it easier to write next section. Then metatable is discarded.
	setmetatable(word_array, meta_new_table)
	local line_index = 1
	while line_index <= #word_array
	do
		local string_arr = word_array[line_index]
		while sumPixelSizeOfStrings(string_arr) > self._width_limit
		do 
			local last_word = string_arr[#string_arr]
			if current_font:getWidth(last_word) >= self._width_limit --deals with exceptional case in which a word in the string is bigger than the limit
			then
				goto endInner
			else --regular case, pop word off line and move to front of the next line
				last_word = table.remove(string_arr) --reusing last_word, should have no effect on contents of last_word
				table.insert(word_array[line_index + 1], 1, last_word)
			end
			
		end
		::endInner::
		line_index = line_index + 1
	end
	setmetatable(word_array, nil)
	--Converts word_array to textboxes and sets this object's proper width and height
	self._textbox_array = {}
	for j, v in ipairs(word_array)
	do
		local line = table.concat(v, " ")
		self._textbox_array[#self._textbox_array + 1] = LinearTextbox.new(line, self:getFont(), self:getColor())
		self.__width = math.max(self._textbox_array[#self._textbox_array]:getWidth(), self:getWidth())
		self.__height = self:getHeight() + self._textbox_array[#self._textbox_array]:getHeight()
	end
end
	
function WordDownshiftTextbox.setX(self, x)
	Textbox.setX(self, x)
	for _, textbox in ipairs(self._textbox_array)
	do
		textbox:setX(x)
	end
end
function WordDownshiftTextbox.setY(self, y)
	Textbox.setY(self, y)
	if #self._textbox_array > 0
	then
		self._textbox_array[1]:setY(y)
		local totalHeightShift = self._textbox_array[1]:getHeight()
		for i = 2, #self._textbox_array
		do
			self._textbox_array[i]:setY(self:getY() + totalHeightShift)
			totalHeightShift = totalHeightShift + self._textbox_array[i]:getHeight()
		end
	end
end
function WordDownshiftTextbox.setColor(self, color)
	Textbox.setColor(self, color)
	local iter = 1
	for _, textbox in ipairs(self._textbox_array)
	do
		iter = iter + 1
		textbox:setColor(color)
	end
end
function WordDownshiftTextbox.setFont(self, font)
	Textbox.setFont(self, font)
	for _, textbox in ipairs(self._textbox_array)
	do
		textbox:setFont(font)
	end
end
	
function WordDownshiftTextbox.draw(self)
	local i = 1
	for j, textbox in ipairs(self._textbox_array)
	do
		textbox:draw()
	end

end


function WordDownshiftTextbox.new(str, font, color, width_limit) --font is either specified font or will be whatever the default font is
	local newTextbox = Textbox.__new(str, font, color)
	setmetatable(newTextbox, {__index = WordDownshiftTextbox})
	if not width_limit
	then
		error("Must specify width_limit to use this textbox.")
	end
	if width_limit <= 0
	then
		error("width_limit must be greater than s0.")
	end
	newTextbox._width_limit = width_limit
	newTextbox:setText(str)
	newTextbox:setColor(color)
	newTextbox:setFont(font)
	newTextbox:setY(0)
	newTextbox:setX(0)
	--variable textbox_array initialized in setText
	return newTextbox
end
	

return WordDownshiftTextbox