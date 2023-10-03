require("src.screen")
require("src.word_downshift_textbox")
require("src.verticle_collection")
require("src.drawable_image")
NotifyScreen = {}
setmetatable(NotifyScreen, {__index = Screen})
function NotifyScreen.new(notifyText, returnScreen)
	local self = Screen.new()
	setmetatable(self, {__index = NotifyScreen})
	local textFont = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 20)
	local notifyTextbox = WordDownshiftTextbox.new(notifyText, textFont, nil, Screen.width/2)
	local arrow = DrawableImage.new(love.graphics.newImage("Images/arrow_square_left.png"), 40, 40)
	Screen.centerComponentUnderComponent(arrow, notifyTextbox)
	arrow.click = function(self) GameManager.changeScreen(returnScreen) end
	
	
	local vert = VerticleCollection.new(notifyTextbox, arrow)
	Screen.centerComponentOnX(vert)
	Screen.centerComponentOnY(vert)
	
	self:add(vert)
	
	
	
	return self
end
