return {
	MainTasks = {
		{
			score = 1000,
			text = "Get 10000 in currency and return before 365 days pass.",
			is_completed = function(game_data) return game_data.day < 365 and game_data.currency >= 10000 end
		}
	
	}

}