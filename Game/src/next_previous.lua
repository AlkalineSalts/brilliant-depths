require("src.util")
--Is equivalent to a java interface, do not need to use the code here
--Provides an easy way tp setup array
NextPrevious = {}
function NextPrevious.next(self)
end
function NextPrevious.previous(self)
end
function NextPrevious.current(self) --returns current value
end


--equiv of static method for easy creation o=of this interface
function NextPrevious.getNextPreviousForArray(list, st_index)
	local starting_index = st_index or 1
	if starting_index < 1 or starting_index > #list
	then
		error(string.format("starting index %d out of range of list (length %d)", starting_index, #list))
	end
	--If index fits in list
	local newNextPrevious = {
	index = starting_index,
	list = table.shallowCopy(list),
	next = function (self) if self.index < #self.list then self.index = self.index + 1 end end,
	previous = function (self) if self.index > 1 then self.index = self.index - 1 end end,
	current = function (self) return self.list[self.index] end
	}
	return newNextPrevious
end
	
	