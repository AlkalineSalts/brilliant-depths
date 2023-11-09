require("src.components.component_collection")
--Supertype of Any kind of screen
Screen = {}

Screen.width = 800
Screen.height = 600

function Screen.centerComponentOnX(component)
	component:setX((Screen.width/2) - component:getWidth() / 2)
end
function Screen.centerComponentOnY(component)
	component:setY((Screen.height/2) - component:getHeight() / 2)
end
function Screen.centerComponentUnderComponent(component, centerUnderThis)
	component:setX(centerUnderThis:getX() + centerUnderThis:getWidth() / 2)
	component:setY(centerUnderThis:getY() + centerUnderThis:getHeight())
end
function Screen.release(self) --Called when screen is moved away from
end
function Screen.load(self) --Called when Screen is switched to
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

function Screen.getComponentAt(self, x, y) --returns the topmost component at x, y
	for i = #self._component_list, 1, -1
	do
		local component = self._component_list[i]
		if component:checkMouseOver(x, y) and self._is_m_focused --checks that mouse is over component, requiring the mouse to be both in the screen (mouse focused) and above the component
		then
			return component
		end	
	end
end

function Screen.mousepressed(self, x, y, number, istouch)
	if not self._is_focused --only updates if in focus
	then
		return
	end
end
function Screen.mousereleased(self, x, y, number, istouch)
	if not self._is_focused --only updates if in focus
	then
		return
	end
	local releasedComponent = self:getComponentAt(x, y)
	releasedComponent:click()
	
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
	self._component_list[#self._component_list + 1] = component
end

function Screen.remove(self, component)
	local index = nil
	for i, c in ipairs(self._component_list)
	do
		if c == component
		then
			index = i
		end
	end
	if index then 
		table.remove(self._component_list, index)
	end
	
end


function Screen.draw(self)
	for _, component in ipairs(self._component_list)
	do
		component:draw()
	end
end

function Screen.getWidth(self)
	return Screen.width
end

function Screen.getHeight(self)
	return Screen.height
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