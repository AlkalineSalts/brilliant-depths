require("src.screen")
require("src.horizontal_collection")
require("src.verticle_collection")
require("src.fixed_size_collection")
require("src.linear_textbox")
require("src.rectangular_component")
require("src.party_member")
require("src.enum")
require("src.progress")
require("src.screens.event_screen")
local DepthInfo = require("src.depth_info")

MainScreen = {}

setmetatable(MainScreen, {__index = Screen})

function MainScreen._checkEvents(self)
	local status, event = pcall(GameManager.eventManager.get_event, GameManager.eventManager, "priority_events", GameManager.saveData)
	--If expected error ignore, repeat error if not expected error {done a bit dirty}
	if not status 
	then
		
		if not string.find(event or "", "No valid next event in event group")
		then
			error(event)
		else
			event = nil
		end
	end
	
	if event
	then
		GameManager.changeScreen(EventScreen.new(event))
	end
end

function MainScreen._stopTransition(self)
	self._is_in_transition = false
	self:_saveGame()
	self:_checkEvents()
	--get any valid priority events
	
end

function MainScreen.update(self, dt)
	Screen.update(self, dt)
	if self._is_in_transition
	then
		local direction = GameManager.saveData.depth - self._depth 
		if direction ~= 0
		then
			direction = direction / math.abs(direction)
			self._depth = self._depth + direction
		else
			self:_stopTransition()
		end
		self:updateText()
	end
	
	
	
	
end

function MainScreen.updateText(self)
	self._depth_gauge:setText(string.format("Depth: %d", self._depth))
	self._to_next_layer:setText(string.format("Next layer: %d", self._layer_info.depthMaximum - self._depth))
	--Used to only update these fields when necessary
	if not self._is_in_transition
	then 
		self._day_meter:setText(string.format("Day: %d", GameManager.saveData.day))
		self._food_meter:setText(string.format("Food: %d", GameManager.saveData.inventory.Food))
		self._health_meter:setText(string.format("Health: %s", GameManager.saveData.party:getAverageHealth()))
	end
end

function MainScreen._saveGame(self)
	SaveUtil.saveData(GameManager.saveData, SAVE_PATH)
end

function MainScreen.load(self)
	self._layer_info = DepthInfo.getLayerFromNumber(GameManager.saveData.layer)
	self._background = self._layer_info.layer_image
	self:_saveGame()
	self:_checkEvents()
	self:updateText()
end

function MainScreen.keypressed(self, key, scancode, isrepeat)
	if key == "down" and not self._is_in_transition
	then
		progress(GameManager.saveData)
		self._is_in_transition = true
	end
end

function MainScreen.draw(self)
	love.graphics.draw(self._background, 0,  -self._depth + self._layer_info.depthMinimum)
	Screen.draw(self)
end

function MainScreen.new()
	local self = Screen.new()
	setmetatable(self, {__index = MainScreen})
	self._depth = GameManager.saveData.depth --Self._depth is displayed depth, not always actual
	self._is_in_transition = false
	
	
	--Set up graphics elements
	self._font = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 20)
	
	self._depth_gauge = LinearTextbox.new("", self._font)
	self._to_next_layer = LinearTextbox.new("", self._font)
	self._day_meter = LinearTextbox.new("", self._font)
	self._game_stats = FixedSizeCollection.makeFixedSize(VerticleCollection.new(self._depth_gauge, self._to_next_layer ,self._day_meter), 400)
	self._food_meter = LinearTextbox.new("", self._font)
	self._health_meter = LinearTextbox.new("", self._font)
	self._party_stats = VerticleCollection.new(self._food_meter, self._health_meter)
	self._stats_collection = HorizontalCollection.new(self._game_stats, self._party_stats)
	
	self._controls_tb = LinearTextbox.new("Controls: ", self._font)
	self._controls_collection = HorizontalCollection.new(self._controls_tb)
	
	self._ui_collection = VerticleCollection.new(self._stats_collection, RectangularComponent.new(0, 0, Screen.width, 3), self._controls_collection)
	self._ui_collection:setY(Screen.height - self._ui_collection:getHeight())
	
	local blackBackground = RectangularComponent.new(self._ui_collection:getX(), self._ui_collection:getY(), Screen.width, self._ui_collection:getHeight(), {0,0,0,1})
	self:add(blackBackground)
	
	self:add(self._ui_collection)
	
	
	return self
end

return MainScreen