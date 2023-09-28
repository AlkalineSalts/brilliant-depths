require("src.screen")
require("src.component")
require("src.clickable_textbox")
require("src.enterable_textbox")
require("src.word_downshift_textbox")
require("src.linear_textbox")
require("src.transition.simple_transition")
EventScreen = {}
setmetatable(EventScreen, {__index = Screen})

function TitleScreen.new(event)
	self = Screen.new()
	setmetatable(self, {__index = EventScreen})
	local width, height = love.graphics.getDimensions()
	local event_text_font = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 30)
	self.topText = WordDownshiftTextbox.new(event:get_text(), event_text_font, nil, width / 2)
	self.topText:setX(width/4)
	self:add(self.topText)
	
	return self
end

return TitleScreen