package.path = package.path..";../?.lua"
require("option")
local text = "Default Text"
example_option = Option.new(text, true)
--selecting a selectable option
example_option:select()
--test selecting a non selectable option
example_option.is_selectable = function() return false end
didWork = pcall(function() exmaple_option:select() end)
if didWork
then
	print("FAILED: Cannot select a non-selectable option.")
end

--Tess if get text matches  input text
if text ~= example_option:get_text()
then
	print("FAILED: ", example_option:get_text(), " does not match ", text)
end

return nil