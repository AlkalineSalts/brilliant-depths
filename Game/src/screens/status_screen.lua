require("src.screen")
require("src.component_collection")
require("src.drawable_image")
require("src.horizontal_collection")
require("src.verticle_collection")
require("src.fixed_size_collection")
require("src.linear_textbox")
require("src.rectangular_component")
require("src.party_member")
require("src.enum")
require("src.util")
require("src.progress")
StatusScreen = {}
setmetatable(StatusScreen, {__index = Screen})
StatusScreen.Inventory_List_Size = 10




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
	local function createPartySection()
	local member_collection = VerticleCollection.new(LinearTextbox.new("Party Members", partyMemberFont), RectangularComponent.new(0,0,0,20))
		for i, member in ipairs(GameManager.saveData.party)
		do
			local name = LinearTextbox.new("Name: "..member:getName(), partyMemberFont)
			local class = LinearTextbox.new("Class: "..Enum.toString(PartyMember.Classes, member:getClass()), partyMemberFont)
			local healthstate = LinearTextbox.new("Health: "..Enum.toString(PartyMember.HealthState, member:getHealthState()), partyMemberFont)
			local vc = VerticleCollection.new(name, class, healthstate, RectangularComponent.new(0,0,0,20))
			member_collection:add(vc)
		end
		return member_collection
	end
	
	local function createInventorySection(inventory)
		local inventory_collection = VerticleCollection.new(LinearTextbox.new("Inventory", partyMemberFont))
		
		--Inventory number to item name
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
		local startsAt = 1 + ((self.inventory_screen_page - 1) * StatusScreen.Inventory_List_Size)
		for index = startsAt, (startsAt + StatusScreen.Inventory_List_Size - 1)
		do
			if toSort[index]
			then
				inventory_collection:add(LinearTextbox.new(string.format("%s: %d", toSort[index], inventory[toSort[index]]), partyMemberFont))
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
	
	
	local member_collection = createPartySection()
	local memberCollectionBorder = RectangularComponent.new(member_collection:getWidth(), 0, 3, Screen.height, {1, 1, 1, 1})
	local inventory_collection = createInventorySection(GameManager.saveData.inventory)
	local inventoryCollectionBorder = RectangularComponent.new(Screen.width - inventory_collection:getWidth() - 3, 0, 3, Screen.height, {1, 1, 1, 1})
	local component_collection = ComponentCollection.new(member_collection, memberCollectionBorder, inventoryCollectionBorder, inventory_collection)
	self:add(component_collection)
	
	
	return self
end


return StatusScreen