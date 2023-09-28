--Is intended to be used as an interface
Transition = {}
function Transition.updateHook(self, dt) --Abstract method, must be implemented by 
end

function Transition.isEnded(self) --returns if the transition is ended
	--return boolean
end

function Transition.update(self, dt) --should not be modified by sublcasses
	if (self:isEnded())
	then
		self:_endHook()
	else
		self:updateHook(dt)
	end
end

function Transition.draw(self) --abstract method
end

function Transition._endHook(self) --is set by setEndhook, this is the default
	GameManager.setTransition(nil) 
end

function Transition.setEndhook(self, hook) --func is whatever needed, default is the transition is removed from the game manager, method should return self for nice building
	if hook
	then
		self._endHook = hook
	else
		self._endHook = Transition._endHook
	end
	return self
end	


function Transition.new()
local newTransition = {}
setmetatable(newTransition, {__index = Transition})
return newTransition
end

return Transition