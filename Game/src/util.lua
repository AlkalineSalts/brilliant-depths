--for lua 5.1, implementing table.unpack()
function table.unpack(t)
	function unpacker_helper(t, index)
		local element = t[index]
		if element == nil
		then
			 return nil
		else
			return element, unpacker_helper(t, index + 1)
		end
			
	end
	return unpacker_helper(t, 1)
end

function table.pack(...)
    return { n = select("#", ...), ... }
end


function table.shallowCopy(table)
	local copy = {}
	for key, value in pairs(table)
	do
		copy[key] = value
	end
	return copy
end