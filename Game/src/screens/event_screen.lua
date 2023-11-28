require("src.util")
require("src.screen")
require("src.component")
require("src.components")
require("src.save_util")
require("src.screens.sell_screen")
require("src.transition.simple_transition")
local DepthInfo = require("src.depth_info")
local Color = require("src.color")
EventScreen = {}
setmetatable(EventScreen, {__index = Screen})

--Added to the textboxes, will process the option and get the next event. If next event is nil, return to the mainscreen.
--local function


function createSelectOption(option)
	local function selectOption()
		
		option:select(GameManager.saveData)
		local nextEvent =  option:get_next_event_name(GameManager.saveData) --nextEvent is a string or nil at this point
		--Checks if game should end with terminal event
		local terminal_event = getPotentialEventFromName("terminal_events")
		if terminal_event then GameManager.changeScreen(EventScreen.new(terminal_event)) return end
		
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
			nextEvent = getPotentialEventFromName(nextEvent) --checks if an end game event is here, or otherwise try to find the next event
			if nextEvent == nil then goto top end
			GameManager.changeScreen(EventScreen.new(nextEvent))
		else
			error(string.format("Result from get_next_event_name was neither a subclass of screen or a string name"))
		end
	end
	return selectOption
end
function EventScreen.load(self)
	--This is likely a temporary solution
	if DepthInfo.getLayerFromNumber(GameManager.saveData.layer).music_name ~= AudioManager:getMusicName()
	then 
		AudioManager:stopMusic()
		AudioManager:setMusic(DepthInfo.getLayerFromNumber(GameManager.saveData.layer).music_name, true)
		AudioManager:playMusic()
	end
end
function EventScreen.new(event)
	self = Screen.new()
	setmetatable(self, {__index = EventScreen})
	event:initialize(GameManager.saveData)
	local event_text_font = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 20)
	local options_text_font = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 20)
	self.topText = WordDownshiftTextbox.new(event:get_text(GameManager.saveData), event_text_font, nil, Screen.width * 3/4)
	self.topText:setX(Screen.width/8)
	self:add(self.topText)
	
	
	GameManager.saveData.current_event = event:get_name()
	
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
	
	--Rectangular dividing live
	local dividingLine = RectangularComponent.new(0, self.topText:getY() + self.topText:getHeight(), self:getWidth(), 4, Color.WHITE)
	self:add(dividingLine)
	
	if #optionsBoxes > 0
	then
		self._options_collection = VerticleCollection.new(table.unpack(optionsBoxes))
		self._options_collection:setX(self.topText:getX())
		self._options_collection:setY(dividingLine:getY() + dividingLine:getHeight())
		self:add(self._options_collection)
	end
	return self
end

return EventScreen