require("src.transition.transition")
FadeIn = {}
setmetatable(FadeIn, {__index = Transition})
function FadeIn.updateHook(self, dt)
	self.currentFadeTime = self.currentFadeTime + dt
end

function FadeIn.isEnded(self)
	return self.currentFadeTime > self.fadeInTime
end

function FadeIn.draw(self)
if self.fadeInTime
then
	r,g,b,a = love.graphics.getColor()
	local percent = (self.currentFadeTime / self.fadeInTime)
	love.graphics.setColor(0, 0, 0, math.max(1-percent, 0))
	love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
	love.audio.setVolume(math.min(percent, 1))
	love.graphics.setColor(r,g,b,a)
end	
end

function FadeIn.new(fadeInTimeS)
	newFadeIn = Transition.new()
	setmetatable(newFadeIn, {__index = FadeIn})
	newFadeIn.fadeInTime = fadeInTimeS or 1
	newFadeIn.currentFadeTime = 0
	return newFadeIn
end

return FadeIn