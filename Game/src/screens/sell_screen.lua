require("src.screen")
require("src.components")
require("src.util")
require("src.next_previous")
require("src.builder")
SellScreen = {}
setmetatable(SellScreen, {__index = Screen})
local font = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 20)
local NUM_IN_ROW = 15
local InventoryRow = {}
local less_then_function = function (s1, s2) return s1._inventory_item < s2._inventory_item end
setmetatable(InventoryRow, {__index = HorizontalCollection})

function InventoryRow.getName(self)
	return self._inventory_item
end

function InventoryRow._onChanged(self)
	--sets current to previous, then gets new current
	self._previous_value = self._current_value
	self._current_value = self._next_previous:current()
	self:onChanged()
end

function InventoryRow.onChanged(self)
	
end

function InventoryRow.getNumber(self)
	return self._current_value
end

function InventoryRow.getPreviousNumber(self)
	return self._previous_value
end

function InventoryRow.new(inventory_item, font)
	local self = HorizontalCollection.new()
	setmetatable(self, {__index = InventoryRow, __lt = less_then_function})
	self._inventory_item = inventory_item
	item_name_tb = EnterableTextbox.new(25, font)
	item_name_tb:setText(inventory_item)
	item_name_tb:setEnterable(false)
	self:add(item_name_tb)
	local next_previous = NextPrevious.getNextPreviousForRange(GameManager.saveData.inventory[inventory_item], math.min(10 * #tostring(GameManager.saveData.inventory[inventory_item]) - 1, 1), 0, GameManager.saveData.inventory[inventory_item])
	self._next_previous = next_previous
	self._previous_value = next_previous:current()
	self._current_value = next_previous:current()
	local amt_builder = Builder.new(EnterableTextbox, 16, font)
	amt_builder:callMethod("setEnterable", false)
	amt_builder:callMethod("setText", next_previous:current())
	self._selectable_bar = SelectableBar.new(next_previous, amt_builder)
	self._selectable_bar.textChanged = function() self:_onChanged() end
	self:add(self._selectable_bar)
	return self
end

function SellScreen.rebuild(self)
	--This section fills out the inventory selection area
	self._inventory_selection:clear()
	local search_string = self._enterable_textbox:getText()
	local num_rows_shown = 0
	for _, inventory_row in ipairs(self._inventory_rows)
	do
		if string.find(inventory_row:getName(), search_string) and num_rows_shown < NUM_IN_ROW
		then
			self._inventory_selection:add(inventory_row)
			num_rows_shown = num_rows_shown + 1
		end
	end
end

function SellScreen.getSellValue(self)
	return self._sell_value
end

function SellScreen.setSellValue(self, amt)
	self._sell_value = amt
	self._sell_value_textbox:setText(string.format("Sell value: %d", self._sell_value))	
	Screen.centerComponentOnX(self._sell_value_textbox)
end

function SellScreen.sellItems(self)
	GameManager.saveData.currency = GameManager.saveData.currency + self._sell_value
	for _, inventory_row in ipairs(self._inventory_rows)
	do
		GameManager.saveData.inventory[inventory_row:getName()] = inventory_row:getNumber()
	end
end

function SellScreen.new()
	local self = Screen.new()
	setmetatable(self, {__index = SellScreen})
	self._sell_value = 0
	self._current_currency_textbox = LinearTextbox.new("", font)
	--Sets the current currency textbox
	self._current_currency_textbox:setText(string.format("Current Currency: %d", GameManager.saveData.currency))
	--Setis up the enterable textbox
	self._enterable_textbox = EnterableTextbox.new(25, font)
	self._enterable_textbox.textChanged = function() self:rebuild() end
	
	self._verticle_collection = VerticleCollection.new(self._current_currency_textbox, self._enterable_textbox)
	Screen.centerComponentOnX(self._verticle_collection)
	self:add(self._verticle_collection)
	self._inventory_selection = VerticleCollection.new()
	self._inventory_rows = {}
	for item, _ in pairs(GameManager.saveData.inventory)
	do
		local inventory_row = InventoryRow.new(item, font)
		--This updates the sell value
		inventory_row.onChanged = function (inventory_self) 
			local item_name = inventory_self:getName()
			local item_properties = ItemProperties.getItemProperties(item_name)
			local curr_sell_value = self:getSellValue() + (inventory_self:getPreviousNumber() - inventory_self:getNumber()) * item_properties.price
			self:setSellValue(curr_sell_value)
		end
		table.insert(self._inventory_rows, inventory_row)
	end
	table.sort(self._inventory_rows)
	self:add(self._inventory_selection)
	self:rebuild()
	Screen.centerComponentOnX(self._inventory_selection)
	--self._inventory_selection:setY(self._verticle_collection:getY() + self._verticle_collection:getHeight())
	self._verticle_collection:add(self._inventory_selection)
	self._sell_value_textbox = LinearTextbox.new("Sell value: 0", font)
	Screen.centerComponentOnX(self._sell_value_textbox)
	self._verticle_collection:add(self._sell_value_textbox)
	local sell_option = HighlightTextbox.new(LinearTextbox.new("Sell items", font))
	sell_option.click = function () 
		self:sellItems()
		GameManager.goBackScreen(MainScreen.new())
	end
	Screen.centerComponentOnX(sell_option)
	self._verticle_collection:add(sell_option)
	
	local cancel_button = HighlightTextbox.new(LinearTextbox.new("Cancel", font))
	cancel_button.click = function () GameManager.goBackScreen(MainScreen.new()) end
	Screen.centerComponentOnX(cancel_button)
	self._verticle_collection:add(cancel_button)
	
	
	return self
end

return SellScreen