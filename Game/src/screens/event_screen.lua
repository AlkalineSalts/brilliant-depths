require("src.util")
require("src.screen")
require("src.component")
require("src.clickable_textbox")
require("src.enterable_textbox")
require("src.word_downshift_textbox")
require("src.verticle_collection")
require("src.linear_textbox")
require("src.transition.simple_transition")
EventScreen = {}
setmetatable(EventScreen, {__index = Screen})

--Added to the textboxes, will process the option and get the next event. If next event is nil, return to the mainscreen.

local function createSelectOption(option)
	local function selectOption()
		option:select(GameManager.saveData)
		local nextEvent = option:get_next_event_name()
		if nextEvent
		then
			GameManager.changeScreen(EventScreen.new(nextEvent))
		else
			GameManager.changeScreen(MainScreen.new())
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
	
	
	
	local options = event:get_options()
	local optionsBoxes = {}
	for _, option in ipairs(options)
	do
		local newTextbox = HighlightTextbox.new(WordDownshiftTextbox.new(option:get_text(), options_text_font, nil, Screen.width * 3/4))
		newTextbox.click = createSelectOption(option)
		optionsBoxes[#optionsBoxes + 1] = newTextbox
	end
	self._options_collection = VerticleCollection.new(table.unpack(optionsBoxes))
	self._options_collection:setX(self.topText:getX())
	self._options_collection:setY(self.topText:getY() / 2 + Screen.height / 2 - self.topText:getHeight() / 2)
	self:add(self._options_collection)
	
	return self
end

return EventScreen