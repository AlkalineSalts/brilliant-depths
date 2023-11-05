require("src.transition.transition")
DownShift = {}
setmetatable(DownShift, {__index = Transition})
function DownShift.updateHook(self, dt)
	self.currentFadeTime = self.currentFadeTime + dt
end

function DownShift.isEnded(self)
	return self.currentFadeTime > self.fadeOutTime
end

function DownShift.draw(self)
self.underScreen:draw()
if self.fadeOutTime
then
	r,g,b,a = love.graphics.getColor()
	love.graphics.setColor(0, 0, 0, 1)
	local _, screen_height = love.graphics.getDimensions()
	love.graphics.rectangle("fill", 0, -screen_height + (screen_height * (self.currentFadeTime /  self.fadeOutTime)), love.graphics.getDimensions())
	love.graphics.setColor(r,g,b,a)
end	
end

function DownShift.new(fadeOutTimeS, underScreen)
	newDownShift = Transition.new()
	setmetatable(newDownShift, {__index = DownShift})
	newDownShift.fadeOutTime = fadeOutTimeS or 1
	newDownShift.currentFadeTime = 0
	newDownShift.underScreen = underScreen
	return newDownShift
end

return DownShift