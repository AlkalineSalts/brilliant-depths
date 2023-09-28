--This file will deal with the title screen.
require("src.TextGameFramework.event_manager")
require("src.screen")
require("src.textbox")
require("src.TextGameFramework.save_functions")
require("src.logger")
Logger.startLogger("log.txt")
GameManager = {} --global used to determine what happens on screen, changing its metatables changes what the defined love functions will do
--game manager defines a field screen which holds the current screen and delegates all activities to it
local TitleScreen = require("src.screens.titlescreen")
GameManager.eventManager = EventManager.new("GameRoot")

do
	local savePath = love.filesystem.getSaveDirectory()..package.config:sub(1,1).."save_file.lua"
	if love.filesystem.exists(savePath)
	then
		GameManager.saveData = deserialize(savePath)
	else
		GameManager.saveData = {inventory = {}, party = {}}
	end
	--After here, add functions/metatables to the various sub tables
	setmetatable(GameManager.saveData.inventory, {__index = function(table, key) val = rawget(table, key) if val then return val else return 0 end end}) --When inventory doesn't have an item, returns 0
	--GameManager.saveData.party
	
end
function GameManager.changeScreen(newScreen) --static method
	local currentScreen = GameManager.screen
	if currentScreen and currentScreen.release
	then
		currentScreen:release()
	end
	
	--setmetatable(GameManager, {__index = newScreen}) --can change game behavior by changing GameManager metatable
	GameManager.screen = newScreen
	GameManager.inputProcessor = newScreen
	
	--if newScreen.load
	--then
	--	newScreen:load()
	--	GameManager.fadeOutTime = nil
	--	GameManager.currentFadeTime = nil
	--end
	if currentScreen
	then
		GameManager.screen:focus(currentScreen:is_focused())
		GameManager.screen:mousefocus(true)
	end
end

function GameManager.setTransition(transition)
	GameManager.transition = transition
end

function love.load()
	local defaultFont = love.graphics.newFont("Fonts/ibm-plex-mono/IBMPlexMono-Bold.ttf", 20)
	love.graphics.setFont(defaultFont)
	--rect = {x = 0, y = 0, w = 100, h = 100}
	GameManager.changeScreen(TitleScreen.new())
end

function love.quit()
	Logger.endLogger()
end

function love.update(dt)
	if GameManager.transition
	then
		GameManager.transition:update(dt)
	else
		GameManager.screen:update(dt)
	end
end

function love.keypressed(key, scancode, isrepeat)
	GameManager.inputProcessor:keypressed(key, scancode, isrepeat)
end

function love.mousepressed(x,  y, number, istouch)
	GameManager.inputProcessor:mousepressed(x,y,number,istouch)
end

function love.mousereleased(x, y, number, istouch)
	GameManager.inputProcessor:mousereleased(x,y,number,istouch)
end

function love.mousefocus(is_m_focused)
	GameManager.screen:mousefocus(is_m_focused)
end

function love.focus(focus)
	GameManager.screen:focus(focus)
end

-- Draw a coloured rectangle.
function love.draw()
	GameManager.screen:draw()
	if GameManager.transition
	then
		GameManager.transition:draw()
	end
	
end



local function setRectangleSideOffset(xOffset, yOffset)
end
	