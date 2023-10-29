local changeSpeed = Event.new("status_screen_change_speed")
local function returnToStatusScreen() return StatusScreen.new() end


changeSpeed.get_text = function() return "At what pace do you want the group to move?" end


local option = Option.new("Move at a balanced pace.", true)
option.get_next_event_name = returnToStatusScreen
option.selected_action = function(self, game_data)
	game_data.traveling_speed = PartyMember.TravelingSpeed.Balanced
end
changeSpeed:add_option(option)

local option2 = Option.new("Move at a strenuous pace.", true)
option2.get_next_event_name = returnToStatusScreen
option2.selected_action = function(self, game_data)
	game_data.traveling_speed = PartyMember.TravelingSpeed.Strenuous
end
changeSpeed:add_option(option2)

local option3 = Option.new("Move at a grueling pace.", true)
option3.get_next_event_name = returnToStatusScreen
option3.selected_action = function(self, game_data)
	game_data.traveling_speed = PartyMember.TravelingSpeed.Grueling
end
changeSpeed:add_option(option3)



--change rations
local  changeRations =  Event.new("status_screen_change_rations")
changeRations.get_text = function() return "What portion sizes do you want to assign to the group?" end

local r1 = Option.new("Assign hearty portions. No one will go away hungry.")
r1.get_next_event_name = returnToStatusScreen
r1.selected_action = function(self, game_data)
	game_data.food_consumption_amount = PartyMember.FoodAmount.Hearty
end
changeRations:add_option(r1)

local r2 = Option.new("Assign meager portions. Not much, but enough to get the job done People don't leave full, but they're not going hungry either.")
r2.get_next_event_name = returnToStatusScreen
r2.selected_action = function(self, game_data)
	game_data.food_consumption_amount = PartyMember.FoodAmount.Meager
end
changeRations:add_option(r2)

local r3 = Option.new("Assign sparse portions. People are leaving hungry. Oh well. We simply must tighten our belts and keep going.")
r3.get_next_event_name = returnToStatusScreen
r3.selected_action = function(self, game_data)
	game_data.food_consumption_amount = PartyMember.FoodAmount.Sparse
end
changeRations:add_option(r3)

return changeSpeed, changeRations
