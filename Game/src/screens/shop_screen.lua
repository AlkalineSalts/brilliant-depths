require("src.util")
require("src.screen")
require("src.screens.main_screen")
require("src.builder")
require("src.components")
require("src.next_previous")
require("src.item_properties")
require("src.save_util")
ShopScreen = {}
setmetatable(ShopScreen, {__index = Screen})

local InnerItemRow = {}
InnerItemRow.font = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 24)
function InnerItemRow.getItemName(self)
	return self.itemNameTextbox:getText()
end

function InnerItemRow.getPrice(self)
	return tonumber(self.price_total:getText())
end

function InnerItemRow.getAmount(self)
	return tonumber(self.selectable_bar:getText())
end

function InnerItemRow.onPriceChanged(self)
	
end

function InnerItemRow.new(item_name, iterator, verticleCollection)
	local self = {}
	setmetatable(self, {__index = InnerItemRow})
	self.itemNameTextbox = LinearTextbox.new(item_name, self.font)
	local builder = Builder.new(EnterableTextbox, 4, self.font)
	self.selectable_bar = SelectableBar.new(iterator, builder)
	self.price_total = LinearTextbox.new("         0", self.font)
	self.selectable_bar.textChanged = function (selfie)
		local amt = tonumber(selfie:getText())
		local price = ItemProperties.getItemProperties(self:getItemName()).price
		self.price_total:setText(string.format("%10d", amt * price))
		self:onPriceChanged()
	end
	
	self.selectable_bar:setX(verticleCollection:getWidth() / 2 - self.selectable_bar:getWidth() / 2)
	self.price_total:setX(verticleCollection:getWidth() - self.price_total:getWidth())
	
	local hc = ComponentCollection.new(self.itemNameTextbox, self.selectable_bar, self.price_total)
	verticleCollection:add(hc)
	return self
end

function ShopScreen._calculateTotal(self)
	local total = 0
	for _, row in ipairs(self.items)
	do
		total = total + row:getPrice()
	end
	return total
end


function ShopScreen.new()
	local self = Screen.new()
	setmetatable(self, {__index = ShopScreen})
	self.total = 0
	local textFont = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 20)
	self.downShiftTextbox = WordDownshiftTextbox.new("You arrive at the shop. Here you can supply yourself for the voyage. In terms of food, I would recommend that you take approximately 5 pounds of food per person per day, 2 pieces of clothing for each person, and as many spare parts as you need.", textFont, nil, 700)
	self.startingCurrencyTextbox = LinearTextbox.new(string.format("Starting Currency: %d", GameManager.saveData.currency), textFont)
	
	local vc = VerticleCollection.new(self.downShiftTextbox)
	self.startingCurrencyTextbox:setX(vc:getX() + vc:getWidth() - self.startingCurrencyTextbox:getWidth())
	vc:add(self.startingCurrencyTextbox)
	local function createLine()
		local rectComp = RectangularComponent.new()
		rectComp:setX(0) rectComp:setWidth(vc:getWidth()) rectComp:setHeight(3)
		return rectComp
	end
	vc:add(createLine())
	
	self.items = {
    InnerItemRow.new("Food", NextPrevious.getNextPreviousForRange(0, 100, 0, 9999), vc),
	InnerItemRow.new("Clothing", NextPrevious.getNextPreviousForRange(0, 20, 0, 9999), vc),
	InnerItemRow.new("Shot", NextPrevious.getNextPreviousForRange(0, 10, 0, 9999), vc),
	InnerItemRow.new("Rope", NextPrevious.getNextPreviousForRange(0, 1, 0, 9999), vc),
	InnerItemRow.new("Medical Supplies", NextPrevious.getNextPreviousForRange(0, 1, 0, 9999), vc)
	
	
	}
	
	local totalPrice = LinearTextbox.new("Total:         0", InnerItemRow.font)
	totalPrice:setX(vc:getX() + vc:getWidth() - totalPrice:getWidth())
	for _, textbox in pairs(self.items)
	do
		textbox.onPriceChanged = function () 
			local total = self:_calculateTotal() 
			if GameManager.saveData.currency < total
			then
				totalPrice:setColor({1, 0, 0, 1})
			else
				totalPrice:setColor({1,1,1,1})
			end
			totalPrice:setText(string.format("Total: %9d", total))  
		end
	end
	vc:add(createLine())
	vc:add(totalPrice)
	
	Screen.centerComponentOnX(vc)
	Screen.centerComponentOnY(vc)
	self:add(vc)
	
	
	--Submit button 
	local submitButton = DrawableImage.new(love.graphics.newImage("Images/arrow_square_right.png"), 80, 80)
	submitButton:setX(Screen.width - submitButton:getWidth())
	submitButton:setY(Screen.height - submitButton:getHeight())
	submitButton.click = function()
		local boughtTotal = self:_calculateTotal()
		if boughtTotal > 0 and boughtTotal <= GameManager.saveData.currency
		then
			for _, innerRow in ipairs(self.items)
			do
				GameManager.saveData.inventory[innerRow:getItemName()] = innerRow:getAmount()
			end
			GameManager.saveData.currency = GameManager.saveData.currency - boughtTotal
			SaveUtil.saveData(GameManager.saveData, SAVE_PATH)
			GameManager.changeScreen(MainScreen.new())
		end
	end
	self:add(submitButton)
	
	
	return self
end

return ShopScreen