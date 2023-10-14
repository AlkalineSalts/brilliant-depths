require("src.screen")
require("src.builder")
require("src.screens.notify_screen")
require("src.screens.shop_screen")
require("src.verticle_collection")
require("src.selectable_bar")
require("src.enterable_textbox")
require("src.drawable_image")
require("src.linear_textbox")
require("src.enum")
require("src.party_member")
require("src.next_previous")
DifficultyScreen = {}
setmetatable(DifficultyScreen, {__index = Screen})

function DifficultyScreen.draw(self)
	Screen.draw(self)
end

function DifficultyScreen.new()
	local self = Screen.new()
	self.initial_money_amount = {500, 750, 1000, 1250, 1500}
	self.initial_money_amount[0] = 500
	local c_classes = Enum.values(PartyMember.Classes)
	local enterfont = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 30)
	local playerSetupList = {textbox = EnterableTextbox.new(20, enterfont, nil), bar = SelectableBar.new(NextPrevious.getNextPreviousForArray(c_classes), Builder.new(EnterableTextbox, 20, enterfont, nil), love.graphics.newImage("Images/arrow_square_right.png"))}
	self.num_players = LinearTextbox.new("Current Players: 0", enterfont)
	self.initial_money_text = LinearTextbox.new(string.format("Starting Currency: %d", self.initial_money_amount[0]), enterfont)
	local function getPlayerAmt()
		local playerAmt = 0
		for _, struct in ipairs(self.struct_list)
		do
			if struct.textbox:getText() ~= ""
			then
				playerAmt = playerAmt + 1
			end
		end
		self.num_players:setText(string.format("Current Players: %d", playerAmt))
		self.initial_money_text:setText(string.format("Starting Currency: %d", self.initial_money_amount[playerAmt]))
		return playerAmt
	end
	self.player_setup = VerticleCollection.new(playerSetupList.textbox, playerSetupList.bar)
	self.struct_list = {playerSetupList}
	playerSetupList.bar.textChanged = getPlayerAmt
	for i = 2, 5
	do
		local playerSetupList = {textbox = EnterableTextbox.new(20, enterfont, nil), bar = SelectableBar.new(NextPrevious.getNextPreviousForArray(c_classes), Builder.new(EnterableTextbox, 20, enterfont, nil), love.graphics.newImage("Images/arrow_square_right.png"))}
		self.struct_list[i] = playerSetupList
		playerSetupList.textbox.textChanged = getPlayerAmt
		self.player_setup:add(playerSetupList.textbox)
		self.player_setup:add(playerSetupList.bar)
	end
	
	self.player_setup:add(self.num_players)
	self.player_setup:add(self.initial_money_text)
	self.player_setup:setY((Screen.height / 2) - (self.player_setup:getHeight() / 2))
	self.player_setup:setX((Screen.width / 2) - (self.player_setup:getWidth()/2))
	self:add(self.player_setup)
	self.continue_arrow = DrawableImage.new(love.graphics.newImage("Images/arrow_square_right.png"), 80, 80)
	Screen.centerComponentOnX(self.continue_arrow)
	self.player_setup:add(self.continue_arrow)
	
	self.continue_arrow.click = function() 
		local playerAmt = getPlayerAmt()
		if playerAmt > 0
		then
			GameManager.saveData.currency = self.initial_money_amount[playerAmt]
			for _, struct in ipairs(self.struct_list)
			do
				if (struct.textbox:getText() ~= "")
				then
					local name = struct.textbox:getText()
					local class = struct.bar:getText()
					GameManager.saveData.party[#GameManager.saveData.party + 1] = PartyMember.new(name, PartyMember.Classes[class])
				end
			end
			GameManager.changeScreen(ShopScreen.new())
		end
	end
	return self
end