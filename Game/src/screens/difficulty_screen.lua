require("src.screen")
DifficultyScreen = {}
setmetatable(DifficultyScreen, {__index = Screen})

function DifficultyScreen.new()
	local self = Screen.new()
	return self
end