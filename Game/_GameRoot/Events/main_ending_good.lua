local main_ending_good = {}
setmetatable(main_ending_good, {__index = Event})
function main_ending_good.get_text(self, game_data)
	return string.format("You managed to  get together enough money to save your adventuring crew. Congratulations! Score: %d", getMainTask(game_data.main_task).score)
end

function main_ending_good.init(self, game_data)	
end
function main_ending_good.new()
	local self = Event.new("main_ending_good")
	setmetatable(self, {__index = main_ending_good})

	return self
end
return main_ending_good.new()