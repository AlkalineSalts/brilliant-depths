--Note: Do not return event group names from here, only use event names
local option_change_speed = Option.new("Change Traveling Speed")
option_change_speed.get_next_event_name = function () return "status_screen_change_speed" end

local option_change_rations = Option.new("Change Ration Amount")
option_change_rations.get_next_event_name = function () return "status_screen_change_rations"  end

local option_view_tasks = Option.new("View tasks")
option_view_tasks.get_next_event_name = function() return TaskScreen.new() end

local option_wait = Option.new("Rest for the day.")
option_wait.selected_action = function (self, game_data)
	increaseDay(game_data)
end
option_wait.get_next_event_name = function () return StatusScreen.new() end

local return_to_main = Option.new("Return to main screen")
return_to_main.get_next_event_name = function () return MainScreen.new() end


return {option_change_speed, option_change_rations, option_view_tasks, option_wait, return_to_main}