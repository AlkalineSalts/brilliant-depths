local main_ending_bad = {}
setmetatable(main_ending_bad, {__index = Event})
function main_ending_bad.get_text(self, game_data)
	return "You did not collect enough money in time to save your company. You failed!"
end

function main_ending_bad.init(self, game_data)	
end
function main_ending_bad.new()
	local self = Event.new("main_ending_bad")
	setmetatable(self, {__index = main_ending_bad})

	return self
end
return main_ending_bad.new()