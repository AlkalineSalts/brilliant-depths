--[[
An option which can be selected in an event.
Parameters 
text - the text displayed in an option
should_be_visible - A boolean value which determines if option can be shown, even if
the option is not selectable


]]

Option = {_text = "Default", _should_be_visible = false}

--Replace this to create custom behavior, determines if the option can be clicked/visible
function Option.is_selectable(self, game_data)
	return true
end

function Option.should_be_seen(self, game_data)
	if (self:is_selectable(game_data))
	then
		return true
	else
		return self._should_be_visible
	end
end

--Replace with what to do when selected, returns nil
function Option.selected_action(self, game_data) 
	return
end

--Replace with a function that returns the name of the next event or event group
function Option.get_next_event_name()
	error("Must switch this with the next event or event group")
end
function Option.select(self, game_data) 
	if (self:is_selectable(game_data))
	then
		self:selected_action(game_data)
	else
		error("Attempted to select a non-selectable option ")
	end
end

function Option.get_text(self) -- Can be changed
	return self._text
end

function Option.__eq(first, second) --should not be changed
	return first._text == second._second
end

function Option.new(text, should_be_visible) --obviously should not be changed
	local o = {}
	local meta = {__index = Option, __eq = Option.__eq}
	setmetatable(o, meta)
	o._text = text
	o._should_be_visible = should_be_visible or true
	return o
end

return Option