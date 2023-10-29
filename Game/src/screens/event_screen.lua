require("src.util")
require("src.screen")
require("src.component")
require("src.components")
require("src.transition.simple_transition")
local Color = require("src.color")
EventScreen = {}
setmetatable(EventScreen, {__index = Screen})

--Added to the textboxes, will process the option and get the next event. If next event is nil, return to the mainscreen.

local function createSelectOption(option)
	local function selectOption()
		option:select(GameManager.saveData)
		local nextEvent = option:get_next_event_name() --nextEvent is a string or nil at this point
		
		--If not nil, then get the next event from the name, has the potential to become nil
		::top::
		if nextEvent == nil
		then
			GameManager.changeScreen(MainScreen.new())
		elseif isInstanceOf(nextEvent, Screen)
		then
			GameManager.changeScreen(nextEvent)
		elseif type(nextEvent) == "string"
		then 
			nextEvent = getPotentialEventFromEventGroup(nextEvent)
			if nextEvent == nil then goto top end
			GameManager.changeScreen(EventScreen.new(nextEvent))
		else
			error(string.format("Result from get_next_event_name was neither a subclass of screen or a string name"))
		end
	end
	return selectOption
end

function EventScreen.new(event)
	self = Screen.new()
	setmetatable(self, {__index = EventScreen})
	local event_text_font = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 25)
	local options_text_font = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 20)
	self.topText = WordDownshiftTextbox.new(event:get_text(GameManager.saveData), event_text_font, nil, Screen.width * 3/4)
	self.topText:setX(Screen.width/8)
	self:add(self.topText)
	
	
	
	local options = event:get_options(GameManager.saveData)
	local optionsBoxes = {}
	for _, option in ipairs(options)
	do
		local newTextbox = WordDownshiftTextbox.new(option:get_text(), options_text_font, nil, Screen.width * 3/4)
		--This is more like an inverse, if it isn't selectable, do not make it selectable.
		if option:is_selectable(GameManager.saveData) 
		then
			newTextbox:setColor(Color.WHITE)
			newTextbox = HighlightTextbox.new(newTextbox)
			newTextbox.click = createSelectOption(option)
		else
			newTextbox:setColor(Color.GREY)
		end
		optionsBoxes[#optionsBoxes + 1] = newTextbox
	end
	
	if #optionsBoxes > 0
	then
		self._options_collection = VerticleCollection.new(table.unpack(optionsBoxes))
		self._options_collection:setX(self.topText:getX())
		self._options_collection:setY(self.topText:getY() / 2 + Screen.height / 2 - self.topText:getHeight() / 2)
		self:add(self._options_collection)
	end
	return self
end

return EventScreen