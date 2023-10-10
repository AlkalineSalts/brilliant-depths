require("src.util")
require("src.screen")
require("src.builder")
require("src.component_collection")
require("src.horizontal_collection")
require("src.rectangular_component")
require("src.verticle_collection")
require("src.selectable_bar")
require("src.word_downshift_textbox")
require("src.next_previous")
require("src.linear_textbox")
require("src.item_properties")
ShopScreen = {}
setmetatable(ShopScreen, {__index = Screen})

function ShopScreen._calculateTotal(self)
	self.total = 0
	for _, textbox in ipairs(self.verticleTextbox)
	do
		self.total = self.total + tonumber(textbox:getText())
	end
	self.totalPrice:setText(string.format("%9d", self.total))
end

function ShopScreen.new()
	local self = Screen.new()
	setmetatable(self, {__index = ShopScreen})
	self.total = 0
	local textFont = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 20)
	self.downShiftTextbox = WordDownshiftTextbox.new("You arrive at the shop. Here you can supply yourself for the voyage. In terms of food, I would recommend that you take approximately 10 pounds of food per day, 2 pieces of clothing for each person, and as many spare parts as you need.", textFont, nil, 700)
	local startingCurrencyTextbox = LinearTextbox.new(string.format("Starting Currency: %d", GameManager.saveData.currency), textFont)
	local rectComp = RectangularComponent.new()
	
	

	
	
	local vc = VerticleCollection.new(self.downShiftTextbox, startingCurrencyTextbox)
	local function createLine()
		local rectComp = RectangularComponent.new()
		rectComp:setX(0) rectComp:setWidth(vc:getWidth()) rectComp:setHeight(3)
		return rectComp
	end
	vc:add(createLine())
	
	
	
	local selectionFont = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 24)
	
	
	
	
	
	--Could use refactoring, pretty vulnerable
	local items = {"Food", "Clothing", "Shot"}
	local next_previous = {NextPrevious.getNextPreviousForRange(0, 100, 0, 9999), NextPrevious.getNextPreviousForRange(0, 1, 0, 100), NextPrevious.getNextPreviousForRange(0, 20, 0, 9999)}
	local verticleItemName = {}
	local verticleNum = {}
	self.verticleTextbox = {}
	
	--Is entered last
	self.totalPrice = LinearTextbox.new("        0", selectionFont)
	local blankLine = RectangularComponent.new({1,1,1,1})
	blankLine:setWidth(vc:getWidth() - self.totalPrice:getWidth())
	local lastLineHorizontal = HorizontalCollection.new(blankLine, self.totalPrice)
	
	
	for i, item in ipairs(items)
	do
		self.verticleTextbox[i] = LinearTextbox.new("       0", selectionFont)
		verticleItemName[i] = LinearTextbox.new(string.format("%-22s", item), selectionFont)
		local _enterableTextbox_builder = Builder.new(EnterableTextbox, 4, selectionFont)
		_enterableTextbox_builder:setField("textChanged" , function(selfie) 
			local val = tonumber(selfie:getText()) * ItemProperties.getItemProperties(item).price
			self.verticleTextbox[i]:setText(string.format("%10d", val)) 
			self:_calculateTotal()
		end
	)
		
		verticleNum[i] = SelectableBar.new(next_previous[i], _enterableTextbox_builder)
	end
	local verticleItems = VerticleCollection.new(table.unpack(verticleItemName))
	local verticleNums = VerticleCollection.new(table.unpack(verticleNum))
	self.verticleTextboxes = VerticleCollection.new(table.unpack(self.verticleTextbox))
	local horizontalItems = HorizontalCollection.new(verticleItems, verticleNums)
	
	local clearRect = RectangularComponent.new({1,1,1,0})
	clearRect:setWidth(vc:getWidth() - horizontalItems:getWidth() - self.verticleTextbox[1]:getWidth())
	horizontalItems:add(clearRect)
	horizontalItems:add(self.verticleTextboxes)
	
	vc:add(horizontalItems)
	vc:add(createLine())
	
	
	
	 
	
	vc:add(lastLineHorizontal)
	
	
	Screen.centerComponentOnX(vc)
	Screen.centerComponentOnY(vc)
	self:add(vc)
	self:add(startingCurrencyTextbox)
	return self
end

return ShopScreen