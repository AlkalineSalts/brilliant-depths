require("src.screen")
require("src.horizontal_collection")
require("src.rectangular_component")
require("src.verticle_collection")
require("src.selectable_bar")
require("src.word_downshift_textbox")
require("src.linear_textbox")
ShopScreen = {}
setmetatable(ShopScreen, {__index = Screen})
function ShopScreen.new()
	local self = Screen.new()
	setmetatable(self, {__index = ShopScreen})
	local textFont = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 20)
	self.downShiftTextbox = WordDownshiftTextbox.new("You arrive at the shop. Here you can supply yourself for the voyage. In terms of food, I would recommend that you take approximately 10 pounds of food per day, 2 pieces of clothing for each person, and as many spare parts as you need.", textFont, nil, 700)
	local startingCurrencyTextbox = LinearTextbox.new(string.format("Starting Currency: %d", GameManager.saveData.currency), textFont)
	local rectComp = RectangularComponent.new()
	rectComp:setX(0) rectComp:setWidth(self.downShiftTextbox:getWidth()) rectComp:setHeight(3)
	
	
	local vc = VerticleCollection.new(self.downShiftTextbox, startingCurrencyTextbox, rectComp)
	
	
	Screen.centerComponentOnX(vc)
	Screen.centerComponentOnY(vc)
	
	self:add(vc)
	self:add(startingCurrencyTextbox)
	
	return self
end