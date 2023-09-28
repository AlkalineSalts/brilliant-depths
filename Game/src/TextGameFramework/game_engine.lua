GameEngine = {}
--[[
A class which processes the events.
    current_event : An Event object or string which represents the name of the event that will be started from
    events_dict is a dictionary of event name strings to an event object
    entent_groups is a  dict of names to a list of events
    game_data is a dict of game variables
    For game_data, any dict passed in must identify the name of the current event to process
]]

function GameEngine.get_current_event_text_and_options(this)
	local event_text = this._current_event:get_text(this._game_data)
	local options = this._current_event:get_options(this._game_data)
	return event_text, options
end
	

function GameEngine.new(current_event_name, event_manager, game_data)
	local o = {}
	local meta = {__index = GameEngine}
	setmetatable(o, meta)
	o._event_manager = event_manager
	o._game_data = game_data
	o._current_event = o._event_manager:get_event(current_event_name)
end


return GameEngine

