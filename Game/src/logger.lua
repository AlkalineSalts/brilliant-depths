require("src.util")
--Implementing a logger
Logger = {}

function Logger.startLogger(filepath)
	if not Logger._file
	then
		love.filesystem.remove(filepath)
		love.filesystem.write(filepath, 'initiating log\n')
		Logger._file, errstr = love.filesystem.newFile(filepath)
		local worked, errstr = Logger._file:open("a")
		if not worked
		then
			error(errstr)
		end
	end
end

function Logger.endLogger()
	if Logger._file
	then
		Logger._file:close()
		Logger._file = nil
	end
end

function Logger.log(...)
	if not Logger._file
	then
		error("Must start logger before logging data") 
	end
	local str = table.concat({...}, " ").."\n"
	Logger._file:write(str)
end

print = Logger.log
return Logger