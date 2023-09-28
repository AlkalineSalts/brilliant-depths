require("src.screen")
require("src.component")
require("src.clickable_textbox")
require("src.component_collection")
require("src.enterable_textbox")
require("src.word_downshift_textbox")
require("src.linear_textbox")
require("src.transition.simple_transition")
require("src.selectable_bar")
require("src.background_drawable")
require("src.screens.difficulty_screen")
TitleScreen = {}
setmetatable(TitleScreen, {__index = Screen})

function TitleScreen.release(self)
	self.titleLoop:stop()
end

function TitleScreen.focusHook(self, is_focused) --private, externals should call 
	if is_focused
	then
		self.titleLoop:play()
	else
		self.titleLoop:pause()
	end
end

function TitleScreen.draw(self)
	love.graphics.clear(0,0,0,1)
	Screen.draw(self)
end

function TitleScreen.new()
	local self = Screen.new()
	setmetatable(self, {__index = TitleScreen})
	local width, height = love.graphics.getDimensions()
	self.titleText = LinearTextbox.new("Made In New Abyss", love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 60), nil)
	self.titleText:setX(width/2 - self.titleText:getWidth()/2)
	self:add(self.titleText)
	local nonTitleFont = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 30)
	self.newGame = HighlightTextbox.new(LinearTextbox.new("New Game", nonTitleFont))
	if GameManager.saveData
	then
		self.continue = HighlightTextbox.new(LinearTextbox.new("Continue", nonTitleFont))
	else
		self.continue = LinearTextbox.new("Continue", nonTitleFont, {0.5, 0.5, 0.5})
	end
	local combined_height = self.newGame:getHeight() + self.continue:getHeight()
	self.newGame:setX(width/2 - self.newGame:getWidth()/2)
	self.newGame:setY(height/2 - combined_height/2)
	self.continue:setX(width/2 - self.continue:getWidth()/2)
	self.continue:setY(self.newGame:getY() + self.newGame:getHeight())
	self:add(self.newGame)
	self:add(self.continue)
	self.newGame.click = function(self) SimpleTransition.fadeTransition(DifficultyScreen.new()) end
	self.titleLoop = love.audio.newSource("Music/03 File Select.mp3", "stream") --Source object
	
	--self.enterable_textbox = EnterableTextbox.new(nonTitleFont, nil, 30)
	--self.enterable_textbox:setY(self.continue:getY() + self.continue:getHeight())
	--self.enterable_textbox:setX(100)
	--self:add(self.enterable_textbox)
	
	--self.gg = SelectableBar.new({"Hi", "Bye"},EnterableTextbox.new(nonTitleFont, nil, 30), love.graphics.newImage("Images/arrow_square_right.png"))
	--self.gg:setY(500)
	--self:add(self.gg)
	return self
end

return TitleScreen