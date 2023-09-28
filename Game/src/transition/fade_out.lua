require("src.transition.transition")
FadeOut = {}
setmetatable(FadeOut, {__index = Transition})
function FadeOut.updateHook(self, dt)
	self.currentFadeTime = self.currentFadeTime + dt
end

function FadeOut.isEnded(self)
	return self.currentFadeTime > self.fadeOutTime
end

function FadeOut.draw(self)
if self.fadeOutTime
then
	r,g,b,a = love.graphics.getColor()
	local percent = (self.currentFadeTime / self.fadeOutTime)
	love.graphics.setColor(0, 0, 0, percent)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
	love.audio.setVolume(math.max(1-percent, 0))
	love.graphics.setColor(r,g,b,a)
end	
end

function FadeOut.new(fadeOutTimeMs)
	newFadeOut = Transition.new()
	setmetatable(newFadeOut, {__index = FadeOut})
	newFadeOut.fadeOutTime = fadeOutTimeMs or 1
	newFadeOut.currentFadeTime = 0
	return newFadeOut
end

return FadeOut