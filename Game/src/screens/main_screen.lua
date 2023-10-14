require("src.screen")
require("src.horizontal_collection")
require("src.verticle_collection")
require("src.linear_textbox")
require("src.rectangular_component")
require("src.party_member")
require("src.enum")
require("src.progress")
require("src.screens.event_screen")
local DepthInfo = require("src.depth_info")

MainScreen = {}

setmetatable(MainScreen, {__index = Screen})

local function padString(val)
	--pads the given string to given amount
	local str = tostring(val)
	return string.format("%-40s", str)
end

function MainScreen._checkEvents(self)
	local status, event = pcall(GameManager.eventManager.get_event, GameManager.eventManager, "priority_events", GameManager.saveData)
	--If expected error ignore, repeat error if not expected error {done a bit dirty}
	if not status 
	then
		if string.find("No valid next event in event group", event)
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
	end
	self:updateText()
	
end

function MainScreen.updateText(self)
	self._depth_gauge:setText(padString(string.format("Depth: %d", self._depth)))
	self._day_meter:setText(padString(string.format("Day: %d", GameManager.saveData.day)))
end

function MainScreen._saveGame(self)
	SaveUtil.saveData(GameManager.saveData, SAVE_PATH)
end

function MainScreen.load(self)
	self:_saveGame()
	self:_checkEvents()
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
	self._layer_info = DepthInfo.getLayerFromDepth(self._depth)
	self._background = self._layer_info.layer_image
	
	
	--Set up graphics elements
	self._font = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 20)
	self._depth_gauge = LinearTextbox.new(padString(""), self._font)
	self._day_meter = LinearTextbox.new(padString(""), self._font)
	self._stats_collection = VerticleCollection.new(self._depth_gauge, self._day_meter)
	self._controls_tb = LinearTextbox.new("Controls: ", self._font)
	self._controls_collection = HorizontalCollection.new(self._controls_tb)
	
	self._ui_collection = VerticleCollection.new(self._stats_collection, RectangularComponent.new(nil, 0, 0, Screen.width, 3), self._controls_collection)
	self._ui_collection:setY(Screen.height - self._ui_collection:getHeight())
	
	local blackBackground = RectangularComponent.new({0,0,0,1}, self._ui_collection:getX(), self._ui_collection:getY(), Screen.width, self._ui_collection:getHeight())
	self:add(blackBackground)
	
	self:add(self._ui_collection)
	
	return self
end

return MainScreen