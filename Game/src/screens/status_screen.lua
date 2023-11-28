require("src.screen")
require("src.screens.task_screen")
require("src.components")
require("src.party_member")
require("src.progress")
require("src.enum")
require("src.util")
StatusScreen = {}
setmetatable(StatusScreen, {__index = Screen})
StatusScreen.Inventory_List_Size = 10
StatusScreen.KeyItems = {"Food"}



function StatusScreen.new(inventory_screen_page)
	local self = Screen.new()
	setmetatable(self, {__index = StatusScreen})
	
	if inventory_screen_page and inventory_screen_page > 0
	then
		self.inventory_screen_page = inventory_screen_page
	else
		self.inventory_screen_page = 1
	end	
	
	local partyMemberFont = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 16)
	local middleFont = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 18)
	local function createPartySection()
	local member_collection = VerticleCollection.new(LinearTextbox.new("Party Members\n", partyMemberFont))
		for i, member in ipairs(GameManager.saveData.party)
		do
			local name = LinearTextbox.new("Name: "..member:getName(), partyMemberFont)
			local class = LinearTextbox.new("Class: "..Enum.toString(PartyMember.Classes, member:getClass()), partyMemberFont)
			local healthstate = LinearTextbox.new("Health: "..member:getHealthState().."\n", partyMemberFont)
			local vc = VerticleCollection.new(name, class, healthstate)
			member_collection:add(vc)
		end
		return member_collection
	end
	local function sortInventoryKeys(inventory) 
		local toSort = {}
		local i = 1
		for item_name, value in pairs(inventory)
		do
			if type(value) == "number"
			then
				toSort[i] = item_name
				i = i + 1
			end
		end
		table.sort(toSort)
		return toSort
	end
	local function createInventorySection(inventory)
		local inventory_collection = VerticleCollection.new(LinearTextbox.new("Inventory\n", partyMemberFont))
		
		--Inventory number to item name
		toSort = sortInventoryKeys(inventory)
		local startsAt = 1 + ((self.inventory_screen_page - 1) * StatusScreen.Inventory_List_Size)
		for index = startsAt, (startsAt + StatusScreen.Inventory_List_Size - 1)
		do
			if toSort[index]
			then
				inventory_collection:add(LinearTextbox.new(string.format("%.20s: %d ", toSort[index], inventory[toSort[index]]), partyMemberFont))
			end
		end
		
		local COUNT_NUM_COLUMNS = math.floor(#toSort / StatusScreen.Inventory_List_Size) + 1
		
		
		local placeInList = LinearTextbox.new(string.format("%d / %d", self.inventory_screen_page, COUNT_NUM_COLUMNS), partyMemberFont)
		local left_button = DrawableImage.new("Images/arrow_square_left.png", placeInList:getHeight(), placeInList:getHeight())
		left_button.click = function() GameManager.changeScreen(StatusScreen.new(self.inventory_screen_page - 1)) end
		local right_button = DrawableImage.new("Images/arrow_square_right.png", placeInList:getHeight(), placeInList:getHeight())
		right_button.click = 
		function() 
			if COUNT_NUM_COLUMNS < self.inventory_screen_page
			then
				GameManager.changeScreen(StatusScreen.new(self.inventory_screen_page + 1)) 
			end
		end
		inventory_collection:add(HorizontalCollection.new(left_button, placeInList, right_button))
		inventory_collection:setX(Screen.width - inventory_collection:getWidth())
		return inventory_collection
	end
	
	local function createKeyItemsSection(inventory)
		--Removes the key items from the given table and displays
		local layer = LinearTextbox.new(string.format("Layer %d", GameManager.saveData.layer), middleFont)
		local days = LinearTextbox.new(string.format("Day: %d", GameManager.saveData.day), middleFont)
		local currency = LinearTextbox.new(string.format("Currency: %d", GameManager.saveData.currency), middleFont)
		
		local vc = VerticleCollection.new(layer, days, currency)
		for _, item_name in ipairs(StatusScreen.KeyItems)
		do
			vc:add(LinearTextbox.new(string.format("%s: %d", item_name, inventory[item_name]), middleFont))
			inventory[item_name] = nil
		end
		
		local avg_health = LinearTextbox.new(string.format("Average Health: %s", GameManager.saveData.party:getAverageHealth()), middleFont)
		local traveling_speed = LinearTextbox.new("Traveling Speed: "..Enum.toString(PartyMember.TravelingSpeed, GameManager.saveData.traveling_speed), middleFont)
		local rations = LinearTextbox.new("Rations: "..Enum.toString(PartyMember.FoodAmount, GameManager.saveData.food_consumption_amount), middleFont)
		vc:add(avg_health)
		vc:add(traveling_speed)
		vc:add(rations)
		
		return vc
	end
	
	local function createColumn(sizeLimit) --Options and potentially key stats and items listed
		--We want to pull options from config file
		
		local options, e = require("GameRoot.status_screen_options")
		local vc = VerticleCollection.new()
		for _, option in ipairs(options)
		do
			local HBox = HighlightTextbox.new(WordDownshiftTextbox.new(option:get_text(), middleFont, nil, sizeLimit))
			if (option:is_selectable(GameManager.saveData))
			then
				HBox.click = function () 
					option:selected_action(GameManager.saveData)
					local gotoNext = option:get_next_event_name()
					if gotoNext == nil then gotoNext = MainScreen.new() end
					if isInstanceOf(gotoNext, Screen)
					then
						GameManager.changeScreen(gotoNext)
					else
						GameManager.changeScreen(EventScreen.new(GameManager.eventManager:get_event(gotoNext, GameManager.saveData)))
					end
					
				end
			end
			if not option:should_be_seen()
			then
				HBox:setColor(Color.GREY)
			end
			vc:add(HBox)
		end
		
		
		return vc
	end
	
	
	local member_collection = createPartySection()
	local memberCollectionBorder = RectangularComponent.new(member_collection:getWidth(), 0, 3, Screen.height, {1, 1, 1, 1})
	local inventory_copy = GameManager.saveData.inventory 
	local key_items = createKeyItemsSection(inventory_copy)
	local inventory_collection = createInventorySection(inventory_copy)
	local inventoryCollectionBorder = RectangularComponent.new(Screen.width - inventory_collection:getWidth() - 3, 0, 3, Screen.height, {1, 1, 1, 1})
	local optionsCollection = createColumn(inventoryCollectionBorder:getX() - memberCollectionBorder:getX() + memberCollectionBorder:getWidth())
	key_items:add(RectangularComponent.new(0, 0, inventoryCollectionBorder:getX() - memberCollectionBorder:getX(), 3, {1,1,1,1}))
	key_items:add(optionsCollection)
	key_items:setX(memberCollectionBorder:getX() + memberCollectionBorder:getWidth())
	local component_collection = ComponentCollection.new(member_collection, memberCollectionBorder, inventoryCollectionBorder, key_items, inventory_collection)
	self:add(component_collection)
	
	
	return self
end


return StatusScreen