require("src.screen")
require("src.components")
require("src.party_member")

TaskScreen = {}
setmetatable(TaskScreen, {__index = Screen})
local taskFont = love.graphics.newFont("Fonts/VCR_OSD_MONO.ttf", 25)

function TaskScreen.createTask(self, taskStruct)
	local checkbox
	local task_text = WordDownshiftTextbox.new(" "..taskStruct.text, taskFont, nil, Screen.width * 0.75)
	if taskStruct.is_completed(GameManager.saveData)
	then
		checkbox = DrawableImage.new("Images/checked_checkbox.png", taskFont:getHeight(), taskFont:getHeight())
	else
		checkbox = DrawableImage.new("Images/unchecked_checkbox.png", taskFont:getHeight(), taskFont:getHeight())
	end
	local space = RectangularComponent.new(0,0,5,0)
	local hc = HorizontalCollection.new(checkbox, space, task_text)
	hc:setX(Screen.width / 2 - hc:getWidth() / 2)
	self._verticle_components:add(hc)
end

function TaskScreen.new(prevScreen)
	local self = Screen.new()
	setmetatable(self, {__index = TaskScreen})
	local tasks = require("src.tasks")
	local main_task_title = LinearTextbox.new("Main Task", taskFont)
	Screen.centerComponentOnX(main_task_title)
	self._verticle_components = VerticleCollection.new(main_task_title)
	self:createTask(tasks.MainTasks[GameManager.saveData.main_task])
	self:add(self._verticle_components)
	
	local back = HighlightTextbox.new(LinearTextbox.new("Back", taskFont))
	back.click = function () GameManager.changeScreen(StatusScreen.new()) end
	Screen.centerComponentOnX(back)
	self._verticle_components:add(back)
	
	
	return self
end
