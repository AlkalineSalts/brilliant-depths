--Purpose of this file is to verify task accuracy
local tasks = require("src._tasks")
if not tasks.MainTasks then error("Does not have all of the task categories.") end
for task_list, task in ipairs(tasks)
do
	if not task.score
	then
		error("Missing task.score in "..task_list)
	end
	if not task.text
	then
		error("Missing task.text in "..task_list)
	end
	if not task.is_completed
	then
		error("Missing task.is_completed in "..task_list)
	end
end

function getMainTask(number)
	return tasks.MainTasks[number]
end

return tasks