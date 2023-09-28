--Supertype of Any kind of screen
Screen = {}
function Screen.release(self)
end

function Screen.update(self, dt)
	if not self._is_focused --only updates if in focus
	then
		goto eof
	end
	local mouseX, mouseY = love.mouse.getPosition()
	local foundOverComponent = false --used to make sure only one component can have the mouse over it, the top component
	for i = #self._component_list, 1, -1
	do
		local component = self._component_list[i]
		if not foundOverComponent
		then
			if component:checkMouseOver(mouseX, mouseY) and self._is_m_focused --checks that mouse is over component, requiring the mouse to be both in the screen (mouse focused) and above the component
			then
				foundOverComponent = true
				component:mouseOver(true)
			else
				component:mouseOver(false)
			end
		else
			component:mouseOver(false)
		end
			
	end
	::eof::
end

function Screen.keypressed(self, key, scancode, isrepeat)
	
end
function Screen.mousepressed(self, x, y, number, istouch)
	
end
function Screen.mousereleased(self, x, y, number, istouch)
	if not self._is_focused --only updates if in focus
	then
		return
	end
	
	local mouseX, mouseY = love.mouse.getPosition()
	for i = #self._component_list, 1, -1
	do
		local component = self._component_list[i]
		if not foundOverComponent
		then
			if component:checkMouseOver(mouseX, mouseY) and self._is_m_focused --checks that mouse is over component, requiring the mouse to be both in the screen (mouse focused) and above the component
			then
				component:click()
			end
		end
			
	end
end

function Screen.mousefocus(self, is_m_focused)
	self._is_m_focused = is_m_focused
end

function Screen.focus(self, is_focused) --final, should not be overriden
	self._is_focused = is_focused
	self:focusHook(is_focused)
end
function Screen.is_focused(self)
	return self._is_focused
end
function Screen.focusHook(self, is_focused) --should be implemented by object if necessary
end

function Screen.add(self, component)
	if component
	then 
	self._component_list[#self._component_list + 1] = component
end
end

function Screen.draw(self)
	for _, component in ipairs(self._component_list)
	do
		component:draw()
	end
end

function Screen.new()
local newScreen = {}
setmetatable(newScreen, {__index = Screen})
newScreen._component_list = {}
newScreen._focusHooks = {}
newScreen._is_m_focused = false --holds true value if the screen is mouse focused (has the mouse over it)
newScreen._is_focused = true --holds true value if the screen is focused
return newScreen 	
end



return Screen