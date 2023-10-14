require("src.TextGameFramework.event")
require("src.TextGameFramework.option")
require("src.util")
EventManager = {}
local PATH_SEPERATOR = package.config:sub(1,1)
local EVENT_GROUP_CSV = "event_groups.csv"
local function isLuaFile(fp) return string.sub(fp, #fp - 3, #fp) == ".lua" end
local function get_files_in(path)
	local files = {}
    for _, file in ipairs(love.filesystem.getDirectoryItems(path)) do
        if file ~= "." and file ~= ".." and isLuaFile(file) then
            local f = path..PATH_SEPERATOR..file
			files[#files + 1] = f
        end
    end
	return files
end

--Checks to make sure that no event names are used more than once, warns the user if they are
function EventManager._add_event_relation(self, event, file)
	local nilfile = self._event_name_to_event[event:get_name()]
	if (nilfile ~= nil)
	then
		print(string.format("WARNING: Event \"%s\" in %s is overwriting an event of the same name in %s"), event:get_name(), file, nilfile)
	end
	self._event_name_to_event[event:get_name()] = event
end

function EventManager.get_event(self, name, game_data)
	if not game_data
	then
		erro("game_data is a required parameter")
	end
	local e_group = self._event_group_to_events[name]
	if e_group
	then
		local valid_events = {}
		for _, event in ipairs(e_group)
		do
			if event:can_be_chosen(game_data)
			then
				valid_events[#valid_events + 1] = event
			end
		end
		--error checking, ensuring that any event can be selected, error otherwise
		if #valid_events == 0
		then
			error(string.format("No valid next event in event group %s for current game state", name))
		end
		return e_group[math.random(#valid_events)]
	else
		local event = self._event_name_to_event[name]
		if not event
		then
			error(string.format("Event \"%s\" does not exist.", name))
		end
		return event
	end
end
function EventManager.get_event_group(self, name)
	if type(name) ~= "string"
	then
		error(string.format("name must be a string (was %s)", name))
	end
	local ret_table = self._event_group_to_events[name]
	if not ret_table
	then
		error(string.format("%s is not an event group", name))
	end
	return ret_table
end
function EventManager.new(root_directory)
	local o = {}
	local meta = {__index = EventManager}
	setmetatable(o, meta)
	o._root_directory = root_directory
	o._event_name_to_event = {} --name of event to event object
	o._event_group_to_events = {} -- name of event group to events
	--This section gets the events into a list
	do --package.config.sub gives path seperator
		local event_folder = o._root_directory..PATH_SEPERATOR.."Events"
		--for each file
		for _, file in ipairs(get_files_in(event_folder))
		do
			local event_file_func = love.filesystem.load(file)
			local events = table.pack(event_file_func())
			for _, v in ipairs(events)
			do
				o:_add_event_relation(v, file)
			end
		end		
	end
	--loads the table of event groups: event group name to containing events
	--format of file is that first entry on line is a group name and each subsequent entry is an event in the group
	do
		local event_group_csv = root_directory..PATH_SEPERATOR..EVENT_GROUP_CSV
		local csv_file = love.filesystem.read(event_group_csv)
		local lineNum = 0
		for line in string.gmatch(csv_file, "[^%c]+")
		do
			lineNum = lineNum + 1
			local iterator = string.gmatch(line, "[%a%d%s_]+") --matches any sequence of letters, numbers, underscores, or spaces. Anything else counts as a seperator
			local group_name = iterator() --gets the group name
			if not group_name
			then
				print(string.format("WARNING: Line %d, no group name, skipping"))
				goto continue
			end
			
			local function addEventToGroupList(event_name, event_group) --sends a warning if event not present. Adds to event group if present, if not then does not
				local event = o._event_name_to_event[event_name]
				if event
				then
					event_group[#event_group + 1] = event
				else
					print(string.format("WARNING: Event name %s in event_groups.csv references a non-existant event", event_name))
				end
			end
			
			local events_in_group = {}
			local first_event = iterator() --gets the first event, just to be sure that it is present
			if not first_event
			then
				print(string.format("WARNING: Line %d, no events in event_group, skipping", lineNum))
				goto continue
			else
				addEventToGroupList(first_event, events_in_group)
			end
			
			for subsequent_event_name in iterator
			do
				addEventToGroupList(subsequent_event_name, events_in_group)
			end
			o._event_group_to_events[group_name] = events_in_group
			--validate that at least one event can be selected from event pool no matter the conditions
			for _, v in ipairs(events_in_group)
			do
				if v.can_be_chosen == Event.can_be_chosen
				then
					goto continue
				end
			end
			print(string.format("WARNING: None of the events in group %s are always choosable, potential for infinite loop", group_name)) --only runs if no event in the group is  selectable all the time
			
			::continue::
		end
		
		--Warning if event group name matches with an event name, as the event with that name can't be referred to
		for event_group_name, _ in pairs(o._event_group_to_events)
		do
			if o._event_name_to_event[event_group_name]
			then
				print(string.format("WARNING: Event name %s matches event group name, it will not be possible to refer to this event directly", event_group_name))
			end
		end
	end
	
	
	return o
end


return EventManager