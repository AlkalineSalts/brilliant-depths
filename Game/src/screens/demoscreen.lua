local DemoScreen = Screen.new()
function DemoScreen.update(self, dt)
	Screen.update(self)
	DemoScreen.fpsTextBox:setText(string.format("DT: %f", dt))
end

function DemoScreen.focusHook(self, is_focused)
	if is_focused
	then
		self.titleLoop:play()
	else
		self.titleLoop:pause()
	end
end
	

function DemoScreen.draw(self) 
	
    love.graphics.setColor(255, 255, 255)
	love.graphics.draw(DemoScreen.titleImage, 0, 0)
	Screen.draw(self)
    --love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h)
end

function DemoScreen.load()
	DemoScreen.titleImage = love.graphics.newImage("Images/demo.png")
	DemoScreen.titleLoop = love.audio.newSource("Music/03 File Select.mp3", "stream") --Source object
	DemoScreen.titleLoop:setLooping(true)
	DemoScreen.titleLoop:play()
	DemoScreen.fpsTextBox = TextBox.new("DT: 0", 0, 0)
	DemoScreen:add(DemoScreen.fpsTextBox)
	
end

function DemoScreen.release(self)
	self.titleLoop:stop()
end

return DemoScreen